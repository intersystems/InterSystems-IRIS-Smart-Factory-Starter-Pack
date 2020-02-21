Include Ensemble

/// This class contains a set of utility methods that can be used for metrics calculations 
/// by Business Rules, DTL transforms and the like.
Class opc.ua.util.FunctionSet Extends Ens.Rule.FunctionSet [ Abstract, ClassType = "", ProcedureBlock, System = 4 ]
{

/* NOTE: the names of these function arguments are used by
the expression editor. DO NOT MODIFY THEM!
*/
/// Convert UTC time to LocalTime
ClassMethod ConvertUTCToLocalTimeStamp(value As %TimeStamp) As %TimeStamp [ Final ]
{
	return $ZDATETIME($ZDATETIMEH($ZDATETIMEH(value,3),-3),3,1,2)
}

/// Takes string <var>value</var> representing a date/time value in format <var>timestamp</var> and converts it to
/// a date string in format dformat <var>outformat</var> in the local timezone. 
ClassMethod ConvertUTCtoLocal(value As %TimeStamp, outformat As %Integer) As %Integer [ Final ]
{
	return $ZDATE($ZDATETIMEH($ZDATETIMEH(value,3),-3), outformat)
}

/// Retrieve the persistent object identifier as bigint
ClassMethod GetPersistentId(obj As %Persistent) As %BigInt [ Final ]
{
	return obj.%Id()
}

}
