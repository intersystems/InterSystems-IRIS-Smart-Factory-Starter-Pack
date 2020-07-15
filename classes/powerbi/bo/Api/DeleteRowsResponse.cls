/// Delete rows response
Class powerbi.bo.Api.DeleteRowsResponse Extends (Ens.Response, %JSON.Adaptor)
{

/// Error
Property error As powerbi.data.Error;

Storage Default
{
<Data name="DeleteRowsResponseDefaultData">
<Subscript>"DeleteRowsResponse"</Subscript>
<Value name="1">
<Value>error</Value>
</Value>
</Data>
<DefaultData>DeleteRowsResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
