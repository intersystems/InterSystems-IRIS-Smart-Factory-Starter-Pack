/// OEE BenchMark 
Class opc.ua.config.OEEBenchMark Extends (%Persistent, %JSON.Adaptor)
{

/// Equimpment identifier
Property EquipmentID As %Integer(%JSONFIELDNAME = "equipment_id");

/// BenchMark name
Property Object As %String(%JSONFIELDNAME = "object");

/// Search
Property Search As %String(%JSONFIELDNAME = "search", DISPLAYLIST = ",Ascending,Descending", VALUELIST = ",ASC,DSC");

/// Target
Property Target As %Float(%JSONFIELDNAME = "target");

/// History
Property History As %Float(%JSONFIELDNAME = "history");

/// OCAP01 Value
Property OCAP01 As %Float(%JSONFIELDNAME = "ocap_01");

/// OCAP01 Color
Property OCAP01Col As %String(%JSONFIELDNAME = "ocap_01_col");

/// OCAP02 Value
Property OCAP02 As %Float(%JSONFIELDNAME = "ocap_02");

/// OCAP02 Color
Property OCAP02Col As %String(%JSONFIELDNAME = "ocap_02_col");

/// OCAP03 Value
Property OCAP03 As %Float(%JSONFIELDNAME = "ocap_03");

/// OCAP03 Color
Property OCAP03Col As %String(%JSONFIELDNAME = "ocap_03_col");

/// OCAP04 Value
Property OCAP04 As %Float(%JSONFIELDNAME = "ocap_04");

/// OCAP04 Color
Property OCAP04Col As %String(%JSONFIELDNAME = "ocap_04_col");

/// OCAP05 Value
Property OCAP05 As %Float(%JSONFIELDNAME = "ocap_05");

/// OCAP05 Color
Property OCAP05Col As %String(%JSONFIELDNAME = "ocap_05_col");

ClassMethod GetOEEBenchMarkList() As %ListOfObjects
{
	set tOEEBenchMarkList = ##class(%ListOfObjects).%New()
	
	set tQuery = "SELECT ID FROM opc_ua_config.OEEBenchMark"
	set tResultSet = ##class(%SQL.Statement).%ExecDirect(,tQuery)
	if tResultSet.%SQLCODE'=0 $$$ThrowSQLCODE(tResultSet.%SQLCODE,tResultSet.%Message)
	
	while tResultSet.%Next() {
		set tItem = ##class(opc.ua.config.OEEBenchMark).%OpenId(tResultSet.%GetData(1))
		do tOEEBenchMarkList.Insert(tItem)
	}
	return tOEEBenchMarkList
}

Storage Default
{
<Data name="OEEBenchMarkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquipmentID</Value>
</Value>
<Value name="3">
<Value>Object</Value>
</Value>
<Value name="4">
<Value>Search</Value>
</Value>
<Value name="5">
<Value>Target</Value>
</Value>
<Value name="6">
<Value>History</Value>
</Value>
<Value name="7">
<Value>OCAP01</Value>
</Value>
<Value name="8">
<Value>OCAP01Col</Value>
</Value>
<Value name="9">
<Value>OCAP02</Value>
</Value>
<Value name="10">
<Value>OCAP02Col</Value>
</Value>
<Value name="11">
<Value>OCAP03</Value>
</Value>
<Value name="12">
<Value>OCAP03Col</Value>
</Value>
<Value name="13">
<Value>OCAP04</Value>
</Value>
<Value name="14">
<Value>OCAP04Col</Value>
</Value>
<Value name="15">
<Value>OCAP05</Value>
</Value>
<Value name="16">
<Value>OCAP05Col</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.OEEBenchMarkD</DataLocation>
<DefaultData>OEEBenchMarkDefaultData</DefaultData>
<IdLocation>^opc.ua.config.OEEBenchMarkD</IdLocation>
<IndexLocation>^opc.ua.config.OEEBenchMarkI</IndexLocation>
<StreamLocation>^opc.ua.config.OEEBenchMarkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
