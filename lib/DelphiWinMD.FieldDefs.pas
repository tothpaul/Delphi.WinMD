unit DelphiWinMD.FieldDefs;
{
  Delphi winmd parser (c)2023 Execute SARL https://www.execute.fr
}
interface

uses
  DelphiWinMD.Types;

type
  TTableDef = record
    FieldCount: Byte;
    FieldDefs : PFieldDef;
  end;

const
  FIELDS_Assembly: array[0..8] of TFieldDef = (
    (FieldName: 'HashAlgId';      FieldType: ftCardinal),
    (FieldName: 'MajorVersion';   FieldType: ftWord),
    (FieldName: 'MinorVersion';   FieldType: ftWord),
    (FieldName: 'BuildNumber';    FieldType: ftWord),
    (FieldName: 'RevisionNumber'; FieldType: ftWord),
    (FieldName: 'Flags';          FieldType: ftCardinal),
    (FieldName: 'PublicKey';      FieldType: ftBlob),
    (FieldName: 'Name';           FieldType: ftString),
    (FieldName: 'Culture';        FieldType: ftString)
  );

  FIELDS_AssemblyOS: array[0..2] of TFieldDef = (
    (FieldName: 'OSPlatformID';   FieldType: ftCardinal),
    (FieldName: 'OSMajorVersion'; FieldType: ftCardinal),
    (FieldName: 'OSMinorVersion'; FieldType: ftCardinal)
  );

  FIELDS_AssemblyProcessor: array[0..0] of TFieldDef = (
    (FieldName: 'Processor'; FieldType: ftCardinal)
  );

  FIELDS_AssemblyRef: array[0..8] of TFieldDef = (
    (FieldName: 'MajorVersion';     FieldType: ftWord),
    (FieldName: 'MinorVersion';     FieldType: ftWord),
    (FieldName: 'BuildNumber';      FieldType: ftWord),
    (FieldName: 'RevisionNumber';   FieldType: ftWord),
    (FieldName: 'Flags';            FieldType: ftCardinal),
    (FieldName: 'PublicKeyOrToken'; FieldType: ftBlob),
    (FieldName: 'Name';             FieldType: ftString),
    (FieldName: 'Culture';          FieldType: ftString),
    (FieldName: 'HashValue';        FieldType: ftBlob)
  );

  FIELDS_AssemblyRefOS: array[0..3] of TFieldDef = (
    (FieldName: 'OSPlatformId';   FieldType: ftCardinal),
    (FieldName: 'OSMajorVersion'; FieldType: ftCardinal),
    (FieldName: 'OSMinorVersion'; FieldType: ftCardinal),
    (FieldName: 'AssemblyRef';    FieldType: ftAssemblyRef)
  );

  FIELDS_AssemblyRefProcessor: array[0..1] of TFieldDef = (
    (FieldName: 'Processor';   FieldType: ftCardinal),
    (FieldName: 'AssemblyRef'; FieldType: ftAssemblyRef)
  );

  FIELDS_ClassLayout: array[0..2] of TFieldDef = (
    (FieldName: 'PackingSize'; FieldType: ftWord),
    (FieldName: 'ClassSize';   FieldType: ftCardinal),
    (FieldName: 'Parent';      FieldType: ftTypeDef)
  );

  FIELDS_Constant: array[0..2] of TFieldDef = (
    (FieldName: 'Type';   FieldType: ftWord),
    (FieldName: 'Parent'; FieldType: ftHasConstant),
    (FieldName: 'Value';  FieldType: ftBlob)
  );

  FIELDS_CustomAttribute: array[0..2] of TFieldDef = (
    (FieldName: 'Parent'; FieldType: ftHasCustomAttribute),
    (FieldName: 'Type';   FieldType: ftCustomAttributeType),
    (FieldName: 'Value';  FieldType: ftBlob)
  );

  FIELDS_DeclSecurity: array[0..2] of TFieldDef = (
    (FieldName: 'Action';        FieldType: ftWord),
    (FieldName: 'Parent';        FieldType: ftHasDeclSecurity),
    (FieldName: 'PermissionSet'; FieldType: ftBlob)
  );

  FIELDS_Event: array[0..2] of TFieldDef = (
    (FieldName: 'EventFlags'; FieldType: ftWord),
    (FieldName: 'Name';       FieldType: ftString),
    (FieldName: 'EventType';  FieldType: ftTypeDef)
  );

  FIELDS_EventMap: array[0..1] of TFieldDef = (
    (FieldName: 'Parent';    FieldType: ftTypeDef),
    (FieldName: 'EventList'; FieldType: ftEvent)
  );

  FIELDS_ExportedType: array[0..4] of TFieldDef = (
    (FieldName: 'Flags';          FieldType: ftCardinal),
    (FieldName: 'TypeDefId';      FieldType: ftCardinal),
    (FieldName: 'TypeName';       FieldType: ftString),
    (FieldName: 'TypeNamespace';  FieldType: ftString),
    (FieldName: 'Implementation'; FieldType: ftImplementation)
  );

  FIELDS_Field: array[0..2] of TFieldDef = (
    (FieldName: 'Flags';     FieldType: ftWord),
    (FieldName: 'Name';      FieldType: ftString),
    (FieldName: 'Signature'; FieldType: ftBlob)
  );

  FIELDS_FieldLayout: array[0..1] of TFieldDef = (
    (FieldName: 'Offset'; FieldType: ftCardinal),
    (FieldName: 'Field';  FieldType: ftField)
  );

  FIELDS_FieldMarshal: array[0..1] of TFieldDef = (
    (FieldName: 'Parent';     FieldType: ftHasFieldMarshal),
    (FieldName: 'NativeType'; FieldType: ftBlob)
  );

  FIELDS_FieldRVA: array[0..1] of TFieldDef = (
    (FieldName: 'RVA';   FieldType: ftCardinal),
    (FieldName: 'Field'; FieldType: ftField)
  );

  FIELDS_File: array[0..2] of TFieldDef = (
    (FieldName: 'Flags';     FieldType: ftCardinal),
    (FieldName: 'Name';      FieldType: ftString),
    (FieldName: 'HashValue'; FieldType: ftBlob)
  );

  FIELDS_GenericParam: array[0..3] of TFieldDef = (
    (FieldName: 'Number'; FieldType: ftWord),
    (FieldName: 'Flags';  FieldType: ftWord),
    (FieldName: 'Owner';  FieldType: ftTypeOrMethodDef),
    (FieldName: 'Name';   FieldType: ftString)
  );

  FIELDS_GenericParamConstraint: array[0..1] of TFieldDef = (
    (FieldName: 'Owner';      FieldType: ftGenericParam),
    (FieldName: 'Constraint'; FieldType: ftTypeDefOrRef)
  );

  FIELDS_ImplMap: array[0..3] of TFieldDef = (
    (FieldName: 'MappingFlags';    FieldType: ftWord),
    (FieldName: 'MemberForwarded'; FieldType: ftMemberForwarded),
    (FieldName: 'ImportName';      FieldType: ftString),
    (FieldName: 'ImportScope';     FieldType: ftModuleRef)
  );

  FIELDS_InterfaceImpl: array[0..1] of TFieldDef = (
    (FieldName: 'Class';     FieldType: ftTypeDef),
    (FieldName: 'Interface'; FieldType: ftTypeDefOrRef)
  );

  FIELDS_ManifestResource: array[0..3] of TFieldDef = (
    (FieldName: 'Offset';         FieldType: ftCardinal),
    (FieldName: 'Flags';          FieldType: ftCardinal),
    (FieldName: 'Name';           FieldType: ftString),
    (FieldName: 'Implementation'; FieldType: ftImplementation)
  );

  FIELDS_MethodDef: array[0..5] of TFieldDef = (
    (FieldName: 'RVA';       FieldType: ftCardinal),
    (FieldName: 'ImplFlags'; FieldType: ftWord),
    (FieldName: 'Flags';     FieldType: ftWord),
    (FieldName: 'Name';      FieldType: ftString),
    (FieldName: 'Signature'; FieldType: ftBlob),
    (FieldName: 'ParamList'; FieldType: ftParam)
  );

  FIELDS_MemberRef: array[0..2] of TFieldDef = (
    (FieldName: 'Class';     FieldType: ftMemberRefParent),
    (FieldName: 'Name';      FieldType: ftString),
    (FieldName: 'Signature'; FieldType: ftBlob)
  );

  FIELDS_MethodImpl: array[0..2] of TFieldDef = (
    (FieldName: 'Class';             FieldType: ftTypeDef),
    (FieldName: 'MethodBody';        FieldType: ftMethodDefOrRef),
    (FieldName: 'MethodDeclaration'; FieldType: ftMethodDefOrRef)
  );

  FIELDS_MethodSemantics: array[0..2] of TFieldDef = (
    (FieldName: 'Semantics';   FieldType: ftWord),
    (FieldName: 'Method';      FieldType: ftMethodDef),
    (FieldName: 'Association'; FieldType: ftHasSemantics)
  );

  FIELDS_MethodSpec: array[0..1] of TFieldDef = (
    (FieldName: 'Method';        FieldType: ftMethodDefOrRef),
    (FieldName: 'Instantiation'; FieldType: ftBlob)
  );

  FIELDS_Module: array[0..4] of TFieldDef = (
    (FieldName: 'Generation'; FieldType: ftWord),
    (FieldName: 'Name';       FieldType: ftString),
    (FieldName: 'Mvid';       FieldType: ftGUID),
    (FieldName: 'EncId';      FieldType: ftGUID),
    (FieldName: 'EncBaseId';  FieldType: ftGUID)
  );

  FIELDS_ModuleRef: array[0..0] of TFieldDef = (
    (FieldName: 'Name'; FieldType: ftString)
  );

  FIELDS_NestedClass: array[0..1] of TFieldDef = (
    (FieldName: 'NestedClass';    FieldType: ftTypeDef),
    (FieldName: 'EnclosingClass'; FieldType: ftTypeDef)
  );

  FIELDS_Param: array[0..2] of TFieldDef = (
    (FieldName: 'Flags';    FieldType: ftWord),
    (FieldName: 'Sequence'; FieldType: ftWord),
    (FieldName: 'Name';     FieldType: ftString)
  );

  FIELDS_Property: array[0..2] of TFieldDef = (
    (FieldName: 'Flags'; FieldType: ftWord),
    (FieldName: 'Name';  FieldType: ftString),
    (FieldName: 'Type';  FieldType: ftBlob)
  );

  FIELDS_PropertyMap: array[0..1] of TFieldDef = (
    (FieldName: 'Parent';       FieldType: ftTypeDef),
    (FieldName: 'PropertyList'; FieldType: ftProperty)
  );

  FIELDS_StandAloneSig: array[0..0] of TFieldDef = (
    (FieldName: 'Signature'; FieldType: ftBlob)
  );

  FIELDS_TypeDef: array[0..5] of TFieldDef = (
    (FieldName: 'Flags';         FieldType: ftCardinal),
    (FieldName: 'TypeName';      FieldType: ftString),
    (FieldName: 'TypeNamespace'; FieldType: ftString),
    (FieldName: 'Extends';       FieldType: ftTypeDefOrRef),
    (FieldName: 'FieldList';     FieldType: ftField),
    (FieldName: 'MethodList';    FieldType: ftMethodDef)
  );

  FIELDS_TypeRef: array[0..2] of TFieldDef = (
    (FieldName: 'ResolutionScope'; FieldType: ftResolutionScope),
    (FieldName: 'TypeName';        FieldType: ftString),
    (FieldName: 'TypeNamespace';   FieldType: ftString)
  );

  FIELDS_TypeSpec: array[0..0] of TFieldDef = (
    (FieldName: 'Signature'; FieldType: ftBlob)
  );

  TABLE_FIELDS: array[$00..$2C] of TTableDef = (
  {00}(FieldCount: Length(FIELDS_Module); FieldDefs: @FIELDS_Module),
  {01}(FieldCount: Length(FIELDS_TypeRef); FieldDefs: @FIELDS_TypeRef),
  {02}(FieldCount: Length(FIELDS_TypeDef); FieldDefs: @FIELDS_TypeDef),
  {03}(FieldCount: 0; FieldDefs: nil),
  {04}(FieldCount: Length(FIELDS_Field); FieldDefs: @FIELDS_Field),
  {05}(FieldCount: 0; FieldDefs: nil),
  {06}(FieldCount: Length(FIELDS_MethodDef); FieldDefs: @FIELDS_MethodDef),
  {07}(FieldCount: 0; FieldDefs: nil),
  {08}(FieldCount: Length(FIELDS_Param); FieldDefs: @FIELDS_Param),
  {09}(FieldCount: Length(FIELDS_InterfaceImpl); FieldDefs: @FIELDS_InterfaceImpl),
  {0A}(FieldCount: Length(FIELDS_MemberRef); FieldDefs: @FIELDS_MemberRef),
  {0B}(FieldCount: Length(FIELDS_Constant); FieldDefs: @FIELDS_Constant),
  {0C}(FieldCount: Length(FIELDS_CustomAttribute); FieldDefs: @FIELDS_CustomAttribute),
  {0D}(FieldCount: Length(FIELDS_FieldMarshal); FieldDefs: @FIELDS_FieldMarshal),
  {0E}(FieldCount: Length(FIELDS_DeclSecurity); FieldDefs: @FIELDS_DeclSecurity),
  {0F}(FieldCount: Length(FIELDS_ClassLayout); FieldDefs: @FIELDS_ClassLayout),
  {10}(FieldCount: Length(FIELDS_FieldLayout); FieldDefs: @FIELDS_FieldLayout),
  {11}(FieldCount: Length(FIELDS_StandAloneSig); FieldDefs: @FIELDS_StandAloneSig),
  {12}(FieldCount: Length(FIELDS_EventMap); FieldDefs: @FIELDS_EventMap),
  {13}(FieldCount: 0; FieldDefs: nil),
  {14}(FieldCount: Length(FIELDS_Event); FieldDefs: @FIELDS_Event),
  {15}(FieldCount: Length(FIELDS_PropertyMap); FieldDefs: @FIELDS_PropertyMap),
  {16}(FieldCount: 0; FieldDefs: nil),
  {17}(FieldCount: Length(FIELDS_Property); FieldDefs: @FIELDS_Property),
  {18}(FieldCount: Length(FIELDS_MethodSemantics); FieldDefs: @FIELDS_MethodSemantics),
  {19}(FieldCount: Length(FIELDS_MethodImpl); FieldDefs: @FIELDS_MethodImpl),
  {1A}(FieldCount: Length(FIELDS_ModuleRef); FieldDefs: @FIELDS_ModuleRef),
  {1B}(FieldCount: Length(FIELDS_TypeSpec); FieldDefs: @FIELDS_TypeSpec),
  {1C}(FieldCount: Length(FIELDS_ImplMap); FieldDefs: @FIELDS_ImplMap),
  {1D}(FieldCount: Length(FIELDS_FieldRVA); FieldDefs: @FIELDS_FieldRVA),
  {1E}(FieldCount: 0; FieldDefs: nil),
  {1F}(FieldCount: 0; FieldDefs: nil),
  {20}(FieldCount: Length(FIELDS_Assembly); FieldDefs: @FIELDS_Assembly),
  {21}(FieldCount: Length(FIELDS_AssemblyProcessor); FieldDefs: @FIELDS_AssemblyProcessor),
  {22}(FieldCount: Length(FIELDS_AssemblyOS); FieldDefs: @FIELDS_AssemblyOS),
  {23}(FieldCount: Length(FIELDS_AssemblyRef); FieldDefs: @FIELDS_AssemblyRef),
  {24}(FieldCount: Length(FIELDS_AssemblyRefProcessor); FieldDefs: @FIELDS_AssemblyRefProcessor),
  {25}(FieldCount: Length(FIELDS_AssemblyRefOS); FieldDefs: @FIELDS_AssemblyRefOS),
  {26}(FieldCount: Length(FIELDS_File); FieldDefs: @FIELDS_File),
  {27}(FieldCount: Length(FIELDS_ExportedType); FieldDefs: @FIELDS_ExportedType),
  {28}(FieldCount: Length(FIELDS_ManifestResource); FieldDefs: @FIELDS_ManifestResource),
  {29}(FieldCount: Length(FIELDS_NestedClass); FieldDefs: @FIELDS_NestedClass),
  {2A}(FieldCount: Length(FIELDS_GenericParam); FieldDefs: @FIELDS_GenericParam),
  {2B}(FieldCount: Length(FIELDS_MethodSpec); FieldDefs: @FIELDS_MethodSpec),
  {2C}(FieldCount: Length(FIELDS_GenericParamConstraint); FieldDefs: @FIELDS_GenericParamConstraint)
  );

  TableRef: array[ftAssemblyRef..ftTypeDef] of Byte = (
    TABLE_AssemblyRef,
    TABLE_Event,
    TABLE_Field,
    TABLE_GenericParam,
    TABLE_MethodDef,
    TABLE_ModuleRef,
    TABLE_Param,
    TABLE_Property,
    TABLE_TypeDef
  );

  CompositeIndex: array[ftCustomAttributeType..ftTypeOrMethodDef] of TArray<Byte> = (
  // ftCustomAttributeType
    [TABLE_NULL, TABLE_NULL, TABLE_MethodDef, TABLE_MemberRef, TABLE_NULL],
  // ftHasConstant
    [TABLE_Field, TABLE_Param, TABLE_Property],
  // ftHasCustomAttribute
    [
      TABLE_MethodDef, TABLE_Field, TABLE_TypeRef, TABLE_TypeDef, TABLE_Param, TABLE_InterfaceImpl,
      TABLE_MemberRef, TABLE_Module, TABLE_Property, TABLE_Event, TABLE_StandAloneSig, TABLE_ModuleRef,
      TABLE_TypeSpec, TABLE_Assembly, TABLE_AssemblyRef, TABLE_File, TABLE_ExportedType, TABLE_ManifestResource,
      TABLE_GenericParam, TABLE_GenericParamConstraint, TABLE_MethodSpec
    ],
  // ftHasDeclSecurity
    [TABLE_TypeDef, TABLE_MethodDef, TABLE_Assembly],
  // ftHasFieldMarshal
    [TABLE_Field, TABLE_Param],
  // ftHasSemantics
    [TABLE_Event, TABLE_Property],
  // ftImplementation
    [TABLE_File, TABLE_AssemblyRef, TABLE_ExportedType],
  // ftMemberForwarded
    [TABLE_Field, TABLE_MethodDef],
  // ftMemberRefParent
    [TABLE_TypeDef, TABLE_TypeRef, TABLE_ModuleRef, TABLE_MethodDef, TABLE_TypeSpec],
  // ftMethodDefOrRef
    [TABLE_MethodDef, TABLE_MemberRef],
  // ftResolutionScope
    [TABLE_Module, TABLE_ModuleRef, TABLE_AssemblyRef, TABLE_TypeRef],
  // ftTypeDefOrRef
    [TABLE_TypeDef, TABLE_TypeRef, TABLE_TypeSpec],
  // ftTypeOrMethodDef
    [TABLE_TypeDef, TABLE_MethodDef]
  );

  TableLabel: array[$00..$2C] of Byte = (
   1,1,1,0,1,0,3,0,2,1,1,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,0,3,0,0,0,7,0,0,6,0,0,1,2,2,0,3,0,0
  );

implementation

end.
