/// Error class
Class opc.ua.rest.Error Extends (%SerialObject, %JSON.Adaptor)
{

/// Error code to set
Property Code As %Integer [ Required ];

/// Message to display
Property Message As %String(MAXLEN = 2048);

/// Generate an error message easily in JSON
ClassMethod GenerateErrorInJSON(pCode As %Integer, pMessage As %String) As %String
{
	
	#dim tError As opc.ua.rest.Error
	set tError = ##class(opc.ua.rest.Error).%New()
	set tError.Code = pCode
	set tError.Message = pMessage
	do tError.%JSONExportToString(.jsonError)
	return jsonError
}

Storage Default
{
<Data name="ErrorDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="ErrorState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Message</Value>
</Value>
</Data>
<DataLocation>^opc.ua.rest.ErrorD</DataLocation>
<DefaultData>ErrorDefaultData</DefaultData>
<IdLocation>^opc.ua.rest.ErrorD</IdLocation>
<IndexLocation>^opc.ua.rest.ErrorI</IndexLocation>
<State>ErrorState</State>
<StreamLocation>^opc.ua.rest.ErrorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
