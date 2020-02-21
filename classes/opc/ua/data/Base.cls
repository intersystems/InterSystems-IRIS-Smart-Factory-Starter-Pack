Include Ensemble

Class opc.ua.data.Base Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor) [ Abstract ]
{

/// Date/time of measurement
Property TimeStamp As %TimeStamp [ SqlColumnNumber = 2 ];

Index OnTimeStamp On TimeStamp;

ClassMethod Insert(Input As opc.ua.rest.Data, Output Id As %String) As %Status
{
	Set Id = ""
	
	; Get data from previous record as default values for this one
	set sc = ..GetLastRecord(.Data)
	if 'sc Quit sc
	
	; Get current readings
	for i = 1:1:Input.Nodes.Count() {
		#dim Node As opc.ua.rest.Node
		set Node = Input.Nodes.GetAt(i)
		set Data(Node.NodeId) = Node.NodeValue
	}
	
	; Save updated readings; this returns the id of the row that was inserted
	set sc = ..SaveData(Input.TimeStamp, .Data, .Id)	
	if 'sc Quit sc
	
	quit $$$OK
}

/// Returns the previous reading
Method PreviousReadingGet() As opc.ua.data.Base
{
		
	; Dynamic query, to retrieve the correct reading 
	set Query = ""
	set Query = Query_"SELECT TOP 1 ID AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	
	if ..%Id()'= "" { 
		set Query = Query_" WHERE ID < ?"
	}	
	set Query = Query_" ORDER BY ID DESC"	
	
	$$$TRACE("Previous reading query ["_Query_"]")
	
	#dim rs As %SQL.StatementResult
	if ..%Id() '= "" {
		set rs = ##class(%SQL.Statement).%ExecDirect(, Query, ..%Id())
	} else {
		/// Is needed because giving a parameter in the ExecDirect and not using it in 
		/// the query will result in and empty resultset.
		set rs = ##class(%SQL.Statement).%ExecDirect(, Query)
	}		 
	
	if 'rs.%Next(.sc) {
		$$$TRACE("Nothing found ["_$System.Status.GetErrorText(sc)_"]")
		quit ""
	}
	
	set ret = ##class(opc.ua.data.Base).%OpenId(rs.Result,,.sc)
	if $$$ISERR(sc) $$$TRACE($System.Status.GetErrorText(sc))
	return ret
}


// TODO: Move to util.FunctionSet for general use. Object must be passed  

/// Returns the average, in the given time period, for a reading value.
/// The periode is a half-open interval: including start time, but excluding
/// end time.
ClassMethod Average(From As %TimeStamp, To As %TimeStamp, Reading As %String) As %Float
{
	; Dynamic query, as we don't know the column to average in advance
	set Query = ""
	set Query = Query_"SELECT AVG("_Reading_") AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set Query = Query_" WHERE TimeStamp >= ?"
	set Query = Query_"   AND TimeStamp < ?"
	
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query, From, To)
	if 'rs.%Next(.sc) {
		$$$TRACE($System.Status.GetErrorText(sc))
		quit ""
	}
	
	quit rs.Result
}

/// Returns the minimum value, in the given time period, for a reading value.
/// The periode is a half-open interval: including start time, but excluding
/// end time.
ClassMethod Minimum(From As %TimeStamp, To As %TimeStamp, Reading As %String) As %Float
{
	; Dynamic query, as we don't know the column to average in advance
	set Query = ""
	set Query = Query_"SELECT MIN("_Reading_") AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set Query = Query_" WHERE TimeStamp >= ?"
	set Query = Query_"   AND TimeStamp < ?"
	
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query, From, To)
	if 'rs.%Next(.sc) {
		$$$TRACE($System.Status.GetErrorText(sc))
		quit ""
	}
	
	quit rs.Result
}

/// Returns the maximum value, in the given time period, for a reading value.
/// The periode is a half-open interval: including start time, but excluding
/// end time.
ClassMethod Maximum(From As %TimeStamp, To As %TimeStamp, Reading As %String) As %Float
{
	; Dynamic query, as we don't know the column to average in advance
	set Query = ""
	set Query = Query_"SELECT MAX("_Reading_") AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set Query = Query_" WHERE TimeStamp >= ?"
	set Query = Query_"   AND TimeStamp < ?"
	
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query, From, To)
	if 'rs.%Next(.sc) {
		$$$TRACE($System.Status.GetErrorText(sc))
		quit ""
	}
	
	quit rs.Result
}

// =====

Storage Default
{
<Data name="BaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimeStamp</Value>
</Value>
</Data>
<DataLocation>^opc.ua.data.BaseD</DataLocation>
<DefaultData>BaseDefaultData</DefaultData>
<IdLocation>^opc.ua.data.BaseD</IdLocation>
<IndexLocation>^opc.ua.data.BaseI</IndexLocation>
<StreamLocation>^opc.ua.data.BaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
