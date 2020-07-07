/// API for requesting Shifts, UoM and OEEBenchmarks<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.masterdata.spec<br/>
/// Updated Jul 6, 2020 18:10:36
Class opc.ua.rest.masterdata.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Returns all shifts
ClassMethod GetShifts() As %DynamicObject
{
	do ..%SetHeader("Content-Type","application/json")
	set $ZTrap = "Error"
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
       
    set tShiftList = ##class(opc.ua.config.Shift).GetShiftList()
	do ##class(opc.ua.util.JSON).ListToJSONStream(tShiftList, .tResponse)    	
    return tResponse
    
Error
	set $ZTrap = ""
	return ##class(opc.ua.rest.Error).GenerateErrorInJSON(500, "Internal server error")
}

/// Get all units of measurement
ClassMethod GetUoM() As %DynamicObject
{
	try {
		do ..%SetHeader("Content-Type","application/json")
		set tResponse = ##class(%Stream.GlobalCharacter).%New()
		
		set tUoMList = ##class(opc.ua.config.UoM).GetUoMList()	
		do ##class(opc.ua.util.JSON).ListToJSONStream(tUoMList, .tResponse) 
		return tResponse
		
	} catch ex {
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(500, "Internal server error")
	}
}

/// Get full name of UoM format<br/>
/// The method arguments hold values for:<br/>
///     format<br/>
ClassMethod GetUoMFormat(format As %String) As %DynamicObject
{
	try {
		do ..%SetHeader("Content-Type","application/json")
		set tResponse = ##class(%Stream.GlobalCharacter).%New()
		
		set tUoMFormat = ##class(opc.ua.config.UoM).GetUoMFormatString(format)
		if tUoMFormat '= "" {
			do tUoMFormat.%JSONExportToStream(.tResponse)
			return tResponse
		} else {
			return ##class(opc.ua.rest.Error).GenerateErrorInJSON(404, "Unknown format: "_format)
		}
		
	} catch ex {
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(500, "Internal server error")
	}
}

/// Get OEE Benchmarks
ClassMethod GetOEEBenchmarks() As %DynamicObject
{
	try {
		do ..%SetHeader("Content-Type","application/json")
		set tResponse = ##class(%Stream.GlobalCharacter).%New()
		
		set tOEEBenchMarkList = ##class(opc.ua.config.OEEBenchMark).GetOEEBenchMarkList()
		do ##class(opc.ua.util.JSON).ListToJSONStream(tOEEBenchMarkList, .tResponse) 	
		return tResponse
		
	} catch ex {
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(500, "Internal server error")
	}
}

}
