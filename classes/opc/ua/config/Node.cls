/// Node definition
Class opc.ua.config.Node Extends (%Persistent, %JSON.Adaptor) [ DependsOn = opc.ua.config.ConfigurationNode ]
{

/// Node GUID
Property GUID As %String(%JSONFIELDNAME = "id", %JSONINCLUDE = "outputonly") [ InitialExpression = {$SYSTEM.Util.CreateGUID()} ];

/// Logical name of the node
Property Name As %String(%JSONFIELDNAME = "name") [ Required ];

/// Display name of the node
Property DisplayName As %String(%JSONFIELDNAME = "display_name");

/// Tag description
Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 1000);

/// Node identifier of the node in OPC UA client
Property NodeId As %String(%JSONFIELDNAME = "opc_ua_node");

/// Database attribute 
Property DatabaseAttribute As %String(%JSONFIELDNAME = "database_attribute");

/// Database type of this node
Property DatabaseType As %String(%JSONFIELDNAME = "database_type", VALUELIST = ",string,integer,double,float,decimal,boolean,time,timestamp,date") [ InitialExpression = "string" ];

/// Length of the property in the database
Property DatabaseLength As %Integer(%JSONFIELDNAME = "database_length");

/// When true the node will be indexed
Property IsIndexed As %Boolean(%JSONFIELDNAME = "is_indexed") [ InitialExpression = 0 ];

/// Bridge property for many-to-many relationship to configuration
Relationship NodeConfiguration As opc.ua.config.ConfigurationNode(%JSONINCLUDE = "none") [ Cardinality = many, Inverse = Node ];

/// Get all nodes
ClassMethod GetAllNodes() As %ListOfObjects
{
	set tNodesList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT ID INTO :tNodeId FROM opc_ua_config.Node)	       
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tNodesList
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tNode = ##class(opc.ua.config.Node).%OpenId(tNodeId,,.tSc)    	
    	if ('$$$ISERR(tSc)) {
    		Do tNodesList.Insert(tNode)    		
    	}
    &sql(FETCH C1)
    }
	&sql(CLOSE C1)
		
	return tNodesList
}

/// Get the Node by GUID
ClassMethod SearchByGUID(pGUID As %String, Output Status As %Status) As opc.ua.config.Node
{
	set tNode = ""
	&sql(SELECT ID INTO :tId FROM opc_ua_config.Node WHERE GUID=:pGUID)
	if (SQLCODE = 0) {
		set tNode =  ##class(opc.ua.config.Node).%OpenId(tId, , .Status)
		if $$$ISERR(Status) return ""		
	}
	
	return tNode
}

Storage Default
{
<Data name="NodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>DisplayName</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>NodeId</Value>
</Value>
<Value name="6">
<Value>IsInput</Value>
</Value>
<Value name="7">
<Value>DatabaseAttribute</Value>
</Value>
<Value name="8">
<Value>DatabaseType</Value>
</Value>
<Value name="9">
<Value>DatabaseLength</Value>
</Value>
<Value name="10">
<Value>IsIndexed</Value>
</Value>
<Value name="11">
<Value>Id</Value>
</Value>
<Value name="12">
<Value>Identifier</Value>
</Value>
<Value name="13">
<Value>GUID</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.NodeD</DataLocation>
<DefaultData>NodeDefaultData</DefaultData>
<IdLocation>^opc.ua.config.NodeD</IdLocation>
<IndexLocation>^opc.ua.config.NodeI</IndexLocation>
<StreamLocation>^opc.ua.config.NodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
