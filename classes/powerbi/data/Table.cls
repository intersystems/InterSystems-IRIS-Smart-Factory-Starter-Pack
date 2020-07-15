/// The dataset tables
Class powerbi.data.Table Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

/// Table name
Property name As %String(MAXLEN = "");

/// Table columns
Property columns As list Of powerbi.data.Column;

Storage Default
{
<Data name="TableState">
<Value name="1">
<Value>name</Value>
</Value>
<Value name="2">
<Value>columns</Value>
</Value>
</Data>
<State>TableState</State>
<StreamLocation>^powerbi.data.TableS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
