Include Ensemble

/// Equipment definition
Class opc.ua.config.Equipment Extends (%Persistent, %JSON.Adaptor)
{

/// Name of the machine
Property Name As %String(%JSONFIELDNAME = "name") [ Required ];

/// Description of the machine
Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 1000);

/// Category of the equipment
Property EquipmentType As opc.ua.config.EquipmentType(%JSONFIELDNAME = "equipment_type");

/// Class package where the equipment data, dtl, bp and routers will be generated. All client specific classes.
Property ClassPackage As %String(%JSONFIELDNAME = "class_package") [ InitialExpression = "opc.clientdata" ];

/// Location of the machine
Property Location As %String(%JSONFIELDNAME = "location", MAXLEN = 100);

/// Unit of Measurement of the equipment
Property UoM As %String(%JSONFIELDNAME = "uom");

/// Equipment Yields
Property Yields As list Of Yield(%JSONFIELDNAME = "yields");

/// Bridge property for many-to-many relationship
Relationship EquipmentConfiguration As opc.ua.config.EquipmentConfiguration(%JSONINCLUDE = "None") [ Cardinality = many, Inverse = Equipment ];

Index EquipmentNameIndex On Name [ Unique ];

/// Check if configuration is already part of the equipment
ClassMethod isConfigurationInEquipment(pEquipmentName As %String, pConfigurationName As %String) As %Boolean
{
	&sql(SELECT Equipment INTO :tEquipmentId FROM opc_ua_config.EquipmentConfiguration 
	     WHERE Equipment->Name = :pEquipmentName 
	     AND Configuration->Name = :pConfigurationName)
	if (SQLCODE '= 0) {
		return 0		
	}    
	
	return 1
}

ClassMethod GetAllEquipment() As %ListOfObjects
{
	set tEquipmentList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT ID INTO :tEquipmentId FROM opc_ua_config.Equipment)	       
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tEquipmentList
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tEquipment = ##class(opc.ua.config.Equipment).%OpenId(tEquipmentId,,.tSc)
    	if ('$$$ISERR(tSc)) {
    		Do tEquipmentList.Insert(tEquipment)    		
    	}
    &sql(FETCH C1)
    }
	&sql(CLOSE C1)
		
	return tEquipmentList
}

/// Get all equipment definitions
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

/// Get equipment configurations
/// Standaard get the current equipment configurations
Method SearchEquipmentConfigurations(pIsCurrentVersion As %Boolean = 1, Output Status As %Status) As %ListOfObjects
{
	
	set tConfigurationList = ##class(%ListOfObjects).%New()
	set tName = ..Name
		        
	&sql(DECLARE C1 CURSOR FOR
        SELECT Configuration->ID INTO :tConfigurationId
	       FROM opc_ua_config.EquipmentConfiguration 
	      WHERE Equipment->Name = :tName	        
	        AND Configuration->IsCurrentVersion = :pIsCurrentVersion)	       
    &sql(OPEN C1)
    if SQLCODE '= 0 quit tConfigurationList
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tConfiguration = ##class(opc.ua.config.Configuration).%OpenId(tConfigurationId,,.tSc)
    	if ('$$$ISERR(tSc)) {
    		Do tConfigurationList.Insert(tConfiguration)    		
    	}
    &sql(FETCH C1)
    }
	&sql(CLOSE C1)     
	
	return tConfigurationList
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

/// Get the yield value
Method GetYield(pName As %String) As %Double
{
	
	for i=1:1:..Yields.Count() {
		set tYield = ..Yields.GetAt(i)		
		if tYield.Name = pName {
			return tYield.Value
		}
	}
	return 0
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
<Value name="7">
<Value>UoM</Value>
</Value>
<Value name="8">
<Value>Yields</Value>
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
