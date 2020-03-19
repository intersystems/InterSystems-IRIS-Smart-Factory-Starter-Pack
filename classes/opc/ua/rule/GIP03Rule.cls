/// Rules for the GIP03 machine
Class opc.ua.rule.GIP03Rule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="GIP03 Rule" effectiveBegin="" effectiveEnd="">
<rule name="NewWorkOrder" disabled="false">
<when condition="(TransformingRecord.PreviousReading.WorkOrder!=Readings.WerkOrder)&amp;&amp;((Readings.MachineStatus=8)||(Readings.MachineStatus=9)||(Readings.MachineStatus=10)||(Readings.MachineStatus=11)||(Readings.MachineStatus=29)||(Readings.MachineStatus=31))">
<assign property="TransformingRecord.NewOrder" value="1"></assign>
</when>
<otherwise>
<assign property="TransformingRecord.NewOrder" value="0"></assign>
</otherwise>
</rule>
<rule name="Determine Previous Machine Status" disabled="false">
<when condition="Readings.MachineStatus!=TransformingRecord.PreviousReading.MachineStatus">
<assign property="TransformingRecord.MachineStatusPreviousStatus" value="TransformingRecord.PreviousReading.MachineStatus"></assign>
</when>
<otherwise>
<assign property="TransformingRecord.MachineStatusPreviousStatus" value="TransformingRecord.PreviousReading.MachineStatusPreviousStatus"></assign>
</otherwise>
</rule>
<rule name="Unit of Measurement" disabled="false">
<when condition="Equipment != &quot;&quot;">
<assign property="TransformingRecord.UoM" value="Equipment.UoM"></assign>
</when>
</rule>
<rule name="Equipment identifier" disabled="false">
<when condition="Equipment!=&quot;&quot;">
<assign property="TransformingRecord.EquipmentID" value="GetPersistentId(Equipment)"></assign>
</when>
</rule>
<rule name="Shift" disabled="false">
<when condition="1=1">
<assign property="TransformingRecord.ShiftOperationID" value="GetCurrentShiftId(Readings.TimeStamp,1)"></assign>
</when>
</rule>
<rule name="Recipe Speed" disabled="false">
<when condition="TransformingRecord.NewOrder=1">
<assign property="TransformingRecord.RecipeSpeed" value="Readings.VRecept"></assign>
</when>
<otherwise>
<assign property="TransformingRecord.RecipeSpeed" value="TransformingRecord.PreviousReading.RecipeSpeed"></assign>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
