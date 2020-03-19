Class opc.ua.dtl.ShiftWorkOrderDataNewShift Extends Ens.DataTransformDTL [ DependsOn = (opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq, opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq' targetClass='opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER' create='existing' language='objectscript' >
<annotation>Transformation for a New Shift in the OEE ShiftWorkOrder </annotation>
<assign value='source.TransformData.EquipmentID' property='target.EquipmentID' action='set' />
<assign value='source.TransformData.ShiftOperationID' property='target.ShiftOperationID' action='set' />
<assign value='source.TransformData.WorkOrder' property='target.WorkOrder' action='set' />
<assign value='$ZDATEH($PIECE(source.TransformData.TimeStampLocal, " ", 1))' property='target.StartDateOrderShift' action='set' />
<assign value='source.TransformData.TimeStamp' property='target.TimeStamp' action='set' />
<assign value='##class(opc.ua.util.FunctionSet).GetStartTimeShift(source.TransformData.ShiftOperationID)' property='target.StartTimeOrderShift' action='set' />
<assign value='##class(opc.ua.util.FunctionSet).GetShiftId(source.TransformData.ShiftOperationID)' property='target.ShiftID' action='set' />
</transform>
}

}
