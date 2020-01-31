include Ensemble

/// Equipment definition
Class opc.ua.config.Equipment Extends (%Persistent, %JSON.Adaptor)
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
Method IsClassDefinitionAvailable(pConfigurationName As %String) As %Boolean {	
	return ##class(%Dictionary.ClassDefinition).%ExistsId(..ClassPackage_".staging."_..Name_pConfigurationName)
}

/// Generate equipment class definition
Method GenerateClassDefinition(pConfigurationName As %String) As %Status {
				
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
			set tClassDef.Super = "%Persistent,%JSON.Adaptor"
			set tClassDef.Inheritance = "left" // Or else "right" is chosen by the compiler (?).
		}			
					
		/// Step 3: Process all configurated nodes for this machine configuration
		while tNodes.GetNext(.key) {	
							
			#dim tNode As opc.ua.config.Node	
			set tNode = tNodes.GetAt(key)
			
			/// Only input Nodes will be generated for a machine 
			if ((tNode.DatabaseAttribute '= "") && (tNode.DatabaseType '= "")) {
							
				/// When node not already exists add it to the class. Otherwise skip it
				if ('##class(%Dictionary.PropertyDefinition).%ExistsId(tNode.DatabaseAttribute)) {
				
					set tClassProp = ##class(%Dictionary.PropertyDefinition).%New()
					set tClassProp.Name = tNode.DatabaseAttribute
					set tClassProp.Type = $CASE(tNode.DatabaseType,"boolean":"%Boolean","integer":"%Integer","double":"%Double","float":"%Double","string":"%String","decimal":"%Decimal",:"%RawString")
				
					do tClassDef.Properties.Insert(tClassProp)
				}	
			}				
		} 		
		
		set sc = tClassDef.%Save()
		quit:$$$ISERR(sc) sc
		quit $SYSTEM.OBJ.Compile(tClassPackage,"cuk")	
	}
	
	return $$$OK
}

/// Save the machine configuration 
Method %OnAddToSaveSet(pDepth As %Integer,
                       pInsert As %Integer,
                       pCallcount As %Integer) As %Status [ Private, ServerOnly = 1 ] 
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
