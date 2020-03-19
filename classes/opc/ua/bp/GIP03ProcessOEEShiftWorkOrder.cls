/// 
Class opc.ua.bp.GIP03ProcessOEEShiftWorkOrder Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq' response='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderResp' height='3600' width='2000' >
<context>
<property name='Status' type='%Status' instantiate='0' />
<property name='OEERecord' type='opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER' instantiate='1' />
<property name='NewShift' type='%Boolean' initialexpression='0' instantiate='0' >
<annotation><![CDATA[When 1 we have determined that we have a new shift]]></annotation>
</property>
<property name='NewWorkOrder' type='%Boolean' initialexpression='0' instantiate='0' >
<annotation><![CDATA[When 1 then we determined that we have a new workorder]]></annotation>
</property>
<property name='ShiftOperationID' type='%Integer' instantiate='0' />
</context>
<sequence xend='200' yend='3350' >
<trace name='Start OEE Shift Workorder' value='"Start processing OEE Shift Workorder"' xpos='200' ypos='250' />
<scope name='Shift WorkOrder Scope' xpos='200' ypos='350' xend='200' yend='3250' >
<assign name="ShiftOperationID" property="context.ShiftOperationID " value="request.Data.ShiftOperationID" action="set" xpos='200' ypos='450' />
<assign name="NewWorkOrder" property="context.NewWorkOrder" value="request.TransformData.NewOrder" action="set" xpos='200' ypos='550' />
<rule name='New Shift' rule='opc.ua.rule.ServingBusinessRule'  resultLocation='context.NewShift' ruleContext='context' xpos='200' ypos='650' >
</rule>
<if name='New Shift ?' condition='context.NewShift' xpos='200' ypos='750' xend='200' yend='1100' >
<true>
<trace name='Delete entries New Shift' value='"Delete entries because of new shift"' xpos='470' ypos='900' />
<sql name='Delete available entries' xpos='470' ypos='1000' >
<![CDATA[delete from opc_ua_data_GIP03_serving.GIP03OEESHIFTWORKORDER]]>
</sql>
</true>
<false>
<trace name='No New Shift' value='"No new Shift"' xpos='200' ypos='900' />
</false>
</if>
<if name='Is NewShift or WorkOrder' condition='context.NewShift || context.NewWorkOrder' xpos='200' ypos='1200' xend='200' yend='2450' >
<true>
<trace name='NewShift or NewWorkOrder' value='"NewShift or NewWorkOrder - CREATE"' xpos='470' ypos='1350' />
<assign name="Create new ShiftWorkOrder" property="context.OEERecord" value="##class(opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER).%New()" action="set" xpos='470' ypos='1450' />
<if name='New Shift' condition='context.NewShift' xpos='470' ypos='1550' xend='470' yend='1900' >
<true>
<trace name='New Shift' value='"New Shift Tranformation"' xpos='605' ypos='1700' >
<annotation><![CDATA[Shift Transformation]]></annotation>
</trace>
<transform name='Shift Transformation' class='opc.ua.dtl.ShiftWorkOrderDataNewShift' source='request' target='context.OEERecord' xpos='605' ypos='1800' />
</true>
</if>
<if name='New Work Order ?' condition='context.NewWorkOrder' xpos='470' ypos='2000' xend='470' yend='2350' >
<true>
<trace name='New Work Order' value='"New WorkOrder Transformation"' xpos='605' ypos='2150' >
<annotation><![CDATA[WorkOrder Transformtion]]></annotation>
</trace>
<transform name='WorkOrder Transformation' class='opc.ua.dtl.ShiftWorkOrderDataNewOrder' source='request' target='context.OEERecord' xpos='605' ypos='2250' />
</true>
</if>
</true>
<false>
<trace name='No NewShift or WorkOrder' value='"No NewShift or WorkOrder - UPDATE"' xpos='200' ypos='1350' />
<assign name="Get Latest" property="context.OEERecord" value="##class(opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER).GetLastReading()" action="set" xpos='200' ypos='1450' />
</false>
</if>
<if name='Record Available?' condition='context.OEERecord&apos;=""' xpos='200' ypos='2550' xend='200' yend='3000' >
<true>
<trace name='OEE Record Available' value='"OEE Record available"' xpos='470' ypos='2700' />
<transform name='Transform OEE Shift WorkOrder' class='opc.ua.dtl.ShiftTimeSlideDataToShiftWorkOrderData' source='request' target='context.OEERecord' xpos='470' ypos='2800' >
<annotation><![CDATA[Update / Calc transformation]]></annotation>
</transform>
<assign name="Save OEE Shift WorkOrder" property="context.Status" value="context.OEERecord.%Save()" action="set" xpos='470' ypos='2900' />
</true>
<false>
<trace name='No OEE Record' value='"No OEE record found!"' xpos='200' ypos='2700' />
</false>
</if>
<faulthandlers>
<catchall xpos='200' ypos='3100' xend='200' yend='350' >
<alert name='Error' value='"%LastError "_$System.Status.GetErrorCodes(..%Context.%LastError)_" : "_$System.Status.GetOneStatusText(..%Context.%LastError)' xpos='200' ypos='250' />
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
