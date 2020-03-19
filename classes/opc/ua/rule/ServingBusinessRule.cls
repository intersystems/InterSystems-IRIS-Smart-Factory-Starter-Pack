/// 
Class opc.ua.rule.ServingBusinessRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="Serving Business Rules" effectiveBegin="" effectiveEnd="">
<trace value="&quot;Serving Business Rule&quot;"></trace>
<rule name="New Shift" disabled="false">
<when condition="OEERecord.PreviousReading.ShiftOperationID!=ShiftOperationID">
<trace value="&quot;New Shift&quot;"></trace>
<return>1</return>
</when>
<otherwise>
<return>0</return>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
