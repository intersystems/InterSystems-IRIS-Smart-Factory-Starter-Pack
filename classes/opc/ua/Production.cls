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
  <Item Name="TransformRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">opc.ua.rule.TransformRule</Setting>
    <Setting Target="Host" Name="ResponseFrom">*</Setting>
  </Item>
  <Item Name="GIP03Subscription" Category="Equipment" ClassName="opc.ua.service.SubscriptionService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Connection">opc.tcp://localhost:4980/Softing_dataFEED_OPC_Suite_Configuration1</Setting>
    <Setting Target="Host" Name="Configuration">GIP03CONFIG</Setting>
    <Setting Target="Host" Name="Equipment">GIP03</Setting>
    <Setting Target="Host" Name="LogFilePath">c:\\InterSystems\\LOGS\\GIP03.log</Setting>
    <Setting Target="Host" Name="PythonTemplatePath">c:\InterSystems\PYTHONCODE\templates\equipment_template.py</Setting>
    <Setting Target="Host" Name="TargetConfigNames">TransformRouter</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
    <Setting Target="Host" Name="RESTApplication">http://localhost:52773/api/opc/ua/equipment</Setting>
  </Item>
  <Item Name="GIP03Data" Category="" ClassName="opc.ua.service.DataService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">TransformRouter</Setting>
  </Item>
  <Item Name="GIP03Transform" Category="Transform" ClassName="opc.ua.bp.GIP03Tranform" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="JDE.Service" Category="ERP" ClassName="JDE.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
  </Item>
  <Item Name="JDE.dtl.FilterWorkorder" Category="ERP" ClassName="JDE.dtl.FilterWorkorder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="YardsDetermination" Category="" ClassName="opc.ua.bp.YardsDetermination" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="GIP03Serving" Category="" ClassName="opc.ua.bp.GIP03Serving" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="ServingRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">opc.ua.rule.ServingRule</Setting>
    <Setting Target="Host" Name="ResponseFrom">*</Setting>
    <Setting Target="Host" Name="ResponseTargetConfigNames"></Setting>
  </Item>
  <Item Name="GIP03ProcessOEEShift" Category="" ClassName="opc.ua.bp.GIP03ProcessOEEShift" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="GIP03ProcessOEEShiftTimeSlide" Category="" ClassName="opc.ua.bp.GIP03ProcessOEEShiftTimeSlide" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="GIP03ProcessOEEShiftWorkOrder" Category="" ClassName="opc.ua.bp.GIP03ProcessOEEShiftWorkOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="GIP03ClearContent" Category="" ClassName="opc.ua.bp.GIP03ServingClearContent" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
