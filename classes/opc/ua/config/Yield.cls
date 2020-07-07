/// Yield configuration for the machine
Class opc.ua.config.Yield Extends (%Persistent, %JSON.Adaptor)
{

/// Name of the Yield
Property Name As %String(%JSONFIELDNAME = "name") [ Required ];

/// Value of the Yield.
/// Value is stored as a String be aware that this field needs to be converted to the correct data type
Property Value As %String(%JSONFIELDNAME = "value");

Index YieldNameIndex On Name [ Unique ];

/// Get all yields
ClassMethod GetAllYields() As %ListOfObjects
{
	set tYieldsList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT ID INTO :tYieldId FROM opc_ua_config.Yield)	       
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tYieldsList
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tYield = ##class(opc.ua.config.Yield).%OpenId(tYieldId,,.tSc)    	
    	if ('$$$ISERR(tSc)) {
    		Do tYieldsList.Insert(tYield)    		
    	}
    &sql(FETCH C1)
    }
	&sql(CLOSE C1)
		
	return tYieldsList
}

/// Get the yield by specifying the name
ClassMethod SearchByName(pName As %String, Output Status As %Status) As opc.ua.config.Yield
{
	set tYield = ""
	&sql(SELECT ID INTO :tId FROM opc_ua_config.Yield WHERE name=:pName)
	if (SQLCODE = 0) {
		set tYield =  ##class(opc.ua.config.Yield).%OpenId(tId, , .Status)
		if $$$ISERR(Status) return ""		
	}
	
	return tYield
}

Storage Default
{
<Data name="YieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.YieldD</DataLocation>
<DefaultData>YieldDefaultData</DefaultData>
<IdLocation>^opc.ua.config.YieldD</IdLocation>
<IndexLocation>^opc.ua.config.YieldI</IndexLocation>
<StreamLocation>^opc.ua.config.YieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
