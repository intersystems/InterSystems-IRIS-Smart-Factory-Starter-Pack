Class JDE.data.WorkOrdersRouting Extends (%Persistent,%JSON.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property WorkOrders As list Of JDE.data.WorkOrders;

Storage Default
{
<Data name="WorkOrdersRoutingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkOrders</Value>
</Value>
</Data>
<DataLocation>^JDE.data.WorkOrdersRoutingD</DataLocation>
<DefaultData>WorkOrdersRoutingDefaultData</DefaultData>
<IdLocation>^JDE.data.WorkOrdersRoutingD</IdLocation>
<IndexLocation>^JDE.data.WorkOrdersRoutingI</IndexLocation>
<StreamLocation>^JDE.data.WorkOrdersRoutingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}