/// 
Class opc.ua.rule.ServingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="opc.ua.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Rules for Start Serving">
<constraint name="msgClass" value="opc.ua.bp.GIP03Serving.GIP03ServingReq"></constraint>
<when condition="1">
<send transform="" target="GIP03Serving"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
