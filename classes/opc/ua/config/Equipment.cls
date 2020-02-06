Include Ensemble

/// Equipment definition
Class opc.ua.config.Equipment Extends (%Persistent, %JSON.Adaptor) [ DependsOn = opc.ua.config.Configuration ]
{

/// Name of the machine
Property Name As %String [ Required ];

/// Description of the machine
Property Description As %String(MAXLEN = 1000);

/// Category of the equipment
Property EquipmentType As opc.ua.config.EquipmentType;

/// Class package where the machine table will be generated
Property ClassPackage As %String [ InitialExpression = "opc.ua.data" ];

/// Location of the machine
Property Location As %String(MAXLEN = 100);

/// Bridge property for many-to-many relationship
Relationship EquipmentConfiguration As opc.ua.config.EquipmentConfiguration [ Cardinality = many, Inverse = Equipment ];

Index EquipmentNameIndex On Name [ Unique ];

/// Get the equipment by specifying the name
ClassMethod SearchByName(pName As %String) As opc.ua.config.Equipment
{

	set tEquipment = ""
	&sql(SELECT ID INTO :id FROM opc_ua_config.Equipment WHERE name=:pName)
	if (SQLCODE = 0) {
		set tEquipment =  ##class(opc.ua.config.Equipment).%OpenId(id,,.sc)
		return:$$$ISERR(sc) sc		
	}
	
	return tEquipment
}

/// Get the current configuration by name of the equipment
Method SearchCurrentConfigurationByName(pConfigurationName As %String) As opc.ua.config.Configuration
{
	set tConfiguration = ""
	set tId = ..%Id()
	&sql(SELECT Configuration->ID INTO :id FROM opc_ua_config.EquipmentConfiguration 
	     WHERE Equipment->ID = :tId 
	     AND Configuration->Name = :pConfigurationName 
	     AND Configuration->IsCurrentVersion = 1)
	if (SQLCODE = 0) {
		set tConfiguration =  ##class(opc.ua.config.Configuration).%OpenId(id,,.sc)
		return:$$$ISERR(sc) sc		
	}	
	
	return tConfiguration
}

/// Get the nodes for the specified configuration
Method GetNodesForConfiguration(pConfigurationName As %String) As %ListOfObjects
{
	set tNodeList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
       SELECT Node INTO :nodeId FROM opc_ua_config.ConfigurationNode 
	     WHERE Configuration->Name = :pConfigurationName)
    &sql(OPEN C1)
    quit:(SQLCODE '= 0)
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tNode = ##class(opc.ua.config.Node).%OpenId(nodeId,,.sc)
    	if ('$$$ISERR(sc)) {
    		Do tNodeList.Insert(tNode)    		
    	}	
    	&sql(FETCH C1)
    }
    &sql(CLOSE C1)
		
	return tNodeList
}

/// Check if the equipment class definition is available
Method IsClassDefinitionAvailable(pConfigurationName As %String) As %Boolean
{
	
	return ##class(%Dictionary.ClassDefinition).%ExistsId(..ClassPackage_".staging."_..Name_pConfigurationName)
}

/// Get the class definition
Method GetClassDefinition(pConfigurationName As %String) As %String
{
	
	return ..ClassPackage_".staging."_..Name_pConfigurationName
}

/// Get SQL projection definition
Method GetSQLProjectionDefinition(pConfigurationName As %String) As %String
{
	
	return $REPLACE(..ClassPackage,".","_")_"_staging."_..Name_pConfigurationName
}

/// Generate equipment class definition
Method GenerateClassDefinition(pConfigurationName As %String) As %Status
{
	/// Step 1: Retrieve the Nodes belonging to the current configuration of this machine	
	#dim tNodes As %ListOfObjects
	set tNodes = ..GetNodesForConfiguration(pConfigurationName)
	if ((tNodes '= "") && (tNodes.Count() > 0)) {
		
		/// Step 2: Create or get the needed class definition
		#dim tClassDef As %Dictionary.ClassDefinition
		#dim tClassProp As %Dictionary.PropertyDefinition
					
		set tClassPackage = ..ClassPackage_".staging."_..Name_pConfigurationName
					
		/// Check if class definition is available 
		/// When class defintion is available retrieve it else create a new class
		if (..IsClassDefinitionAvailable(pConfigurationName)) {	 	
		 	set tClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(tClassPackage)
		} else {
			set tClassDef = ##class(%Dictionary.ClassDefinition).%New()
			set tClassDef.Name = tClassPackage
			set tClassDef.Super = "opc.ua.data.Base"
			set tClassDef.Inheritance = "left" // Or else "right" is chosen by the compiler (?).
		}
		
		/// Step 3: Process all configurated nodes for this machine configuration
		while tNodes.GetNext(.key) {	
							
			#dim tNode As opc.ua.config.Node	
			set tNode = tNodes.GetAt(key)
			
			/// Only input Nodes will be generated for a machine 
			if ((tNode.DatabaseAttribute '= "") && (tNode.DatabaseType '= "")) {
							
				/// When node not already exists add it to the class. Otherwise skip it
				if ('##class(%Dictionary.PropertyDefinition).%ExistsId(tClassPackage_"||"_tNode.DatabaseAttribute)) {
				
					set tClassProp = ##class(%Dictionary.PropertyDefinition).%New()
					set tClassProp.Name = tNode.DatabaseAttribute
					set tClassProp.Type = ..GetIRISType(tNode.DatabaseType)
				
					do tClassDef.Properties.Insert(tClassProp)
				}
			}
		}
		
		set sc = ..GenerateInitDataMethod(tClassDef, tNodes)
		quit:$$$ISERR(sc) sc
		
		set sc = ..GenerateGetLastRecordMethod(tClassDef, tNodes)
		quit:$$$ISERR(sc) sc
		
		set sc = ..GenerateSaveDataMethod(tClassDef, tNodes)
		quit:$$$ISERR(sc) sc
		
		set sc = tClassDef.%Save()
		quit:$$$ISERR(sc) sc
		
		quit $SYSTEM.OBJ.Compile(tClassPackage,"cuk")	
	}
	
	return $$$OK
}

Method GenerateSaveDataMethod(ClassDef As %Dictionary.ClassDefinition, Nodes As %ListOfObjects) As %Status
{
	#define Write(%args) Do md.Implementation.WriteLine($Char(9)_%args)
	
	set md = ..GetElement(ClassDef.Methods, "SaveData")
	set md.ClassMethod = 1
	set md.ReturnType = "%Status"
	set md.FormalSpec = "TimeStamp:%TimeStamp,&Data:%String"
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
	
	set SqlName = ..GetClassSqlName(ClassDef.Name)
	
	$$$Write("&sql(INSERT INTO "_SqlName)
	$$$Write("  ("_Names_")")
	$$$Write("  VALUES")
	$$$Write("  ("_Values_"))")
	$$$Write("If SQLCODE Quit $$$ERROR($$$SQLError,SQLCODE,$g(%msg))")
	$$$Write("Quit $$$OK")
	
	set sc = md.%Save()
	if 'sc quit sc
	
	quit $$$OK
}

Method GenerateGetLastRecordMethod(ClassDef As %Dictionary.ClassDefinition, Nodes As %ListOfObjects) As %Status
{
	#define Write(%args) Do md.Implementation.WriteLine($Char(9)_%args)
	
	set md = ..GetElement(ClassDef.Methods, "GetLastRecord")
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
	
	set SqlName = ..GetClassSqlName(ClassDef.Name)
	
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
	if 'sc quit sc
	
	quit $$$OK
}

Method GenerateInitDataMethod(ClassDef As %Dictionary.ClassDefinition, Nodes As %ListOfObjects) As %Status
{
	#define Write(%args) Do md.Implementation.WriteLine($Char(9)_%args)
	
	set md = ..GetElement(ClassDef.Methods, "InitData")
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
	if 'sc quit sc
	
	quit $$$OK
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
$Case(DataType,"boolean":"%Boolean","integer":"%Integer","double":"%Double","float":"%Double","string":"%String","decimal":"%Decimal",:"%RawString")
}

/// Returns the SQL name for a class. Does not yes account for
/// explicitly specified SQL names.
ClassMethod GetClassSqlName(ClassName As %String) As %String
{
	Set Pkg = $Piece(ClassName, ".", 1, *-1)
	Set SqlPkg = $Translate(Pkg, ".", "_")
	Set ShortName = $Piece(ClassName, ".", *)
	Quit SqlPkg_"."_ShortName
}

/// Save the machine configuration 
Method %OnAddToSaveSet(pDepth As %Integer, pInsert As %Integer, pCallcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	/// todo: add save logic
	return $$$OK
}

Storage Default
{
<Data name="EquipmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>EquipmentType</Value>
</Value>
<Value name="5">
<Value>ClassPackage</Value>
</Value>
<Value name="6">
<Value>Location</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.EquipmentD</DataLocation>
<DefaultData>EquipmentDefaultData</DefaultData>
<IdLocation>^opc.ua.config.EquipmentD</IdLocation>
<IndexLocation>^opc.ua.config.EquipmentI</IndexLocation>
<StreamLocation>^opc.ua.config.EquipmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
