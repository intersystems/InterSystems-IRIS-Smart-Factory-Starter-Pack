Include Ensemble

/// This class contains a set of utility methods that can be used for metrics calculations 
/// by Business Rules, DTL transforms and the like.
Class opc.ua.util.FunctionSet Extends Ens.Rule.FunctionSet [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/* NOTE: the names of these function arguments are used by
the expression editor. DO NOT MODIFY THEM!
*/
/// Convert UTC time to LocalTime
ClassMethod ConvertUTCToLocalTimeStamp(pUTCTimeStamp As %TimeStamp) As %TimeStamp [ Final ]
{
	return $ZDATETIME($ZDATETIMEH($ZDATETIMEH(pUTCTimeStamp,3),-3),3,1,2)
}

/// Takes string <var>value</var> representing a date/time value in format <var>timestamp</var> and converts it to
/// a date string in format dformat <var>outformat</var> in the local timezone. 
ClassMethod ConvertUTCtoLocal(pUTCTimeStamp As %TimeStamp, pOutformat As %Integer) As %Integer [ Final ]
{
	return $ZDATE($ZDATETIMEH($ZDATETIMEH(pUTCTimeStamp,3),-3), pOutformat)
}

/// Subtracts <var>pTimeStamp1</var> from <var>pTimeStamp2</var>, and returns
/// the result measured in units determined by pOutputFormat:
/// year: "yyyy", "yy"
/// month: "mm", "m"
/// week: "wk", "ww"
/// weekday: "dw"
/// day: "dd", "d"
/// dayofyear: "dy"
/// hour: "hh"
/// minute: "mi", "n"
/// second: "ss", "s"
/// millisecond: "ms"
ClassMethod TimeStampSubstract(pTimeStamp1 As %TimeStamp, pTimeStamp2 As %TimeStamp, pOutputFormat As %String) As %Double [ Final ]
{
	return $System.SQL.DATEDIFF(pOutputFormat, pTimeStamp1, pTimeStamp2)
}

/// Determine if there is a mispass
/// BaseValue - is the value to measure the yield from
/// Yield - yield for the basevalue
/// CurValue - field to compare against the BaseValue
ClassMethod IsMisPass(pBaseValue As %Double, pYield As %Double, pCurValue As %Double) As %Boolean [ Final ]
{
	
	if (pCurValue < (pBaseValue - pYield) || pCurValue > (pBaseValue + pYield)) {		
		return 1
	} else {		
		return 0
	}
}

/// Retrieve the persistent object identifier as bigint
ClassMethod GetPersistentId(pObj As %Persistent) As %BigInt [ Final ]
{
	return pObj.%Id()
}

/// Retrieve Start time of the Shift
ClassMethod GetStartTimeShift(pShiftIdentifier As %BigInt) As %Time [ Final ]
{
	&sql(SELECT StartTime INTO :tStartTime FROM opc_ua_config.Shift WHERE ID = :pShiftIdentifier)
	if SQLCODE = 0 {
		$$$TRACE("Found starttime")
		return tStartTime
	}
	
	return ""
}

ClassMethod GetShiftId(pShiftIdentifier As %BigInt) As %Integer [ Final ]
{
	&sql(SELECT ShiftNumber INTO :tShiftNumber FROM opc_ua_config.Shift WHERE ID = :pShiftIdentifier)
	if SQLCODE = 0 {
		$$$TRACE("Found shiftnumber")
		return tShiftNumber
	}
	
	return ""
}

ClassMethod IsShiftActive(pShiftIdentifier As %BigInt) As %Boolean [ Final ]
{
	&sql(SELECT Active INTO :tActive FROM opc_ua_config.Shift WHERE ID = :pShiftIdentifier)
	if SQLCODE = 0 {
		$$$TRACE("Is shift active")
		return tActive
	}
	return 0 // Defaults to false when no value can be found
}

/// Get the current shift identifier. Shift times can be added in local time format. When this is True put 
/// pConvertToLocalTimestamp to 1
ClassMethod GetCurrentShiftId(pUTCTimeStamp As %TimeStamp, pConvertToLocalTimeStamp As %Boolean) As %BigInt [ Final ]
{
	
	set tTimeStamp = pUTCTimeStamp
	
	/// Convert to local timestamp if necessary
	if pConvertToLocalTimeStamp {
		$$$TRACE("Convert to local time")
		set tTimeStamp = ##class(opc.ua.util.FunctionSet).ConvertUTCToLocalTimeStamp(pUTCTimeStamp)
	} 
	
	/// Get Time
	set tTime = $ZTIME($ZDATETIMEH(tTimeStamp,3, 1),1)
		
	/// Get DayOfWeek
	set tDayOfWeek =  $SYSTEM.SQL.DAYOFWEEK(tTimeStamp)
	set tNextDayOfWeek = tDayOfWeek + 1
	$$$TRACE("Day of week ["_tDayOfWeek_"]")
	
	&sql(SELECT ID INTO :id from opc_ua_config.Shift 
	     WHERE ((StartDayOfWeek = :tDayOfWeek and EndDayOfWeek = :tDayOfWeek) 
	     OR (StartDayOfWeek = :tDayOfWeek and EndDayOfWeek = :tNextDayOfWeek))
	     AND StartTime <= current_time AND EndTime >= current_time
	     AND ValidFrom <= current_date AND ValidTo >= current_date)
	IF SQLCODE=0 {
		$$$TRACE("Found shift "_id)
	}
	
	return id
}

/// Returns the average value, in the given time period, for the values
/// of attribute Attribute in all objects with the same type as Object.
/// The periode is a half-open interval: including start time, but excluding
/// end time.
ClassMethod Average(Object As opc.ua.data.Base, Attribute As %String, From As %TimeStamp, To As %TimeStamp) As %Float [ Final ]
{
	return Object.Average(From, To, Attribute)
}

/// Returns the minimum value, in the given time period, for the values
/// of attribute Attribute in all objects with the same type as Object.
/// The periode is a half-open interval: including start time, but excluding
/// end time.
ClassMethod Minimum(Object As opc.ua.data.Base, Attribute As %String, From As %TimeStamp, To As %TimeStamp) As %Float [ Final ]
{
	return Object.Minimum(From, To, Attribute)
}

/// Returns the maximum value, in the given time period, for the values
/// of attribute Attribute in all objects with the same type as Object.
/// The periode is a half-open interval: including start time, but excluding
/// end time.
ClassMethod Maximum(Object As opc.ua.data.Base, Attribute As %String, From As %TimeStamp, To As %TimeStamp) As %Float [ Final ]
{
	return Object.Maximum(From, To, Attribute)
}

/// Combines the values in RECEPTNAAM1...5, each value containing 2 bytes,
/// to the recipe name. If a byte has value 0, it is assumed to be the end
/// of the recipe name.
ClassMethod GetRecipeName(Parts... As %Integer) As %String [ Final ]
{
	set Result = ""
	for i = 1:1:$Get(Parts) {
		set Part = $Get(Parts(i))
		if +Part = 0 quit
		
		; Convert to hexadecimal to extract upper and lower bytes
		set PartHex = $ZHex(Part)
		
		; Make sure leading zeroes are present for $Extract to work
		set PartHex = $Translate($Justify(PartHex, 4), " ", "0")
		
		; Convert upper byte to ascii
		set Byte = $ZHex($Extract(PartHex, 1, 2))
		if Byte = 0 quit
		set Result = Result_$Char(Byte)
		
		; Convert lower byte to ascii
		set Byte = $ZHex($Extract(PartHex, 3, 4))
		if Byte = 0 quit
		set Result = Result_$Char(Byte)
	}
	
	return Result
}

}
