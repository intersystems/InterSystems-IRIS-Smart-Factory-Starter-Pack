/// Rules for the GIP03 machine
Class opc.ua.rule.GIP03Rule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="GIP03 Rule" effectiveBegin="" effectiveEnd="">
<rule name="Unit of Measurement" disabled="false">
<when condition="Equipment != &quot;&quot;">
<assign property="NewTransformingRecord.UoM" value="Equipment.UoM"></assign>
</when>
</rule>
<rule name="Equipment identifier" disabled="false">
<when condition="Equipment!=&quot;&quot;">
<assign property="NewTransformingRecord.EquipmentID" value="GetPersistentId(Equipment)"></assign>
</when>
</rule>
<rule name="NewWorkOrder" disabled="false">
<when condition="(Readings.PreviousReading.WerkOrder!=Readings.WerkOrder)&amp;&amp;((Readings.MachineStatus = 8) || (Readings.MachineStatus = 9) || (Readings.MachineStatus = 10) || (Readings.MachineStatus = 11))">
<assign property="NewTransformingRecord.NewOrder" value="1"></assign>
</when>
<otherwise>
<assign property="NewTransformingRecord.NewOrder" value="0"></assign>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
