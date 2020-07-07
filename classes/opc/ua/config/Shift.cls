/// Shift configuration table
Class opc.ua.config.Shift Extends (%Persistent, %JSON.Adaptor)
{

/// Name of the shift
Property Name As %String(%JSONFIELDNAME = "name", MAXLEN = 100) [ Required ];

/// Description 
Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 1000);

/// Shift valid from
Property ValidFrom As %Date(%JSONFIELDNAME = "valid_from") [ InitialExpression = {$NOW(0)}, Required ];

/// Shift valid to
Property ValidTo As %Date(%JSONFIELDNAME = "valid_to");

/// Start day of week of the shift
Property StartDayOfWeek As %Integer(%JSONFIELDNAME = "start_day_of_week", DISPLAYLIST = ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", VALUELIST = ",1,2,3,4,5,6,7");

/// Start time of the shift
Property StartTime As %Time(%JSONFIELDNAME = "start_time");

/// End day of week of the shift 
Property EndDayOfWeek As %Integer(%JSONFIELDNAME = "end_day_of_week", DISPLAYLIST = ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", VALUELIST = ",1,2,3,4,5,6,7");

/// End time of the shift 
Property EndTime As %Time(%JSONFIELDNAME = "end_time");

/// Shift number
Property ShiftNumber As %Integer(%JSONFIELDNAME = "shift_number");

/// Shift is still in use as a valid defintion
Property Active As %Boolean(%JSONFIELDNAME = "active") [ InitialExpression = 1 ];

ClassMethod GetShiftList() As %ListOfObjects
{
	set tShiftList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT ID INTO :shiftId FROM opc_ua_config.Shift)
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tShiftList
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tShift = ##class(opc.ua.config.Shift).%OpenId(shiftId,,.sc)
    	if ('$$$ISERR(sc)) {
    		Do tShiftList.Insert(tShift)    		
    	}	
    	&sql(FETCH C1)
    }
    &sql(CLOSE C1)
    
    return tShiftList
}

Storage Default
{
<Data name="ShiftDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ValidFrom</Value>
</Value>
<Value name="5">
<Value>ValidTo</Value>
</Value>
<Value name="6">
<Value>StartDayOfWeek</Value>
</Value>
<Value name="7">
<Value>StartTime</Value>
</Value>
<Value name="8">
<Value>EndDayOfWeek</Value>
</Value>
<Value name="9">
<Value>EndTime</Value>
</Value>
<Value name="10">
<Value>ShiftNumber</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.ShiftD</DataLocation>
<DefaultData>ShiftDefaultData</DefaultData>
<IdLocation>^opc.ua.config.ShiftD</IdLocation>
<IndexLocation>^opc.ua.config.ShiftI</IndexLocation>
<StreamLocation>^opc.ua.config.ShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
