/// Shift configuration table
Class opc.ua.config.Shift Extends %Persistent
{

/// Name of the shift
Property Name As %String(MAXLEN = 100) [ Required ];

/// Description 
Property Description As %String(MAXLEN = 1000);

/// Shift valid from
Property ValidFrom As %Date [ InitialExpression = {$NOW(0)}, Required ];

/// Shift valid to
Property ValidTo As %Date;

/// Start day of week of the shift
Property StartDayOfWeek As %Integer(DISPLAYLIST = ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", VALUELIST = ",1,2,3,4,5,6,7");

/// Start time of the shift
Property StartTime As %Time;

/// End day of week of the shift 
Property EndDayOfWeek As %Integer(DISPLAYLIST = ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", VALUELIST = ",1,2,3,4,5,6,7");

/// End time of the shift 
Property EndTime As %Time;

/// Shift number
Property ShiftNumber As %Integer;

/// Shift is still in use as a valid defintion
Property Active As %Boolean [ InitialExpression = 1 ];

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
