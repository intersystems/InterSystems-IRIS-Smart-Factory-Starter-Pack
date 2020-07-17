Include Ensemble

/// Equipment configuration for a specific stage. Multiple configurations for an equipment 
/// can exists. All JSON fields needs to be added with snake_case.
Class opc.ua.config.Configuration Extends (%Persistent, %JSON.Adaptor)
{

/// Name of the configuration
Property Name As %String(%JSONFIELDNAME = "name") [ Required ];

/// The type of configuration, corresponding to the 3 "stages"
Property ConfigType As %String(%JSONFIELDNAME = "config_type", VALUELIST = ",staging,transforming,serving") [ Required ];

/// Description of the configuration
Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 1000);

/// Version of the configuration
Property Version As %String(%JSONFIELDNAME = "version");

/// Current version of the configuration
Property IsCurrentVersion As %Boolean(%JSONFIELDNAME = "current_version") [ InitialExpression = 0 ];

/// Begin time of this configuration 
Property EffectiveBegin As %TimeStamp(%JSONFIELDNAME = "effective_begin");

/// End time of this configuration
Property EffectiveEnd As %TimeStamp(%JSONFIELDNAME = "effective_end");

/// Add the standard OEE fields when this property is set 
Property StandardOEEFields As %Boolean(%JSONFIELDNAME = "standard_oee_fields") [ InitialExpression = 0 ];

/* TBD. Create the PowerBi dataset via the configured PowerBI operation. Be aware that
// this connector needs to be correctly configured.
// Property PowerBiDataSet As %Boolean(%JSONFIELDNAME = "create_powerbi_dataset") [ InitialExpression = 0 ];
*/
/// Bridge property for many-to-many relationship to configuration
Relationship EquipmentConfiguration As opc.ua.config.EquipmentConfiguration(%JSONINCLUDE = "None") [ Cardinality = many, Inverse = Configuration ];

/// Bridge property for many-to-many relationship to the nodes
Relationship ConfigurationNode As opc.ua.config.ConfigurationNode(%JSONINCLUDE = "None") [ Cardinality = many, Inverse = Configuration ];

Index ConfigurationNameIndex On Name [ Unique ];

/// Get all configurations
ClassMethod GetAllConfigurations() As %ListOfObjects
{
	set tConfigurationList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT ID INTO :tConfigurationId FROM opc_ua_config.Configuration)	       
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tConfigurationList
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

/// Get all configurations definitions
/// Get the configurations by specifying the name
ClassMethod SearchByName(pName As %String, Output Status As %Status) As opc.ua.config.Equipment
{
	set tConfiguration = ""
	&sql(SELECT ID INTO :tId FROM opc_ua_config.Configuration WHERE name=:pName)
	if (SQLCODE = 0) {
		set tConfiguration =  ##class(opc.ua.config.Configuration).%OpenId(tId, , .Status)
		if $$$ISERR(Status) return ""		
	}
	
	return tConfiguration
}

/// Check if the node is in the configuration 
/// True - node exists in configuration
/// False - node doesn't exists in configuration 
ClassMethod isNodeInConfiguration(pConfigurationName As %String, pNodeId As %String) As %Boolean
{
	&sql(SELECT Node INTO :tNodeId FROM opc_ua_config.ConfigurationNode 
	     WHERE Configuration->Name = :pConfigurationName 
	     AND Node->GUID = :pNodeId)
	if (SQLCODE '= 0) {
		return 0		
	}    
	
	return 1
}

/// Get nodes for the specified configuration
ClassMethod GetNodes(pConfigurationName As %String) As %ListOfObjects
{
	set tNodeList = ##class(%ListOfObjects).%New()
		
	set Query = "SELECT Node FROM opc_ua_config.ConfigurationNode WHERE Configuration->Name = ?"
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query, pConfigurationName)
	while rs.%Next() {
		set Node = ##class(opc.ua.config.Node).%OpenId(rs.Node, , .sc)
		if sc do tNodeList.Insert(Node)
	}
	
	return tNodeList
}

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>version</Value>
</Value>
<Value name="4">
<Value>isCurrent</Value>
</Value>
<Value name="5">
<Value>isCurrentVersion</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Version</Value>
</Value>
<Value name="8">
<Value>IsCurrentVersion</Value>
</Value>
<Value name="9">
<Value>EffectiveBegin</Value>
</Value>
<Value name="10">
<Value>EffectiveEnd</Value>
</Value>
<Value name="11">
<Value>Description</Value>
</Value>
<Value name="12">
<Value>ConfigType</Value>
</Value>
<Value name="13">
<Value>StandardOEEFields</Value>
</Value>
<Value name="14">
<Value>PowerBiDataSet</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<IdLocation>^opc.ua.config.ConfigurationD</IdLocation>
<IndexLocation>^opc.ua.config.ConfigurationI</IndexLocation>
<StreamLocation>^opc.ua.config.ConfigurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
