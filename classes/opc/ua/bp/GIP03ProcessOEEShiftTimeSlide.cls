/// 
Class opc.ua.bp.GIP03ProcessOEEShiftTimeSlide Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.bp.GIP03ProcessOEEShiftTimeSlide.GIP03ProcessOEEShiftTimeSlideReq' response='opc.ua.bp.GIP03ProcessOEEShiftTimeSlide.GIP03ProcessOEEShiftTimeSlideResp' height='2000' width='2000' >
<context>
<property name='OEERecord' type='opc.ua.data.GIP03.serving.GIP03OEESHIFTTIMESLIDE' instantiate='1' />
<property name='Status' type='%Status' instantiate='0' />
<property name='NewShift' type='%Boolean' instantiate='0' />
<property name='ShiftOperationID' type='%Integer' instantiate='0' />
</context>
<sequence xend='200' yend='1650' >
<trace name='Start OEE Shift TimeSlide' value='"Start processing OEE Shift TimeSlide"' xpos='200' ypos='250' />
<scope xpos='200' ypos='350' xend='200' yend='1550' >
<assign name="ShiftOperation" property="context.ShiftOperationID" value="request.Data.ShiftOperationID" action="set" xpos='200' ypos='450' />
<rule name='NewShift' rule='opc.ua.rule.ServingBusinessRule'  resultLocation='context.NewShift' ruleContext='context' xpos='200' ypos='550' >
</rule>
<if name='New Shift' condition='context.NewShift' xpos='200' ypos='650' xend='200' yend='1000' >
<true>
<trace name='Delete entries' value='"Delete entries because of new shift"' xpos='335' ypos='800' />
<sql name='Delete entries' xpos='335' ypos='900' >
<![CDATA[delete from opc_ua_data_GIP03_serving.GIP03OEESHIFTTIMESLIDE]]>
</sql>
</true>
</if>
<transform name='Transform OEE Shift TimeSlide' class='opc.ua.dtl.GIP03OEEShiftTimeSlide' source='request.Data' target='context.OEERecord' xpos='200' ypos='1100' />
<assign name="Save OEE Shift TimeSlide" property="context.Status" value="context.OEERecord.%Save()" action="set" xpos='200' ypos='1200' />
<assign name="Set Response" property="response.Data" value="context.OEERecord" action="set" xpos='200' ypos='1300' />
<faulthandlers>
<catchall xpos='200' ypos='1400' xend='200' yend='350' >
<alert name='Error' value='"Error ["_$ZError_"]"' xpos='200' ypos='250' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
