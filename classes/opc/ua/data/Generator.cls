Class opc.ua.data.Generator Extends %RegisteredObject
{

/// The equipment and configuration we're generating the class for
Property Config As opc.ua.config.EquipmentConfiguration;

/// The class to generate/update
Property ClassDef As %Dictionary.ClassDefinition;

/// Generates the class for the given equipment/configuration
ClassMethod Generate(EquipmentConfiguration As opc.ua.config.EquipmentConfiguration) As %Status
{
	set Me = ..%New()
	if $IsObject(EquipmentConfiguration) {
		set Me.Config = EquipmentConfiguration
	} Else {
		; Support passing by id
		do Me.ConfigSetObjectId(EquipmentConfiguration)
	}
	; Actual implementation in method
	return Me.GenerateImpl()
}

/// Returns the name of the class for this equipment configuration,
/// and whether it already exists
ClassMethod GetClassName(EquipmentConfiguration As opc.ua.config.EquipmentConfiguration, Output Exists As %Boolean) As %String
{
	set Config = EquipmentConfiguration
	set ClassName = Config.Equipment.ClassPackage_".data"
	  _"."_Config.Equipment.Name
	  _"."_Config.Configuration.ConfigType
	  _"."_Config.Configuration.Name
	
	set Exists = ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName)
	
	return ClassName
}

/// Implementation of class generation
Method GenerateImpl() As %Status
{
	; Load/create the class definition
	set ClassName = ..GetClassName(..Config, .Exists)
	if Exists {
		set ..ClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName, , .sc)
		if 'sc return sc
	} else {
		; Class version 25 gets us ProcedureBlock
		set ..ClassDef = ##class(%Dictionary.ClassDefinition).%New(ClassName, 25)
		set ..ClassDef.Super = "opc.ua.data.Base"		
	}
	
	; Add OEE fields?
	If ..Config.Configuration.StandardOEEFields {
		; Add, if not present, the properties for OEE via superclass
		Set Super = $ListFromString(..ClassDef.Super)
		If '$ListFind(Super, "opc.ua.data.OEE") Set ..ClassDef.Super = ..ClassDef.Super_",opc.ua.data.OEE"
	}
	
	; Generate description for class
	Set Desc = "Generated at "_$ZDateTime($ZTimestamp, 3, 1)_" (UTC) for:"_$$$EOL
	Set Desc = Desc_"- Equipment "_..Config.Equipment.Description_" (id "_..Config.Equipment.%Id()_")"_$$$EOL
	Set Desc = Desc_"- Configuration "_..Config.Configuration.Description_" (id "_..Config.Configuration.%Id()_")"
	Set ..ClassDef.Description = Desc
	
  ; Generate XMLTYPE from equipment, stage (configtype), and configuration
  ; This will make the type always unique.
  set XmlType = ..Config.Equipment.Name
    _"."_..Config.Configuration.ConfigType
    _"."_..Config.Configuration.Name
  #dim ParmDef As %Dictionary.ParameterDefinition
  set ParmDef = ..GetElement(..ClassDef.Parameters, "XMLTYPE")
  set ParmDef.Default = XmlType
  
  ; Generate XMLNAME to configure the top-level node. Using only XMLTYPE
  ; does not work on import.
  set ParmDef = ..GetElement(..ClassDef.Parameters, "XMLNAME")
  set ParmDef.Default = XmlType
	
	; Generate PreviousReading property
	#dim PropDef As %Dictionary.PropertyDefinition
	set PropDef = ..GetElement(..ClassDef.Properties, "PreviousReading")
	set PropDef.Type = ClassName
	set PropDef.Transient = 1
	; Turn off XML and JSON projections to prevent recursion
	do PropDef.Parameters.SetAt("NONE", "XMLPROJECTION")
	do PropDef.Parameters.SetAt("NONE", "%JSONINCLUDE")
	
	; Get list of opc.ua.config.Node objects
	set Nodes = ..Config.Configuration.ConfigurationNode
	set NodeList = ##class(%ListOfDataTypes).%New()
	set key = ""
	for  {
		set NodeCfg = Nodes.GetNext(.key)
		if key = "" quit
		do NodeList.Insert(NodeCfg.Node)
	}
	
	; Create properties for each node
	for i = 1:1:NodeList.Count() {
		#dim Node As opc.ua.config.Node	
		set Node = NodeList.GetAt(i)
		if (Node.DatabaseAttribute = "") || (Node.DatabaseType = "") Continue
		
		set PropDef = ..GetElement(..ClassDef.Properties, Node.DatabaseAttribute)
		set PropDef.Type = ..GetIRISType(Node.DatabaseType)
		
		if (PropDef.Type = "%String") && (Node.DatabaseLength '= "") {
			do PropDef.Parameters.SetAt(Node.DatabaseLength, "MAXLEN")
		}	
	}
	
	; Additional methods
	if ..Config.Configuration.ConfigType = "staging" {
		; Methods only needed on staging data class
		
		set sc = ..GenerateInitDataMethod(NodeList)
		quit:$$$ISERR(sc) sc
		
		set sc = ..GenerateGetLastRecordMethod(NodeList)
		quit:$$$ISERR(sc) sc
		
		set sc = ..GenerateSaveDataMethod(NodeList)
		quit:$$$ISERR(sc) sc
	}
	
	; Save and compile
	set sc = ..ClassDef.%Save()
	quit:$$$ISERR(sc) sc
	set sc = $System.OBJ.Compile(ClassName,"cuk-d")	
	quit:$$$ISERR(sc) sc
	
	
	return $$$OK
}

Method GenerateSaveDataMethod(Nodes As %ListOfObjects) As %Status
{
	#define Write(%args) Do md.Implementation.WriteLine($Char(9)_%args)
	
	set md = ..GetElement(..ClassDef.Methods, "SaveData")
	set md.ClassMethod = 1
	set md.ReturnType = "%Status"
	set md.FormalSpec = "TimeStamp:%TimeStamp,&Data:%String,*RowId:%BigInt"
	set md.Description = "Generated code, do not change."
	
	set Names = "TimeStamp"
	set Values = ":TimeStamp"
	set Idx = 0
	for i = 1:1:Nodes.Count() {
		#dim Node As opc.ua.config.Node
		set Node = Nodes.GetAt(i)
		if (Node.DatabaseAttribute = "") || (Node.DatabaseType = "") Continue
		
		; Embedded SQL does not support string array, create numeric array instead
		set Idx = Idx + 1
		$$$Write("Set d("_Idx_")=Data("""_Node.NodeId_""")")
		
		set Names = Names_","_Node.DatabaseAttribute
		set Values = Values_","_":d("_Idx_")"
	}
	
	; Timestamp to various local time fields
	$$$Write("set Horolog = $ZDateTimeH(TimeStamp, 3)")
	$$$Write("set HorologLocal = $ZDateTimeH(Horolog, -3)")
	$$$Write("set TimeStampLocal = $ZDateTime(HorologLocal, 3, 1, 2)")
	$$$Write("set YearLocal = $Piece(TimeStampLocal, ""-"", 1)")
	$$$Write("set MonthLocal = +$Piece(TimeStampLocal, ""-"", 2)")
	$$$Write("set DayLocal = +$ZDate(HorologLocal, 4)")
	$$$Write("set WeekDayLocal = $ZDate(+HorologLocal, 10)")
	$$$Write("set TimeLocal = $Piece(HorologLocal, "","", 2)")
	
	Set Names = Names_",TimeStampLocal,YearLocal,MonthLocal,DayLocal,WeekDayLocal,TimeLocal"
	Set Values = Values_",:TimeStampLocal,:YearLocal,:MonthLocal,:DayLocal,:WeekDayLocal,:TimeLocal"
	
	set SqlName = ..GetClassSqlName(..ClassDef.Name)
	
	$$$Write("&sql(INSERT INTO "_SqlName)
	$$$Write("  ("_Names_")")
	$$$Write("  VALUES")
	$$$Write("  ("_Values_"))")
	$$$Write("If SQLCODE Quit $$$ERROR($$$SQLError,SQLCODE,$g(%msg))")
	$$$Write("Set RowId = %ROWID") 
	$$$Write("Quit $$$OK")
	
	set sc = md.%Save()
	if 'sc return sc
	
	return $$$OK
}

Method GenerateGetLastRecordMethod(Nodes As %ListOfObjects) As %Status
{
	#define Write(%args) Do md.Implementation.WriteLine($Char(9)_%args)
	
	set md = ..GetElement(..ClassDef.Methods, "GetLastRecord")
	set md.ClassMethod = 1
	set md.ReturnType = "%Status"
	set md.FormalSpec = "*Data:%String"
	set md.Description = "Generated code, do not change."
	
	set (Select, Into, Idx) = ""
	for i = 1:1:Nodes.Count() {
		#dim Node As opc.ua.config.Node
		set Node = Nodes.GetAt(i)
		if (Node.DatabaseAttribute = "") || (Node.DatabaseType = "") continue
		
		set Idx = Idx + 1
		if Select '= "" set Select = Select_",", Into = Into_","
		set Select = Select_Node.DatabaseAttribute
		set Into = Into_":d("_Idx_")"
	}
	
	set SqlName = ..GetClassSqlName(..ClassDef.Name)
	
	$$$Write("&sql(SELECT "_Select)
	$$$Write("  INTO "_Into)
	$$$Write("  FROM "_SqlName)
	$$$Write("  ORDER BY ID DESC)")
	$$$Write("If SQLCODE {")
	$$$Write("  If SQLCODE '= 100 Quit $$$ERROR($$$SQLError,SQLCODE,$g(%msg))")
	$$$Write("  Do ..InitData(.Data)")
	$$$Write("  Quit $$$OK")
	$$$Write("}")
	
	set Idx = 0
	for i = 1:1:Nodes.Count() {
		set Node = Nodes.GetAt(i)
		if (Node.DatabaseAttribute = "") || (Node.DatabaseType = "") continue
		
		set Idx = Idx + 1
		$$$Write("Set Data("""_Node.NodeId_""")=d("_Idx_")")
	}
	
	$$$Write("Quit $$$OK")
	
	set sc = md.%Save()
	if 'sc return sc
	
	return $$$OK
}

Method GenerateInitDataMethod(Nodes As %ListOfObjects) As %Status
{
	#define Write(%args) Do md.Implementation.WriteLine($Char(9)_%args)
	
	set md = ..GetElement(..ClassDef.Methods, "InitData")
	set md.ClassMethod = 1
	set md.FormalSpec = "*Data:%String"
	set md.Description = "Generated code, do not change."
	
	set Names = ""
	for i = 1:1:Nodes.Count() {
		#dim Node As opc.ua.config.Node
		set Node = Nodes.GetAt(i)
		if (Node.DatabaseAttribute = "") || (Node.DatabaseType = "") Continue
		if Names '= "" set Names = Names_","
		set Names = Names_""""_$Replace(Node.NodeId, """", """""")_""""
	}
	
	$$$Write("Set Names = $lb("_Names_")")
	$$$Write("For i = 1:1:$ll(Names) Set Data($li(Names,i))=""""")
	$$$Write("Quit")
	
	set sc = md.%Save()
	if 'sc return sc
	
	return $$$OK
}

// =====

/// Returns the SQL name for a class. Does not yes account for
/// explicitly specified SQL names.
ClassMethod GetClassSqlName(ClassName As %String) As %String
{
	set Pkg = $Piece(ClassName, ".", 1, *-1)
	set SqlPkg = $Translate(Pkg, ".", "_")
	set ShortName = $Piece(ClassName, ".", *)
	return SqlPkg_"."_ShortName
}

/// Retrieves an element (e.g., method definition) from a collection in a
/// class definition. Creates and inserts it if it doesn't already exist.
ClassMethod GetElement(Collection As %Collection.ListOfObj, Name As %String) As %RegisteredObject
{
	; Check if the element already exists
	set key = ""
	for  {
		set def = Collection.GetNext(.key)
		if key = "" quit
		if def.Name = Name return def
	}
	
	; Not found; create and insert
	set def = $ClassMethod(Collection.ElementType, "%New")
	set def.Name = Name
	do Collection.Insert(def)
	
	return def
}

/// Returns the IRIS type for the input (node) datatype
ClassMethod GetIRISType(DataType As %String) As %String [ CodeMode = expression ]
{
$Case(DataType,"date":"%Date","timestamp":"%TimeStamp","time":"%Time","boolean":"%Boolean","integer":"%Integer","double":"%Double","float":"%Double","string":"%String","decimal":"%Decimal",:"%RawString")
}

}
