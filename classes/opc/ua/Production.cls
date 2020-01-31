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
  <Item Name="SubscriptionTestMachine" Category="Subscriptions" ClassName="opc.ua.service.SubscriptionService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">SubscriptionRouter</Setting>
    <Setting Target="Host" Name="Connection">opc.tcp://milo.digitalpetri.com:62541/milo</Setting>
    <Setting Target="Host" Name="Equipment">MiloTestServer</Setting>
    <Setting Target="Host" Name="Configuration">MiloConfig</Setting>
    <Setting Target="Host" Name="PythonTemplatePath">C:\InterSystems\PYTHONCODE\templates\equipment_template.py</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
    <Setting Target="Host" Name="LogFilePath">C:\\InterSystems\\PYTHONCODE\\MiloTestServer.log</Setting>
  </Item>
  <Item Name="SubscriptionRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">opc.ua.rule.SubscriptionRule</Setting>
  </Item>
</Production>
}

}
