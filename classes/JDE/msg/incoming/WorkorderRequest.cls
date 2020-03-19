Class JDE.msg.incoming.WorkorderRequest Extends Ens.Request
{

Property Workorder As JDE.data.incoming.Workorder;

Storage Default
{
<Data name="WorkorderRequestDefaultData">
<Subscript>"WorkorderRequest"</Subscript>
<Value name="1">
<Value>Workorder</Value>
</Value>
</Data>
<DefaultData>WorkorderRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
