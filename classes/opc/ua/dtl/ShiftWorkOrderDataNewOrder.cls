Class opc.ua.dtl.ShiftWorkOrderDataNewOrder Extends Ens.DataTransformDTL [ DependsOn = (opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq, opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq' targetClass='opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER' create='new' language='objectscript' >
<assign value='source.TransformData.EquipmentID' property='target.EquipmentID' action='set' />
<assign value='source.TransformData.ShiftOperationID' property='target.ShiftOperationID' action='set' />
<assign value='source.TransformData.WorkOrder' property='target.WorkOrder' action='set' />
<assign value='source.TransformData.UoM' property='target.UoM' action='set' />
<assign value='$ZDATEH($PIECE(source.TransformData.TimeStampLocal, " ", 1)) ' property='target.StartDateOrderShift' action='set' />
<assign value='source.TransformData.TimeLocal' property='target.StartTimeOrderShift' action='set' />
<assign value='source.TransformData.TimeStamp' property='target.TimeStamp' action='set' />
</transform>
}

}
