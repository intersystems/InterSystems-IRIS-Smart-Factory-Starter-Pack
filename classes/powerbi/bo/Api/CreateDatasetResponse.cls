/// Create dataset response
Class powerbi.bo.Api.CreateDatasetResponse Extends (Ens.Response, %JSON.Adaptor)
{

/// OData context
Property odataContext As %String(%JSONFIELDNAME = "@odata.context", MAXLEN = "");

/// Dataset identifier
Property id As %String(MAXLEN = "");

/// Dataset name
Property name As %String(MAXLEN = "");

/// Dataset retention policy
Property defaultRetentionPolicy As %String(MAXLEN = "");

/// Dataset storage mode
Property targetStorageMode As %String(MAXLEN = "");

/// Error
Property error As powerbi.data.Error;

Storage Default
{
<Data name="CreateDatasetResponseDefaultData">
<Subscript>"CreateDatasetResponse"</Subscript>
<Value name="1">
<Value>odataContext</Value>
</Value>
<Value name="2">
<Value>id</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
<Value name="4">
<Value>defaultRetentionPolicy</Value>
</Value>
<Value name="5">
<Value>targetStorageMode</Value>
</Value>
<Value name="6">
<Value>error</Value>
</Value>
</Data>
<DefaultData>CreateDatasetResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
