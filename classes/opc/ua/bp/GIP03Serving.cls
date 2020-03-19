/// Serving layer for the GIP03 machine
Class opc.ua.bp.GIP03Serving Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.bp.GIP03Serving.GIP03ServingReq' response='opc.ua.bp.GIP03Serving.GIP03ServingResp' height='2000' width='2000' >
<context>
<property name='DataOutOEEShiftTimeSlide' type='opc.ua.data.Base' instantiate='0' />
<property name='DataOutOEEShiftWorkOrder' type='opc.ua.data.Base' instantiate='0' />
<property name='DataOutOEEShift' type='opc.ua.data.Base' instantiate='0' />
<property name='NewOrder' type='%Boolean' initialexpression='0' instantiate='0' />
</context>
<sequence xend='200' yend='650' >
<trace name='Start Serving Layer' value='"GIP03 Serving processing"' xpos='200' ypos='250' />
<call name='OEE Shift TimeSlide' target='GIP03ProcessOEEShiftTimeSlide' async='0' xpos='200' ypos='350' >
<request type='opc.ua.bp.GIP03ProcessOEEShiftTimeSlide.GIP03ProcessOEEShiftTimeSlideReq' >
<assign property="callrequest.Data" value="request.Data" action="set" />
<assign property="callrequest.TransformData" value="request.Data" action="set" />
</request>
<response type='opc.ua.bp.GIP03ProcessOEEShiftTimeSlide.GIP03ProcessOEEShiftTimeSlideResp' >
<assign property="context.DataOutOEEShiftTimeSlide" value="callresponse.Data" action="set" />
</response>
</call>
<call name='OEE Shift WorkOrder' target='GIP03ProcessOEEShiftWorkOrder' async='0' xpos='200' ypos='450' >
<request type='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq' >
<assign property="callrequest.Data" value="context.DataOutOEEShiftTimeSlide" action="set" />
<assign property="callrequest.TransformData" value="request.Data" action="set" />
</request>
<response type='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderResp' >
<assign property="context.DataOutOEEShiftWorkOrder" value="callresponse.Data" action="set" />
</response>
</call>
<call name='OEE Shift' target='GIP03ProcessOEEShift' async='0' xpos='200' ypos='550' >
<request type='opc.ua.bp.GIP03ProcessOEEShift.GIP03ProcessOEEShiftReq' >
<assign property="callrequest.Data" value="context.DataOutOEEShiftWorkOrder" action="set" />
<assign property="callrequest.TransformData" value="request.Data" action="set" />
</request>
<response type='opc.ua.bp.GIP03ProcessOEEShift.GIP03ProcessOEEShiftResp' >
<assign property="context.DataOutOEEShift" value="callresponse.Data" action="set" />
</response>
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
