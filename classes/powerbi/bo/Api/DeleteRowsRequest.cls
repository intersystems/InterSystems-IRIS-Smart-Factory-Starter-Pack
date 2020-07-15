/// Delete all the rows
Class powerbi.bo.Api.DeleteRowsRequest Extends Ens.Request
{

/// Dataset identifier 
Property datasetId As %String(MAXLEN = "");

/// Table name within the dataset
Property tableName As %String(MAXLEN = "") [ Required ];

Storage Default
{
<Data name="DeleteRowsRequestDefaultData">
<Subscript>"DeleteRowsRequest"</Subscript>
<Value name="1">
<Value>datasetId</Value>
</Value>
<Value name="2">
<Value>tableName</Value>
</Value>
</Data>
<DefaultData>DeleteRowsRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
