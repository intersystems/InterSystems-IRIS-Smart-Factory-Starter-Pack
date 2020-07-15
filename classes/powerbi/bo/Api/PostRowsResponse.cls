/// Post rows response
Class powerbi.bo.Api.PostRowsResponse Extends (Ens.Response, %JSON.Adaptor)
{

/// Error
Property error As powerbi.data.Error;

Storage Default
{
<Data name="PostRowsResponseDefaultData">
<Subscript>"PostRowsResponse"</Subscript>
<Value name="1">
<Value>error</Value>
</Value>
</Data>
<DefaultData>PostRowsResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
