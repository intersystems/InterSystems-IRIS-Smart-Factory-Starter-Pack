/// Rows data object holding one or more rows
Class powerbi.data.Rows Extends (%SerialObject, %JSON.Adaptor)
{

Property rows As list Of %RegisteredObject;

Storage Default
{
<Data name="RowsState">
<Value name="1">
<Value>row</Value>
</Value>
<Value name="2">
<Value>rows</Value>
</Value>
</Data>
<State>RowsState</State>
<StreamLocation>^powerbi.data.RowsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
