Include Ensemble

Class opc.ua.data.Base Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor) [ Abstract ]
{

/// Date/time of measurement in UTC
Property TimeStamp As %TimeStamp [ SqlColumnNumber = 2 ];

/// Date/time of measurement in local timezone
Property TimeStampLocal As %TimeStamp;

/// Year of local timestamp
Property YearLocal As %Integer;

/// Month of local timestamp
Property MonthLocal As %Integer;

/// Day (of month) of local timestamp
Property DayLocal As %Integer;

/// Weekday of local timestamp
Property WeekDayLocal As %Integer;

/// Time of local timestamp
Property TimeLocal As %Time;

// =====

Index BitmapExtent [ Extent, Type = bitmap ];

Index OnTimeStamp On TimeStamp;

// =====

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

/// Use this method only for the OEESHIFT tables for now
/// Return the calculated performance
/// [ ( OEEActualOutput 1 * OEEStandardCycleTime 1 ) 
///     + ( OEEActualOutput 2 * OEEStandardCycleTime 2 )
///     + ....… 
///     + ( OEEActualOutput n * OEEStandardCycleTime n ) ]  
ClassMethod SumOEEPerformance() As %Float
{
	; Dynamic query, to retrieve the correct reading 
	set Query = ""
	set Query = Query_"SELECT OEEActualOutput, OEEStandardCycleTime"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set Query = Query_" ORDER BY ID ASC"	
	
	$$$TRACE("Sum OEE Performance ["_Query_"]")
		
	/// Is needed because giving a parameter in the ExecDirect and not using it in 
	/// the query will result in and empty resultset.
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query)		 
	
	set tSumOEEPerformance = 0
	
	WHILE rs.%Next(.tSc) {
		if $$$ISERR(tSc) $$$TRACE($System.Status.GetErrorText(tSc))
      set tSumOEEPerformance = tSumOEEPerformance + (rs.OEEActualOutput * rs.OEEStandardCycleTime)
    } 
	
	return tSumOEEPerformance
}

/// Use this method only for the OEESHIFT tables for now
/// for QEE Quality calculations
/// [ ( (OEEActualOutput 1 -/- OEERejected Output 1 )  *  
///               OEEStandardCycleTime 1 ) 
///    + ( (OEEActualOutput 2 -/- OEERejected Output 2 )  *
///             OEEStandardCycleTime 2 )
///   + … 
///    + ( (OEEActualOutput n -/- OEERejected Output n )  *
///             OEEStandardCycleTime n)  ] 
ClassMethod SumOEEQuality() As %Float
{
	
	; Dynamic query, to retrieve the correct reading 
	set tQuery1 = ""
	set tQuery1 = tQuery1_"SELECT OEEActualOutput, OEERejectedOutput, OEEStandardCycleTime"
	set tQuery1 = tQuery1_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set tQuery1 = tQuery1_" ORDER BY ID ASC"	
	
	set tQuery2 = ""
	set tQuery2 = tQuery2_"SELECT OEEActualOutput, OEEStandardCycleTime"
	set tQuery2 = tQuery2_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set tQuery2 = tQuery2_" ORDER BY ID ASC"
	
	$$$TRACE("Sum OEE Quality ["_tQuery1_"] / ["_tQuery2_"]")
		
	/// Is needed because giving a parameter in the ExecDirect and not using it in 
	/// the query will result in and empty resultset.
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, tQuery1)	 
		
	set tSumOEEQualityNumerator = 0	
	WHILE rs.%Next(.tSc) {
		if $$$ISERR(tSc) $$$TRACE($System.Status.GetErrorText(tSc))
    set tSumOEEQualityNumerator = tSumOEEQualityNumerator + ((rs.OEEActualOutput - rs.OEERejectedOutput) * rs.OEEStandardCycleTime)
  }
  
  set rs = ##class(%SQL.Statement).%ExecDirect(, tQuery2)
  set tSumOEEQualityDenominator = 0
  WHILE rs.%Next(.tSc) {
		if $$$ISERR(tSc) $$$TRACE($System.Status.GetErrorText(tSc))
    set tSumOEEQualityDenominator = tSumOEEQualityDenominator + (rs.OEEActualOutput * rs.OEEStandardCycleTime)
  }
  
  /// To prevent divide by 0 errors
  if tSumOEEQualityDenominator=0 set tSumOEEQualityDenominator = 1
  
	$$$TRACE("SumOEEQuality "_(tSumOEEQualityNumerator/tSumOEEQualityDenominator)) 
	return tSumOEEQualityNumerator / tSumOEEQualityDenominator
}

/// Get the last reading
ClassMethod GetLastReading() As opc.ua.data.Base
{
	
	; Dynamic query, to retrieve the correct reading 
	set Query = ""
	set Query = Query_"SELECT TOP 1 ID AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
	set Query = Query_" ORDER BY ID DESC"	
	
	$$$TRACE("Get last reading query ["_Query_"]")
		
	/// Is needed because giving a parameter in the ExecDirect and not using it in 
	/// the query will result in and empty resultset.
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query)		 
	
	if 'rs.%Next(.sc) {
		$$$TRACE("Nothing found ["_$System.Status.GetErrorText(sc)_"]")
		quit ""
	}
	
	set ret = ##class(opc.ua.data.Base).%OpenId(rs.Result,,.sc)
	if $$$ISERR(sc) $$$TRACE($System.Status.GetErrorText(sc))
	return ret
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

/// Sum of the specified attribute
ClassMethod Sum(Attribute As %String) As %Float
{
	; Dynamic query, as we don't know the column to average in advance
	set Query = ""
	set Query = Query_"SELECT SUM("_Attribute_") AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
		
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query)
	if 'rs.%Next(.sc) {
		$$$TRACE($System.Status.GetErrorText(sc))
		quit ""
	}
	
	quit rs.Result
}

/// Count the number of objects
ClassMethod CountDistinct(Attribute As %String) As %Float
{
	; Dynamic query, as we don't know the column to average in advance
	set Query = ""
	set Query = Query_"SELECT COUNT(DISTINCT("_Attribute_")) AS Result"
	set Query = Query_"  FROM "_$$$comClassKeyGet(..%ClassName(1), $$$cCLASSsqlqualifiednameQ)
		
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, Query)
	if 'rs.%Next(.sc) {
		$$$TRACE($System.Status.GetErrorText(sc))
		quit ""
	}
	
	quit rs.Result
}

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

/// Converts ..TimeStamp from UTC to local time, and fills in the
/// various local date/time fields.
Method SetLocalTimes() As %Status
{
	; Convert timestamp to horolog/$ZTimestamp format
	set Horolog = $ZDateTimeH(..TimeStamp, 3)
	; Convert to local time
	set HorologLocal = $ZDateTimeH(..TimeStamp, -3)
	
	; Save various local parts of timestamp
	set ..TimeStampLocal = $ZDateTime(HorologLocal, 3, 1, 2)
	set ..YearLocal = $Piece(..TimeStampLocal, "-", 1)
	set ..MonthLocal = $Piece(..TimeStampLocal, "-", 2)
	set ..DayLocal = $Piece(..TimeStampLocal, "-", 3)
	set ..WeekDayLocal = $ZDate(+HorologLocal, 10)
	set ..TimeLocal = $Piece(HorologLocal, ",", 2)
	
	return $$$OK
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
<Value name="3">
<Value>TimeStampLocal</Value>
</Value>
<Value name="4">
<Value>YearLocal</Value>
</Value>
<Value name="5">
<Value>MonthLocal</Value>
</Value>
<Value name="6">
<Value>DayIDLocal</Value>
</Value>
<Value name="7">
<Value>DayLocal</Value>
</Value>
<Value name="8">
<Value>TimeLocal</Value>
</Value>
<Value name="9">
<Value>WeekDayLocal</Value>
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
