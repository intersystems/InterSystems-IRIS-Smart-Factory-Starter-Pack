/// 
Class opc.ua.bp.YardsDetermination Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Parameter SETTINGS = "MachineStatusList:Basic";

/// List of 'special' machine statuses
Property MachineStatusList As %String [ InitialExpression = "8,9,10,11,29,31" ];

Storage Default
{
<Data name="YardsDeterminationDefaultData">
<Subscript>"YardsDetermination"</Subscript>
<Value name="1">
<Value>MachineStatusList</Value>
</Value>
</Data>
<DefaultData>YardsDeterminationDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.bp.YardsDetermination.YardsDeterminationRequest' response='opc.ua.bp.YardsDetermination.YardsDeterminationResponse' height='2000' width='2000' >
<context>
<property name='PrevTarget' type='opc.ua.data.GIP03.transforming.GIP03CONFIG' instantiate='0' />
<property name='Target' type='opc.ua.data.GIP03.transforming.GIP03CONFIG' instantiate='0' />
</context>
<sequence xend='200' yend='1600' >
<assign name="Target to context" property="context.Target" value="request.TransformingRecord" action="set" xpos='200' ypos='250' />
<assign name="Previous record to context" property="context.PrevTarget" value="request.TransformingRecord.PreviousReading" action="set" xpos='200' ypos='350' />
<if name='New order?' condition='request.Readings.WerkOrder&apos;=context.PrevTarget.WorkOrder&amp;&amp;$ListFind($ListFromString(process.MachineStatusList),request.Readings.MachineStatus)' xpos='200' ypos='450' xend='200' yend='1400' >
<true>
<assign name="Produced quantity incr" property="context.Target.ProducedQtyIncrement" value="0" action="set" xpos='200' ypos='600' />
<assign name="Produced quantity order" property="context.Target.ProducedQtyOrder" value="0" action="set" xpos='200' ypos='700' />
</true>
<false>
<if name='Prev sample?' condition='$ListFind($ListFromString(process.MachineStatusList),context.PrevTarget.MachineStatus)' xpos='470' ypos='600' xend='470' yend='1300' >
<annotation><![CDATA[Previous Sample Production?]]></annotation>
<true>
<if name='Hiccup?' condition='request.Readings.Yards&lt;context.PrevTarget.ProducedQtyEquipment' xpos='740' ypos='750' xend='740' yend='1100' >
<annotation><![CDATA[Yards counter hiccup?]]></annotation>
<true>
<alert name='Show' value='"Yards counter hiccup!"' xpos='1010' ypos='900' />
<assign name="Guess from average" property="context.Target.ProducedQtyIncrement" value="context.Target.ProducedQtyIncrement=context.PrevTarget.ActualSpeedTotalProduction+request.Readings.ActualSpeedTotalProduction/120*context.Target.DurationIncrement" action="set" xpos='1010' ypos='1000' />
</true>
<false>
<assign name="Produced quantity incr" property="context.Target.ProducedQtyIncrement" value="request.Readings.Yards-context.PrevTarget.ProducedQtyEquipment" action="set" xpos='740' ypos='900' />
</false>
</if>
<assign name="Add to order" property="context.Target.ProducedQtyOrder" value="context.Target.ProducedQtyOrder+context.Target.ProducedQtyIncrement" action="set" xpos='740' ypos='1200' />
</true>
<false>
<assign name="Produced quantity incr" property="context.Target.ProducedQtyIncrement" value="0" action="set" xpos='470' ypos='750' />
<assign name="Produced quantity order" property="context.Target.ProducedQtyOrder" value="context.PrevTarget.ProducedQtyOrder" action="set" xpos='470' ypos='850' />
</false>
</if>
</false>
</if>
<assign name="Save changes" property="status" value="context.Target.%Save()" action="set" xpos='200' ypos='1500' />
</sequence>
</process>
}

}
