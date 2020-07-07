Class opc.ua.Production Extends Ens.Production
{

Parameter SETTINGS = "FirstDayOfWeek:Basic:";

/// Warning: Changing this value will impact the whole instance. 
/// The returned values represent these days: 1 - Sunday, 2 - Monday, 3 - Tuesday, 4 - Wednesday, 5 - Thursday, 6 - Friday, 7 - Saturday
/// The default is that Sunday is the first day of the week.
/// This default can be overridden by specifying SET ^%SYS("sql","sys","day of week")=n, where n values are 1=Monday through 7=Sunday.
/// Thus, to reset the default specify SET ^%SYS("sql","sys","day of week")=7. 
Property FirstDayOfWeek As %Integer(DISPLAYLIST = ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", VALUELIST = ",1,2,3,4,5,6,7") [ InitialExpression = {$get(^%SYS("sql","sys","day of week",$namespace),$get(^%SYS("sql","sys","day of week"),1))} ];

/// Register callout lib 
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
	/// Initialize Python integratie
	set sc = ##class(isc.py.Callout).Setup()
	if $$$ISERR(sc) return sc
	
	/// Set First day of week
	set sc = ##class(opc.ua.Production).SetFirstDayOfWeek()
	return sc
}

/// Set the first day of the week
ClassMethod SetFirstDayOfWeek() As %Status
{

	set tFirstDayOfWeek = ##class(Ens.Production).GetSettingValue("FirstDayOfWeek", .sc)
	if $$$ISERR(sc) return sc
	
	if tFirstDayOfWeek '= "" {
		$$$LOGINFO("Setting first day of week to for the namespace ["_tFirstDayOfWeek_"]")
		set ^%SYS("sql","sys","day of week", $namespace)=tFirstDayOfWeek
	}
	
	return $$$OK
}

/// This method is called when config changes to the Production or any item are saved from the portal
ClassMethod OnConfigChange(pProduction As Ens.Config.Production, pItem As Ens.Config.Item)
{
	/// Set First day of week
	set sc = ##class(opc.ua.Production).SetFirstDayOfWeek()	
	return sc
}

XData ProductionDefinition
{
<Production Name="opc.ua.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
</Production>
}

}
