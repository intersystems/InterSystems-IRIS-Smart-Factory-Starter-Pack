Include Ensemble

/// This class contains a set of utility methods that can be used for metrics calculations 
/// by Business Rules, DTL transforms and the like.
Class opc.ua.util.FunctionSet Extends Ens.Rule.FunctionSet [ Abstract, DependsOn = (opc.ua.config.Shift, opc.ua.config.Equipment, opc.ua.config.OEEBenchMark) ]
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
	return $JUSTIFY($System.SQL.DATEDIFF(pOutputFormat, pTimeStamp1, pTimeStamp2),1,0)
}

/// Retrieve the persistent object identifier as bigint
ClassMethod GetPersistentId(pObj As %Persistent) As %BigInt [ Final ]
{
	return pObj.%Id()
}

/// Get Equipment name
ClassMethod GetEquipmentName(pEquipmentId As %BigInt) As %String [ Final ]
{
	&sql(SELECT Name INTO :tName FROM opc_ua_config.Equipment WHERE ID = :pEquipmentId)
	if SQLCODE = 0 {
		$$$TRACE("Found Equipment")
		return tName
	}
	
	return ""
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

ClassMethod GetShiftDescription(ShiftIdentifier As %BigInt) As %String [ Final ]
{
	&sql(SELECT Description INTO :tDescription FROM opc_ua_config.Shift WHERE ID = :ShiftIdentifier)
	if SQLCODE = 0 {
		$$$TRACE("Found shift description")
		return tDescription
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

ClassMethod GetCurrentShiftId(pUTCTimeStamp As %TimeStamp, pConvertToLocalTimeStamp As %Boolean) As %BigInt [ Final ]
{
	
	set tTimeStamp = pUTCTimeStamp
	
	/// Convert to local timestamp if necessary
	if pConvertToLocalTimeStamp {
		$$$TRACE("Convert to local time")
		set tTimeStamp = ##class(opc.ua.util.FunctionSet).ConvertUTCToLocalTimeStamp(pUTCTimeStamp)
	} 
	
	/// Get Time in seconds
	set tTime = $PIECE($ZDATETIMEH(tTimeStamp,3, 1),",",2)
		
	/// Get DayOfWeek
	set tDayOfWeek =  $SYSTEM.SQL.DAYOFWEEK(tTimeStamp)
	set tNextDayOfWeek = tDayOfWeek + 1
	if (tNextDayOfWeek > 7) { 
		set tNextDayOfWeek = 1
	}
		
	$$$TRACE("Day of week ["_tDayOfWeek_"]")
	$$$TRACE("Next day of week ["_tNextDayOfWeek_"]")	
	
	/// &sql(SELECT ID INTO :id from opc_ua_config.Shift 
	///     WHERE ((StartDayOfWeek = :tDayOfWeek and EndDayOfWeek = :tDayOfWeek) 
	///     OR (StartDayOfWeek = :tDayOfWeek and EndDayOfWeek = :tNextDayOfWeek))
	///     AND StartTime <= current_time AND EndTime >= current_time
	///     AND ValidFrom <= current_date AND ValidTo >= current_date)
	&sql(SELECT ID INTO :id FROM opc_ua_config.Shift
	     WHERE ((StartDayOfWeek = :tDayOfWeek AND EndDayOfWeek = :tDayOfWeek 
	            AND StartTime <= :tTime AND EndTime >= :tTime)
	        OR (StartDayOfWeek = :tDayOfWeek AND EndDayOfWeek = :tNextDayOfWeek
	            AND StartTime <= :tTime AND :tTime BETWEEN CAST('22:00:00' AS TIME) AND CAST('23:59:59' AS TIME))
	        OR (StartDayOfWeek = :tDayOfWeek AND EndDayOfWeek = :tNextDayOfWeek
	            AND EndTime >= :tTime AND :tTime BETWEEN CAST('00:00:00' AS TIME) AND CAST('05:59:59' AS TIME)))
	        AND (ValidFrom <= current_date AND ValidTo >= current_date))            
	IF SQLCODE=0 {
		$$$TRACE("Found shift "_id)
	}
	
	return id
}

/// Retrieve OEEBenchMark OCAP color 
/// Object - Benchmark Object name to search for
/// OCAPVal - Determine the OCAP color on the specified value
ClassMethod GetOEEBenchMarkOCAPColor(Object As %String, OCAPVal As %Float) As %String [ Final ]
{
	&sql(SELECT OCAP01, OCAP01Col, OCAP02, OCAP02Col, OCAP03, OCAP03Col, OCAP04, OCAP04Col, OCAP05, OCAP05Col, Search
		 INTO :tOCAP01, :tOCAP01Col, :tOCAP02, :tOCAP02Col, :tOCAP03, :tOCAP03Col, :tOCAP04, :tOCAP04Col, :tOCAP05, :tOCAP05Col, :Search
		 FROM opc_ua_config.OEEBenchMark 
	     WHERE Object = :Object)
	If SQLCODE Quit ""
	
	If Search = "ASC" {
		IF (tOCAP01="") || (OCAPVal <= tOCAP01) {
			return tOCAP01Col
		} ELSEIF (tOCAP02="") || (OCAPVal <= tOCAP02) {
			return tOCAP02Col
		} ELSEIF (tOCAP03="") || (OCAPVal <= tOCAP03) {
			return tOCAP03Col
		} ELSEIF (tOCAP04="") || (OCAPVal <= tOCAP04) {
			return tOCAP04Col
		} ELSEIF (tOCAP05="") || (OCAPVal <= tOCAP05) {
			return tOCAP05Col
		}	
		return ""
	}
	
	; Descending
	If (tOCAP01 = "") || (OCAPVal >= tOCAP01) Return tOCAP01Col
	If (tOCAP02 = "") || (OCAPVal >= tOCAP02) Return tOCAP02Col
	If (tOCAP03 = "") || (OCAPVal >= tOCAP03) Return tOCAP03Col
	If (tOCAP04 = "") || (OCAPVal >= tOCAP04) Return tOCAP04Col
	If (tOCAP05 = "") || (OCAPVal >= tOCAP05) Return tOCAP05Col
	
	return ""
}

/// Retrieve OEEBenchMark History
ClassMethod GetOEEBenchMarkHistory(Object As %String) As %Float [ Final ]
{
	&sql(SELECT History INTO :val from opc_ua_config.OEEBenchMark 
	     WHERE Object = :Object)
	IF SQLCODE=0 {
		return val
	}
	
	return 0
}

/// Retrieve OEEBenchMark Target
ClassMethod GetOEEBenchMarkTarget(Object As %String) As %Float [ Final ]
{
	&sql(SELECT Target INTO :val from opc_ua_config.OEEBenchMark 
	     WHERE Object = :Object)
	IF SQLCODE=0 {
		return val
	}
	
	return 0
}

/// Return the sum value for the given attribute
/// Return the count value for the given attribute
ClassMethod Sum(ClassName As %String, Attribute As %String) As %Float [ Final ]
{
	return $CLASSMETHOD(ClassName,"Sum",Attribute)
}

// for OEE Performance calculations

/// Specific sum function that can only performed on the ...OEEShiftWorkOrder tabels
/// [ ( OEEActualOutput 1 * OEEStandardCycleTime 1 ) 
///     + ( OEEActualOutput 2 * OEEStandardCycleTime 2 )
///     + ....… 
///     + ( OEEActualOutput n * OEEStandardCycleTime n ) ]  
ClassMethod SumOEEPerformance(ClassName As %String) As %Float [ Final ]
{
	return $CLASSMETHOD(ClassName,"SumOEEPerformance")
}

/// Specific sum function that can only performed on the ...OEEShiftWorkOrder tabels 
/// for QEE Quality calculations
/// [ ( (OEEActualOutput 1 -/- OEERejected Output 1 )  *  
///               OEEStandardCycleTime 1 ) 
///    + ( (OEEActualOutput 2 -/- OEERejected Output 2 )  *
///             OEEStandardCycleTime 2 )
///   + … 
///    + ( (OEEActualOutput n -/- OEERejected Output n )  *
///             OEEStandardCycleTime n)  ] 
ClassMethod SumOEEQuality(ClassName As %String) As %Float [ Final ]
{
	return $CLASSMETHOD(ClassName, "SumOEEQuality")
}

/// Return the count value for the given attribute
ClassMethod CountDistinct(ClassName, Attribute As %String) As %Float [ Final ]
{
	return $CLASSMETHOD(ClassName, "CountDistinct", Attribute)
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

/// Get the current shift identifier. Shift times can be added in local time format. When this is True put 
/// pConvertToLocalTimestamp to 1

}
