/// Node data
Class opc.ua.rest.data.Node Extends (%SerialObject, %JSON.Adaptor)
{

/// Node identifier
Property NodeId As %String(%JSONFIELDNAME = "nodeid");

/// Node value
Property NodeValue As %String(%JSONFIELDNAME = "nodevalue");

Storage Default
{
<Data name="NodeState">
<Value name="1">
<Value>NodeId</Value>
</Value>
<Value name="2">
<Value>NodeValue</Value>
</Value>
</Data>
<State>NodeState</State>
<StreamLocation>^opc.ua.rest.data.NodeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
