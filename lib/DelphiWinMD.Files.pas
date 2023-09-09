unit DelphiWinMD.Files;
{
  Delphi winmd parser (c)2023 Execute SARL https://www.execute.fr
}
interface

uses
  System.Classes,
  System.SysUtils,
  DelphiWinMD.Types;

type
  TTableEnumProc = reference to procedure(const TableInfo: TTableInfo);

  TWinMDFile = class
  private
    FStream  : TStream;
    FSections: array of IMAGE_SECTION_HEADER;
    FTables  : TTableReader;
    procedure Parse;
    procedure VirtualSeek(VirtualOffset: Cardinal);
  public
    destructor Destroy; override;
    procedure LoadFromFile(const AFileName: string);
    procedure Close;
    procedure ForEachTable(Proc: TTableEnumProc);
    function GetValue(Table, Row, Col: Integer): string;
    property Module: string read FTables.Module.Name;
  end;

implementation

{ TWinMDFile }

procedure TWinMDFile.Close;
begin
  FreeAndNil(FStream);
end;

destructor TWinMDFile.Destroy;
begin
  Close;
  inherited;
end;

procedure TWinMDFile.ForEachTable(Proc: TTableEnumProc);
begin
  for var I := Low(FTables.Info.TableInfo) to High(FTables.Info.TableInfo) do
  begin
    Proc(FTables.Info.TableInfo[I]);
  end;
end;

function TWinMDFile.GetValue(Table, Row, Col: Integer): string;
begin
  Result := FTables.GetValue(Table, Row, Col);
end;

procedure TWinMDFile.LoadFromFile(const AFileName: string);
begin
  Close;
  FStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Parse;
  except
    Close;
    raise;
  end;
end;

procedure TWinMDFile.Parse;
var
  va: array of IMAGE_DATA_DIRECTORY;
begin
  var dos: IMAGE_DOS_HEADER;
  FStream.ReadBuffer(dos, SizeOf(dos));
  if dos.magic <> $5A4D then
    raise Exception.Create('Invalid file format');
  FStream.Position := dos.lfanew;

  var nt: IMAGE_NT_HEADERS;
  FStream.ReadBuffer(nt, SizeOf(nt));
  if nt.Signature <> PE_SIGNATURE then
    raise Exception.Create('Invalid file format');

  SetLength(va, nt.OptionalHeader.NumberOfRvaAndSizes);
  FStream.ReadBuffer(va[0], Length(va) * SizeOf(IMAGE_DATA_DIRECTORY));

  SetLength(FSections, nt.FileHeader.NumberOfSections);
  FStream.Position := dos.lfanew + SizeOf(IMAGE_NT_HEADERS) - SizeOf(IMAGE_OPTIONAL_HEADER) + nt.FileHeader.SizeOfOptionalHeader;
  FStream.ReadBuffer(FSections[0], Length(FSections) * SizeOf(IMAGE_SECTION_HEADER));

  VirtualSeek(va[14].VirtualAddress);

  var dotNet: DOTNET_DIRECTORY;
  FStream.ReadBuffer(dotNet, SizeOf(dotNet));
  VirtualSeek(dotNet.MetaDataRVA);

  var metaData: TBytes;
  SetLength(metaData, dotNet.MetaDataSize);
  FStream.ReadBuffer(metaData[0], Length(metaData));

//  WriteLn(PMETADATA_HEADER(metaData).VersionString);
//  WriteLn(PMETADATA_HEADER(metaData).Flags);
//  WriteLn(PMETADATA_HEADER(metaData).NumberOfStreams); // 5
//
  FTables := TTableReader.Create(metaData);
end;

procedure TWinMDFile.VirtualSeek(VirtualOffset: Cardinal);
begin
  for var I := 0 to Length(FSections) - 1 do
  begin
    if (FSections[I].VirtualAddress <= VirtualOffset)
    and(FSections[I].VirtualAddress + FSections[I].VirtualSize > VirtualOffset) then
    begin
      FStream.Position := FSections[I].PointerToRawData + VirtualOffset - FSections[I].VirtualAddress;
      Exit;
    end;
  end;
  raise Exception.Create('Invalid virtual offset');
end;

end.
