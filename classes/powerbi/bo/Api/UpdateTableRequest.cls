/// Adds new data rows to the specified table
Class powerbi.bo.Api.UpdateTableRequest Extends Ens.Request
{

/// DataSet the table belongs to
Property dataSetId As %String(MAXLEN = "");

/// The updated table definition
Property Table As powerbi.data.Table;

Storage Default
{
<Data name="UpdateTableRequestDefaultData">
<Subscript>"UpdateTableRequest"</Subscript>
<Value name="1">
<Value>dataSetId</Value>
</Value>
<Value name="2">
<Value>Table</Value>
</Value>
</Data>
<DefaultData>UpdateTableRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
