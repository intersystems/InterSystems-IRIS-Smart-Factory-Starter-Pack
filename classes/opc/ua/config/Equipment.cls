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
ClassMethod SearchByName(pName As %String, Output Status As %Status) As opc.ua.config.Equipment
{
	set tEquipment = ""
	&sql(SELECT ID INTO :id FROM opc_ua_config.Equipment WHERE name=:pName)
	if (SQLCODE = 0) {
		set tEquipment =  ##class(opc.ua.config.Equipment).%OpenId(id, , .Status)
		if $$$ISERR(Status) return ""		
	}
	
	return tEquipment
}

/// Get the current configuration by name of the equipment
Method SearchCurrentConfigurationByName(pConfigurationName As %String, Output Status As %Status) As opc.ua.config.Configuration
{
	set tConfiguration = ""
	set tId = ..%Id()
	&sql(SELECT Configuration->ID INTO :id
	       FROM opc_ua_config.EquipmentConfiguration 
	      WHERE Equipment->ID = :tId 
	        AND Configuration->Name = :pConfigurationName 
	        AND Configuration->IsCurrentVersion = 1)
	if (SQLCODE = 0) {
		set tConfiguration =  ##class(opc.ua.config.Configuration).%OpenId(id, , .Status)
		if $$$ISERR(Status) return ""		
	}	
	
	return tConfiguration
}

/// Get the nodes for the specified configuration
Method GetNodesForConfiguration(pConfigurationName As %String, pConfigType As %String) As %ListOfObjects
{
	set tNodeList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT Node INTO :nodeId FROM opc_ua_config.ConfigurationNode 
	       WHERE Configuration->Name = :pConfigurationName
	       AND Configuration->ConfigType = :pConfigType)
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tNodeList
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
	do ..GetClassName(pConfigurationName, .Exists)
	return Exists
}

Method GetClassName(pConfigurationName As %String, Output Exists As %Boolean) As %String
{
	set EquipCfg = ##class(opc.ua.config.EquipmentConfiguration).Get(..Name, pConfigurationName)
	if EquipCfg = "" set Exists = 0 Quit ""
	
	set ClassName = ##class(opc.ua.data.Generator).GetClassName(EquipCfg, .Exists)
	
	return ClassName
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
