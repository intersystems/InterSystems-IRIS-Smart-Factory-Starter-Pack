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
	set Me.Config = EquipmentConfiguration
	; Actual implementation in method
	return Me.GenerateImpl()
}

/// Returns the name of the class for this equipment configuration,
/// and whether it already exists
ClassMethod GetClassName(EquipmentConfiguration As opc.ua.config.EquipmentConfiguration, Output Exists As %Boolean) As %String
{
	set Config = EquipmentConfiguration
	set ClassName = Config.Equipment.ClassPackage
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
	
	; Generate description for class
	Set Desc = "Generated for:"_$$$EOL
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
	
	
	; Generate the Ensemble components if not already present
	set sc = ..GenerateEnsemble()
	if 'sc quit sc
	
	
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
	
	set SqlName = ..GetClassSqlName(..ClassDef.Name)
	
	$$$Write("&sql(INSERT INTO "_SqlName)
	$$$Write("  ("_Names_")")
	$$$Write("  VALUES")
	$$$Write("  ("_Values_"))")
	$$$Write("Set RowId = %ROWID") 
	$$$Write("If SQLCODE Quit $$$ERROR($$$SQLError,SQLCODE,$g(%msg))")
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

/// Generate default Ensemble components for new machine configuration
Method GenerateEnsemble() As %Status
{
	set Type = ..Config.Configuration.ConfigType
	if Type '= "transforming" return $$$OK
	
	; Names of data classes
	set TransformingDataClassName = ..GetClassName(..Config)
	set StagingDataClassName = $Replace(TransformingDataClassName, ".transforming.", ".staging.")
	
	
	; == Generate empty business process
	
	set BPName = "opc.ua.bp."_..Config.Equipment.Name_"Transform"
	if '##class(%Dictionary.ClassDefinition).%ExistsId(BPName) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(BPName, 25)
		set ClassDef.Super = "Ens.BusinessProcessBPL"
		
		; Insert default BPL XData block
		set BPL = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||BPLTransform")
		set BPL = BPL.%ConstructClone()
		set BPL.Name = "BPL"
		do ClassDef.XDatas.Insert(BPL)
		
		; Replace dataclass name template
		set Data = BPL.Data.Read()
		set Data = $Replace(Data, "{TransformingRecord}", TransformingDataClassName)
		set Data = $Replace(Data, "{StagingRecord}", StagingDataClassName)
		set Data = $Replace(Data, "{TransformingDTL}", $Replace(BPName, ".bp.", ".dtl."))
		do BPL.Data.Clear(), BPL.Data.Write(Data)
		
		; The BP doesn't need compilation, because it doesn't do anything yet
		set sc = ClassDef.%Save()
		if 'sc Quit sc
	}
	
	; == Generate empty business rule
	
	set RuleName = "opc.ua.rule."_..Config.Equipment.Name_"Rule"
	if '##class(%Dictionary.ClassDefinition).%ExistsId(RuleName) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(RuleName, 25)
		set ClassDef.Super = "Ens.BusinessProcessBPL"
		
		; Insert default rule definition XData block
		set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||EmptyRuleDefinition")
		set RuleDef = RuleDef.%ConstructClone()
		set RuleDef.Name = "RuleDefinition"
		do ClassDef.XDatas.Insert(RuleDef)
		
		; Add context class to rule
		set Data = RuleDef.Data.Read()
		set Data = $Replace(Data, "context=""""", "context="""_BPName_".Context""")
		do RuleDef.Data.Clear(), RuleDef.Data.Write(Data)
		
		; The rule doesn't need compilation, because it doesn't do anything yet
		set sc = ClassDef.%Save()
		if 'sc Quit sc
	}
	
	; == Generate empty DTL
	
	set DTLName = "opc.ua.dtl."_..Config.Equipment.Name_"Transformxxx"
	if '##class(%Dictionary.ClassDefinition).%ExistsId(DTLName) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(DTLName, 25)
		set ClassDef.Super = "Ens.DataTransformDTL"
		set ClassDef.DependsOn = TransformingDataClassName_","_StagingDataClassName
		
		; Insert default rule definition XData block
		set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||EmptyDTL")
		set RuleDef = RuleDef.%ConstructClone()
		set RuleDef.Name = "DTL"
		do ClassDef.XDatas.Insert(RuleDef)
		
		; Add context class to rule
		set Data = RuleDef.Data.Read()
		set Data = $Replace(Data, "{TransformingRecord}", TransformingDataClassName)
		set Data = $Replace(Data, "{StagingRecord}", StagingDataClassName)
		do RuleDef.Data.Clear(), RuleDef.Data.Write(Data)
		
		; The DTL doesn't need compilation, because it doesn't do anything yet
		set sc = ClassDef.%Save()
		if 'sc Quit sc
	}
	
	
	Quit $$$OK
}

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
$Case(DataType,"timestamp":"%TimeStamp","time":"%Time","boolean":"%Boolean","integer":"%Integer","double":"%Double","float":"%Double","string":"%String","decimal":"%Decimal",:"%RawString")
}

// =====

/// Template data for the automatic generation of the business process
XData BPLTransform [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.rest.impl.Request' response='Ens.Response' >
<context>
<property name='Readings' type='{StagingRecord}' instantiate='0' />
<property name='TransformingRecord' type='{TransformingRecord}' instantiate='1' />
</context>
<sequence  >
<scope >
<assign name="Readings to context" property="context.Readings" value="request.Readings" action="set"  />
<transform name='Transform' class='{TransformingDTL}' source='context.Readings' target='context.TransformingRecord' />
<faulthandlers>
<catchall >
<alert value='"Error ["_$System.Status.GetErrorText(context.%LastError)_"] / ["_$ZERROR_"]"' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

/// Template data for the automatic generation of business rules
XData EmptyRuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
</ruleSet>
</ruleDefinition>
}

/// Template data for the automatic generation of DTL
XData EmptyDTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='{StagingRecord}' targetClass='{TransformingRecord}' create='existing' language='objectscript' >
</transform>
}

}
