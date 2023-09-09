unit DelphiWinMD.Types;
{
  Delphi winmd parser (c)2023 Execute SARL https://www.execute.fr
}
interface
{$POINTERMATH ON}
uses
  System.Math,
  System.SysUtils;

const
  PE_SIGNATURE = $00004550;

  TABLE_NAMES: array[$00..$2C] of string = (
    'Module',
    'TypeRef',
    'TypeDef',
    '',
    'Field',
    '',
    'MethodDef',
    '',
    'Param',
    'InterfaceImpl',
    'MemberRef',
    'Constant',
    'CustomAttribute',
    'FieldMarshal',
    'DeclSecurity',
    'ClassLayout',
    'FieldLayout',
    'StandAloneSig',
    'EventMap',
    '',
    'Event',
    'PropertyMap',
    '',
    'Property',
    'MethodSemantics',
    'MethodImpl',
    'ModuleRef',
    'TypeSpec',
    'ImplMap',
    'FieldRVA',
    '',
    '',
    'Assembly',
    'AssemblyProcessor',
    'AssemblyOS',
    'AssemblyRef',
    'AssemblyRefProcessor',
    'AssemblyRefOS',
    'File',
    'ExportedType',
    'ManifestResource',
    'NestedClass',
    'GenericParam',
    'MethodSpec',
    'GenericParamConstraint'
  );

type
  IMAGE_DOS_HEADER = packed record { DOS .EXE header }
    magic   : Word; { Magic number }
    cblp    : Word; { Bytes on last page of file }
    cp      : Word; { Pages in file }
    crlc    : Word; { Relocations }
    cparhdr : Word; { Size of header in paragraphs }
    minalloc: Word; { Minimum extra paragraphs needed }
    maxalloc: Word; { Maximum extra paragraphs needed }
    ss      : Word; { Initial (relative) SS value }
    sp      : Word; { Initial SP value }
    csum    : Word; { Checksum }
    ip      : Word; { Initial IP value }
    cs      : Word; { Initial (relative) CS value }
    lfarlc  : Word; { File address of relocation table }
    ovno    : Word; { Overlay number }
    res     : array[0..3] of Word; { Reserved words }
    oemid   : Word; { OEM identifier }
    oeminfo : Word; { OEM information }
    res2    : array[0..9] of Word; { Reserved words }
    lfanew  : Cardinal; { File address of new exe header }
  end;

  IMAGE_FILE_HEADER = packed record
    Machine              : Word; { Intel 386 = $014C }
    NumberOfSections     : Word;
    TimeDateStamp        : Cardinal;
    PointerToSymbolTable : Cardinal;
    NumberOfSymbols      : Cardinal;
    SizeOfOptionalHeader : Word;
    Characteristics      : Word;
  end;

  IMAGE_OPTIONAL_HEADER = packed record
    Magic                       : Word;
    MajorLinkerVersion          : Byte;
    MinorLinkerVersion          : Byte;
    SizeOfCode                  : Cardinal;
    SizeOfInitializedData       : Cardinal;
    SizeOfUninitializedData     : Cardinal;
    AddressOfEntryPoint         : Cardinal;
    BaseOfCode                  : Cardinal;
    BaseOfData                  : Cardinal;
    ImageBase                   : Cardinal;
    SectionAlignment            : Cardinal;
    FileAlignment               : Cardinal;
    MajorOperatingSystemVersion : Word;
    MinorOperatingSystemVersion : Word;
    MajorImageVersion           : Word;
    MinorImageVersion           : Word;
    MajorSubsystemVersion       : Word;
    MinorSubsystemVersion       : Word;
    Win32VersionValue           : Cardinal;
    SizeOfImage                 : Cardinal;
    SizeOfHeaders               : Cardinal;
    Checksum                    : Cardinal;
    Subsystem                   : Word;
    DllCharacteristics          : Word;
    SizeOfStackReserve          : Cardinal;
    SizeOfStackCommit           : Cardinal;
    SizeOfHeapReserve           : Cardinal;
    SizeOfHeapCommit            : Cardinal;
    LoaderFlags                 : Cardinal;
    NumberOfRvaAndSizes         : Cardinal;
  end;

  IMAGE_NT_HEADERS = packed record
    Signature     : Cardinal; { 'PE'00 = $4550 }
    FileHeader    : IMAGE_FILE_HEADER;
    OptionalHeader: IMAGE_OPTIONAL_HEADER;
  end;

  IMAGE_DATA_DIRECTORY = packed record
    VirtualAddress : Cardinal;
    Size           : Cardinal;
  end;

  IMAGE_SECTION_HEADER=packed record
    Name                : array[0..7] of AnsiChar;
    VirtualSize         : Cardinal; { PhysicalAddress }
    VirtualAddress      : Cardinal;
    SizeOfRawData       : Cardinal;
    PointerToRawData    : Cardinal;
    PointerToRelocations: Cardinal;
    PointerToLinenumbers: Cardinal;
    NumberOfRelocations : Word;
    NumberOfLinenumbers : Word;
    Characteristics     : Cardinal;
  end;

  DOTNET_DIRECTORY = packed record
    cb: Cardinal;
    MajorRuntimeVersion: Word;
    MinorRuntumeVersion: Word;
    MetaDataRVA: Cardinal;
    MetaDataSize: Cardinal;
    Flags: Cardinal;
    EntryPointToken: Cardinal;
    ResourcesRVA: Cardinal;
    ResourcesSize: Cardinal;
    StrongNameSignatureRVA: Cardinal;
    StrongNameSignatureSize: Cardinal;
    CodeManagerTableRVA: Cardinal;
    CodeManagerTableSize: Cardinal;
    VTableFixupsRVA: Cardinal;
    VTableFuxupsSize: Cardinal;
    ExportAddressTableJumpsRVA: Cardinal;
    ExportAddressTableJumpsSize: Cardinal;
    ManagedNativeHeaderRVA: Cardinal;
    ManagedNativeHeaderSize: Cardinal;
  end;

  TMetaDataStream = record
    Offset: Cardinal;
    Size  : Cardinal;
    Name  : string;   // Up to 32
  end;
  PMetaDataStream = ^TMetaDataStream;

  // “#Strings” points to the physical representation of the string heap where identifier strings are stored
  //   null-terminated UTF8Strings, can contain garbage,  the first entry is always the empty string

  // “#Blob” points to the physical representation of the blob heap
  //   Individual blobs are stored with their length encoded in the first few bytes
  //    $00..$7F: single byte size
  //    $80..$BF: 15bits size (b1 and $7F) shl 8 + b2
  //    $C0..$FD: 29bits size (b1 and $1F) shl 24 + b2 shl 16 + b3 shl 8 + b4

  // “#US” points to the physical representation of the user string heap
  //   Unicode16 strings, the size is a number of Byte (not Char) + a single #0 or #1 for UTF16

  // “#GUID” points to the physical representation of the GUID heap
  //   128bit GUIDs

  // “#~” points to the physical representation of a set of tables
  //  METADATA_TABLE_HEADER

  METADATA_HEADER = packed record
    Signature: Cardinal;               // $424A5342
    MajorVersion: Word;                // 1
    MinorVersion: Word;                // 1
    Reserved: Cardinal;                // 0
    VersionLength: Cardinal;           // padded length of VersionString
    function VersionString: string;    // UTF8 null-terminated string  (Up to 255)
    function Flags: Word;              // 0
    function NumberOfStreams: Word;
    function GetStreams: TArray<TMetaDataStream>;
  end;
  PMETADATA_HEADER = ^METADATA_HEADER;

const
  TABLE_NULL = $03; // 03 is not used

  TABLE_Assembly = $20;
  TABLE_AssemblyOS = $22;
  TABLE_AssemblyProcessor = $21;
  TABLE_AssemblyRef = $23;
  TABLE_AssemblyRefOS = $25;
  TABLE_AssemblyRefProcessor = $24;
  TABLE_ClassLayout = $0F;
  TABLE_Constant = $0B;
  TABLE_CustomAttribute = $0C;
  TABLE_DeclSecurity = $0E;
  TABLE_EventMap = $12;
  TABLE_Event = $14;
  TABLE_ExportedType = $27;
  TABLE_Field = $04;
  TABLE_FieldLayout = $10;
  TABLE_FieldMarshal = $0D;
  TABLE_FieldRVA = $1D;
  TABLE_File = $26;
  TABLE_GenericParam = $2A;
  TABLE_GenericParamConstraint = $2C;    //
  TABLE_ImplMap = $1C;
  TABLE_InterfaceImpl = $09;
  TABLE_ManifestResource = $28;
  TABLE_MemberRef = $0A;
  TABLE_MethodDef = $06;
  TABLE_MethodImpl = $19;
  TABLE_MethodSemantics = $18;
  TABLE_MethodSpec = $2B;
  TABLE_Module = $00;                    // Generation: Word; Name: string; MVid, EncId, EncBaseId: TGUID
  TABLE_ModuleRef = $1A;
  TABLE_NestedClass = $29;
  TABLE_Param = $08;
  TABLE_Property = $17;
  TABLE_PropertyMap = $15;
  TABLE_StandAloneSig = $11;
  TABLE_TypeDef = $02;
  TABLE_TypeRef = $01;
  TABLE_TypeSpec = $1B;

//  $00 TABLE_Module
//  $01 TABLE_TypeRef
//  $02 TABLE_TypeDef
//  $03
//  $04 TABLE_Field
//  $05
//  $06 TABLE_MethodDef
//  $07
//  $08 TABLE_Param
//  $09 TABLE_InterfaceImpl
//  $0A TABLE_MemberRef
//  $0B TABLE_Constant
//  $0C TABLE_CustomAttribute
//  $0D TABLE_FieldMarshal
//  $0E TABLE_DeclSecurity
//  $0F TABLE_ClassLayout
//  $10 TABLE_FieldLayout
//  $11 TABLE_StandAloneSig
//  $12 TABLE_EventMap
//  $13
//  $14 TABLE_Event
//  $15 TABLE_PropertyMap
//  $16
//  $17 TABLE_Property
//  $18 TABLE_MethodSemantics
//  $19 TABLE_MethodImpl
//  $1A TABLE_ModuleRef
//  $1B TABLE_TypeSpec
//  $1C TABLE_ImplMap
//  $1D TABLE_FieldRVA
//  $1E
//  $1F
//  $20 TABLE_Assembly
//  $21 TABLE_AssemblyProcessor
//  $22 TABLE_AssemblyOS
//  $23 TABLE_AssemblyRef
//  $24 TABLE_AssemblyRefProcessor
//  $25 TABLE_AssemblyRefOS
//  $26 TABLE_File
//  $27 TABLE_ExportedType
//  $28 TABLE_ManifestResource
//  $29 TABLE_NestedClass
//  $2A TABLE_GenericParam
//  $2B TABLE_MethodSpec
//  $2C TABLE_GenericParamConstraint


type
  TFieldType = (
    ftWord,
    ftCardinal,
    ftString,
    ftGUID,
    ftBlob,
  // Table Index
    ftAssemblyRef,
    ftEvent,
    ftField,
    ftGenericParam,
    ftMethodDef,
    ftModuleRef,
    ftParam,
    ftProperty,
    ftTypeDef,
  // Composite Index
    ftCustomAttributeType,
    ftHasConstant,
    ftHasCustomAttribute,
    ftHasDeclSecurity,
    ftHasFieldMarshal,
    ftHasSemantics,
    ftImplementation,
    ftMemberForwarded,
    ftMemberRefParent,
    ftMethodDefOrRef,
    ftResolutionScope,
    ftTypeDefOrRef,
    ftTypeOrMethodDef
  );

  TFieldDef = record
    FieldName : string;
    FieldType : TFieldType;
  end;
  PFieldDef = ^TFieldDef;

  TTableInfo = record
    TableIndex : Byte;
    TableName  : string;
    FieldCount : Integer;
    FieldDefs  : PFieldDef;
    RecordCount: UInt64;
    RecordSize : Cardinal;
    TableOffset: Cardinal;
  end;
  PTableInfo = ^TTableInfo;

  TTablesInfo = record
    TableCount : Cardinal;
    TableInfo  : array[$00..$2C] of TTableInfo;
  end;

  TModule = record
    Generation: Word;
    Name      : string;
    Mvid      : TGUID;
    EncId     : TGUID;
    EncBaseId : TGUID;
  end;

  METADATA_TABLE_HEADER = packed record  // #~ Stream header
    Reserved1: Cardinal;     // 0
    MajorVersion: Byte;      // 2
    MinorVersion: Byte;      // 0
    HeapSizes: Byte;         // index size is 2 or 4 bytes according to bit 0 for #String, 1 for #GUID and 2 for #Blob
    Reserved2: Byte;
    Valid: UInt64;           // n = number of (bit = 1)
    Sorted: UInt64;
  // Rows: array of n Cardinal indicating the number of rows for each present table
  // Tables
    function Tail: PByte;
    procedure GetTablesInfo(var Info: TTablesInfo);
    function ReadIndex(var P: PByte; Flag: Byte): Cardinal;
  end;
  PMETADATA_TABLE_HEADER = ^METADATA_TABLE_HEADER;

  TTableReader = record
  private
    FData: TBytes;
    FHeader: PMETADATA_HEADER;
    FStreams: TArray<TMetaDataStream>;
    FTables: PMetaDataStream;
    FStrings: PMetaDataStream;
    FGUIDs: PMetaDataStream;
    FTableHeader: PMETADATA_TABLE_HEADER;
    FFieldSize: array [TFieldType] of Byte;
    FIndexShift: array [ftCustomAttributeType..ftTypeOrMethodDef] of Byte;
    procedure Parse;
    function IndexFlag(Flag: Integer): Integer;
    function IndexSize(Table: Integer): Integer;
    function RecordSize(Table: Integer): Integer;
    procedure CompositeIndexSize(const Tables: array of Byte; var Size, Shift: Byte);
    procedure ReadWord(var W: Word; var P: PByte);
    procedure ReadString(var S: string; var P: PByte);
    procedure ReadGUID(var G: TGUID; var P: PByte);
    function ReadIndex(FieldType: TFieldType; var P: PByte): Cardinal;
  public
    Info: TTablesInfo;
    Module: TModule;
    constructor Create(AData: TBytes);
    function GetValue(Table, Row, Col: Cardinal): string;
  end;


implementation

uses DelphiWinMD.FieldDefs;

function Align4(I: Cardinal): Cardinal;
begin
  Result := I + (4 - I and 3) and 3;
end;

{ METADATA_HEADER }

function METADATA_HEADER.Flags: Word;
begin
  Result := PWord(@PByte(@Self)[SizeOf(Self) + VersionLength])^;
end;

function METADATA_HEADER.NumberOfStreams: Word;
begin
  Result := PWord(@PByte(@Self)[SizeOf(Self) + VersionLength + SizeOf(Word)])^;
end;

function METADATA_HEADER.GetStreams: TArray<TMetaDataStream>;
begin
  SetLength(Result, NumberOfStreams);
  var P: PByte := @PByte(@Self)[SizeOf(Self) + VersionLength + 2 * SizeOf(Word)];
  for var I := 0 to Length(Result) - 1 do
  begin
    Move(P^, Result[I].Offset, 2 * SizeOf(Cardinal));
    Inc(P, 2 * SizeOf(Cardinal));
    Result[I].Name := string(PAnsiChar(P));
    Inc(P, Align4(Length(Result[I].Name) + 1));
  end;
end;

function METADATA_HEADER.VersionString: string;
begin
  Result := string(UTF8String(PAnsiChar(@PByte(@Self)[SizeOf(Self)])));
end;

{ METADATA_TABLE_HEADER }

procedure METADATA_TABLE_HEADER.GetTablesInfo(var Info: TTablesInfo);
begin
  FillChar(Info, SizeOf(Info), 0);
  var bit: UInt64 := 1;
  var Count := PCardinal(Tail);
{$IFDEF DEBUG}var Bits := Valid;{$ENDIF}
  for var T := Low(Info.TableInfo) to High(Info.TableInfo) do
  begin
    if Valid and bit > 0 then
    begin
    {$IFDEF DEBUG}Dec(Bits, bit);{$ENDIF}
      Inc(Info.TableCount);
      Info.TableInfo[T].RecordCount := Count^;
      Inc(Count);
    end;
    bit := bit shl 1;
  end;
{$IFDEF DEBUG}Assert(Bits = 0);{$ENDIF}
end;

function METADATA_TABLE_HEADER.ReadIndex(var P: PByte; Flag: Byte): Cardinal;
begin
  if HeapSizes and Flag > 0 then
  begin
    Result := PCardinal(P)^;
    Inc(P, 4);
  end else begin
    Result := PWord(P)^;
    Inc(P, 2);
  end;
end;

function METADATA_TABLE_HEADER.Tail: PByte;
begin
  Result := @PByte(@Self)[SizeOf(Self)];
end;

{ TTableReader }

procedure TTableReader.CompositeIndexSize(const Tables: array of Byte; var Size, Shift: Byte);
begin
  var bits := 1;
  var len := Length(Tables) - 1;
  while len > 1 do
  begin
    len := len shr 1;
    Inc(bits);
  end;
  Assert((Length(Tables) <> 2) or (bits = 1));
  Assert((Length(Tables) <> 3) or (bits = 2));
  Assert((Length(Tables) <> 4) or (bits = 2));
  Assert((Length(Tables) <> 5) or (bits = 3));

  Shift := bits;

  var Count := Info.TableInfo[Tables[0]].RecordCount;
  for var I := 1 to Length(Tables) - 1 do
  begin
    Count := Max(Count, Info.TableInfo[Tables[I]].RecordCount);
  end;
  if Count > 1 shl (16 - bits) then
    Size := 4
  else
    Size := 2;
end;

constructor TTableReader.Create(AData: TBytes);
begin
  FData := AData;
  Parse;
end;

function TTableReader.GetValue(Table, Row, Col: Cardinal): string;
begin
  if Row < 0 then
    Exit('(null)');

  Assert((Table >= LOW(TABLE_FIELDS)) and (Table <= HIGH(TABLE_FIELDS)));
  Assert(Col < TABLE_FIELDS[Table].FieldCount);
  Assert(Row < Info.TableInfo[Table].RecordCount, 'Record#' + Row.ToString + ' / ' + Info.TableInfo[Table].RecordCount.ToString);

  var P: PByte := @FTableHeader.Tail[Info.TableInfo[Table].TableOffset + Info.TableInfo[Table].RecordSize * Row];
  var F := TABLE_FIELDS[Table].FieldDefs;

  while Col > 0 do
  begin
    Inc(P, FFieldSize[F^.FieldType]);
    Inc(F);
    Dec(Col);
  end;
  case F.FieldType of
    ftWord       : Result := PWord(P)^.ToString;
    ftCardinal   : Result := PCardinal(P)^.ToString;
    ftString     : ReadString(Result, P);
    ftGUID       :
    begin
      var G: TGUID;
      ReadGUID(G, P);
      Result := G.ToString;
    end;
    ftBlob       : Result := '(Blob)';

    ftAssemblyRef.. ftTypeDef:
    begin
      var RefTable := TableRef[F.FieldType];
      Result := GetValue(RefTable, ReadIndex(F.FieldType, P), TableLabel[RefTable]);
    end;

    ftCustomAttributeType .. ftTypeOrMethodDef:
    begin
      var Index := ReadIndex(F.FieldType, P);
      if Index = 0 then
        Exit('(nil)');
      var Source := Index and ((1 shl FIndexShift[F.FieldType]) - 1);
      Index := (Index shr FIndexShift[F.FieldType]) - 1;
      var RefTable := CompositeIndex[F.FieldType, Source];

//      Result := '->' + Info.TableInfo[RefTable].TableName;
//      var lbl := TableLabel[RefTable];
//      if lbl < TABLE_FIELDS[RefTable].FieldCount then
//        Result := Result + '.' + TABLE_FIELDS[RefTable].FieldDefs[lbl].FieldName;

      Result := '->' + GetValue(RefTable, Index, TableLabel[RefTable]);
    end;

  else
    Result := '??';
  end;
end;

function TTableReader.IndexFlag(Flag: Integer): Integer;
begin
  if FTableHeader.HeapSizes and Flag > 0 then
    Result := 4
  else
    Result := 2;
end;

function TTableReader.IndexSize(Table: Integer): Integer;
begin
  if Info.TableInfo[Table].RecordCount < UInt64(1) shl 16 then
    Result := 2
  else
    result := 4;
end;

procedure TTableReader.Parse;
begin
  FHeader := PMETADATA_HEADER(FData);
  FStreams := FHeader.GetStreams;
  for var I := 0 to Length(FStreams) - 1 do
  begin
    if FStreams[I].Name = '#~' then
      FTables := @FStreams[I]
    else
    if FStreams[I].Name = '#Strings' then
      FStrings := @FStreams[I]
    else
    if FStreams[I].Name = '#GUID' then
      FGUIDs := @FStreams[I];
  end;
  FTableHeader := PMETADATA_TABLE_HEADER(@FData[FTables.Offset]);
  FTableHeader.GetTablesInfo(Info);

  // Simple Types
  FFieldSize[ftWord] := 2;
  FFieldSize[ftCardinal] := 4;
  FFieldSize[ftString] := IndexFlag(1);
  FFieldSize[ftGUID] := IndexFlag(2);
  FFieldSize[ftBlob] := IndexFlag(4);
  // Table Index
  FFieldSize[ftAssemblyRef] := IndexSize(TABLE_AssemblyRef);
  FFieldSize[ftEvent] := IndexSize(TABLE_Event);
  FFieldSize[ftField] := IndexSize(TABLE_Field);
  FFieldSize[ftGenericParam] := IndexSize(TABLE_GenericParam);
  FFieldSize[ftMethodDef] := IndexSize(TABLE_MethodDef);
  FFieldSize[ftModuleRef] := IndexSize(TABLE_ModuleRef);
  FFieldSize[ftParam] := IndexSize(TABLE_Param);
  FFieldSize[ftProperty] := IndexSize(TABLE_Property);
  FFieldSize[ftTypeDef] := IndexSize(TABLE_TypeDef);
  // Composite Index
  for var T := ftCustomAttributeType to ftTypeOrMethodDef do
    CompositeIndexSize(CompositeIndex[T], FFieldSize[T], FIndexShift[T]);

  var Offset := Info.TableCount * SizeOf(Cardinal);
  for var T := Low(Info.TableInfo) to High(Info.TableInfo) do
  begin
    Info.TableInfo[T].TableIndex := T;
    Info.TableInfo[T].TableName := TABLE_NAMES[T];
    if Info.TableInfo[T].RecordCount > 0 then
    begin
      Info.TableInfo[T].TableOffset := Offset;
      Info.TableInfo[T].FieldCount := TABLE_FIELDS[T].FieldCount;
      Info.TableInfo[T].FieldDefs := TABLE_FIELDS[T].FieldDefs;
      Info.TableInfo[T].RecordSize := RecordSize(T);
      Inc(Offset, Info.TableInfo[T].RecordCount * Info.TableInfo[T].RecordSize);
    end;
  end;

  var P: PByte := @FTableHeader.Tail[Info.TableCount * SizeOf(Cardinal)];
  ReadWord(Module.Generation, P);
  ReadString(Module.Name, P);
  ReadGUID(Module.Mvid, P);
  ReadGUID(Module.EncId, P);
  ReadGUID(Module.EncBaseId, P);
end;

procedure TTableReader.ReadGUID(var G: TGUID; var P: PByte);
begin
  var Index := FTableHeader.ReadIndex(P, 2);
  if Index = 0 then
    FillChar(G, SizeOf(G), 0)
  else begin
    Move(FData[FGUIDs.Offset + (Index - 1) * SizeOf(TGUID)], G, SizeOf(TGUID));
  end;
end;

function TTableReader.ReadIndex(FieldType: TFieldType; var P: PByte): Cardinal;
begin
  var Size := FFieldSize[FieldType];
  case Size of
    2: Result := PWord(P)^;
    4: Result := PCardinal(P)^;
  else
    raise Exception.Create('Invalid index size');
  end;
  Inc(P, Size);
end;

procedure TTableReader.ReadString(var S: string; var P: PByte);
begin
  var Index := FTableHeader.ReadIndex(P, 1);
  var Str := PUTF8Char(@FData[FStrings.Offset + Index]);
  S := string(UTF8String(Str));
end;

procedure TTableReader.ReadWord(var W: Word; var P: PByte);
begin
  W := PWord(P)^;
  Inc(P, 2);
end;

function TTableReader.RecordSize(Table: Integer): Integer;
begin
  Result := 0;
  var F := TABLE_FIELDS[Table].FieldDefs;
  for var I := 0 to TABLE_FIELDS[Table].FieldCount - 1 do
  begin
    Inc(Result, FFieldSize[F.FieldType]);
    Inc(F);
  end;

end;

end.
