/// Post processing rule
Class opc.ua.rule.GIP03PostProcessRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="GIP03 Post Processing Rule" effectiveBegin="" effectiveEnd="">
<rule name="MisPasQtyIncrement" disabled="false">
<when condition="(TransformingRecord.ProducedQtyIncrement!=0)&amp;&amp;(IsMisPass(MT44,MisPassYield,MT41)||IsMisPass(MT44,MisPassYield,MT42)||IsMisPass(MT44,MisPassYield,MT43)||IsMisPass(MT44,MisPassYield,MT45)||IsMisPass(MT44,MisPassYield,MT46)||IsMisPass(MT44,MisPassYield,MT47))">
<assign property="TransformingRecord.MisPasQtyIncrement" value="TransformingRecord.ProducedQtyIncrement"></assign>
</when>
<otherwise>
<assign property="TransformingRecord.MisPasQtyIncrement" value="0"></assign>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
