/// 
Class opc.ua.dtl.ServingBusinessRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="Serving Business Rules" effectiveBegin="" effectiveEnd="">
<rule name="New WorkOrder determination" disabled="false">
<when condition="NewOrder=1">
<return>1</return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
