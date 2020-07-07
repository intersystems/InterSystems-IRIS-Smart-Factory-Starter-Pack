/// ISO Unit of Measurement
Class opc.ua.config.UoM Extends (%Persistent, %JSON.Adaptor)
{

/// Format of the unit
Property Format As %String(%JSONFIELDNAME = "format", MAXLEN = 4);

/// Description of the unit
Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = "");

ClassMethod GetUoMList() As %ListOfObjects
{
	set tUoMList = ##class(%ListOfObjects).%New()
	
	set tQuery = "SELECT ID FROM opc_ua_config.UoM"
	set tResultSet = ##class(%SQL.Statement).%ExecDirect(,tQuery)
	if tResultSet.%SQLCODE'=0 $$$ThrowSQLCODE(tResultSet.%SQLCODE,tResultSet.%Message)
	
	while tResultSet.%Next() {
		set tItem = ##class(opc.ua.config.UoM).%OpenId(tResultSet.%GetData(1))
		do tUoMList.Insert(tItem)
	}
	return tUoMList
}

ClassMethod GetUoMFormatString(format As %String) As %String
{
	set tQuery = "SELECT ID FROM opc_ua_config.UoM WHERE Format LIKE ?"
	set tStatement = ##class(%SQL.Statement).%New()
	set st = tStatement.%Prepare(tQuery)
	if st'=1 $$$ThrowOnError(st)
	set tResultSet = tStatement.%Execute(format)
	if tResultSet.%SQLCODE'=0 $$$ThrowSQLCODE(tResultSet.%SQLCODE,tResultSet.%Message)
	
	if tResultSet.%Next() {
		set tUoMFormat = ##class(opc.ua.config.UoM).%OpenId(tResultSet.%GetData(1))
		return tUoMFormat
	}
	else {
		return ""
	}
}

Storage Default
{
<Data name="UoMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Format</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.UoMD</DataLocation>
<DefaultData>UoMDefaultData</DefaultData>
<IdLocation>^opc.ua.config.UoMD</IdLocation>
<IndexLocation>^opc.ua.config.UoMI</IndexLocation>
<StreamLocation>^opc.ua.config.UoMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
