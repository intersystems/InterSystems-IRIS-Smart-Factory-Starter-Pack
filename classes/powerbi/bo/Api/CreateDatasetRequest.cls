Class powerbi.bo.Api.CreateDatasetRequest Extends (Ens.Request, %JSON.Adaptor)
{

/// Datasources associated with this dataset
Property datasources As list Of powerbi.data.Datasource;

/// Default mode for this dataset
Property defaultMode As %String(DISPLAYLIST = ",AsAzure,AsOnPrem,Push,PushStreaming,Streaming", VALUELIST = ",AsAzure,AsOnPrem,Push,PushStreaming,Streaming");

/// The dataset name
Property name As %String(MAXLEN = "");

/// The dataset relationships
Property relationships As list Of powerbi.data.Relationship;

/// The dataset tables
Property tables As list Of powerbi.data.Table;

Storage Default
{
<Data name="CreateDatasetRequestDefaultData">
<Subscript>"CreateDatasetRequest"</Subscript>
<Value name="1">
<Value>datasources</Value>
</Value>
<Value name="2">
<Value>defaultMode</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
<Value name="4">
<Value>relationships</Value>
</Value>
<Value name="5">
<Value>tables</Value>
</Value>
</Data>
<DefaultData>CreateDatasetRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
