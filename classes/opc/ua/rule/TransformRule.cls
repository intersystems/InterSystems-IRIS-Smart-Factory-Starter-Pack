/// 
Class opc.ua.rule.TransformRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="opc.ua.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="">
<constraint name="source" value="GIP03Data"></constraint>
<when condition="1=1">
<send transform="" target="GIP03Transform"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
