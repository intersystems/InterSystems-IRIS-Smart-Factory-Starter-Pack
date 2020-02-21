Class opc.ua.Production Extends Ens.Production
{

/// Register callout lib 
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
	set sc = ##class(isc.py.Callout).Setup()
	quit sc
}

XData ProductionDefinition
{
<Production Name="opc.ua.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="TransformRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">opc.ua.rule.TransformRule</Setting>
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
</Production>
}

}
