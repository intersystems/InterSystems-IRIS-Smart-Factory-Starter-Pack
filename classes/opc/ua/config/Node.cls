/// Node definition
Class opc.ua.config.Node Extends %Persistent
{

/// Logical name of the node
Property Name As %String [ Required ];

/// Display name of the node
Property DisplayName As %String;

/// Tag description
Property Description As %String(MAXLEN = 1000);

/// NodeId of the node
Property NodeId As %String;

/// Database attribute 
Property DatabaseAttribute As %String;

/// Database type of this node
Property DatabaseType As %String(VALUELIST = ",string,integer,double,float,decimal") [ InitialExpression = "string" ];

/// Length of the property in the database
Property DatabaseLength As %Integer;

/// When true the node will be indexed
Property IsIndexed As %Boolean [ InitialExpression = 0 ];

/// Bridge property for many-to-many relationship to configuration
Relationship NodeConfiguration As opc.ua.config.ConfigurationNode [ Cardinality = many, Inverse = Node ];

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
</Data>
<DataLocation>^opc.ua.config.NodeD</DataLocation>
<DefaultData>NodeDefaultData</DefaultData>
<IdLocation>^opc.ua.config.NodeD</IdLocation>
<IndexLocation>^opc.ua.config.NodeI</IndexLocation>
<StreamLocation>^opc.ua.config.NodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
