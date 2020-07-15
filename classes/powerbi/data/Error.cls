Class powerbi.data.Error Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

/// Error code 
Property ErrorCode As %String;

/// Error Message 
Property ErrorMessage As %String(MAXLEN = "");

Storage Default
{
<Data name="ErrorState">
<Value name="1">
<Value>ErrorCode</Value>
</Value>
<Value name="2">
<Value>ErrorMessage</Value>
</Value>
</Data>
<State>ErrorState</State>
<StreamLocation>^powerbi.data.ErrorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
