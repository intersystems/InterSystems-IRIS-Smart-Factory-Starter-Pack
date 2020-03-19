Class opc.ua.dtl.GIP03OEEShiftTimeSlide Extends Ens.DataTransformDTL [ DependsOn = (opc.ua.data.GIP03.transforming.GIP03CONFIG, opc.ua.data.GIP03.serving.GIP03OEESHIFTTIMESLIDE) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='opc.ua.data.GIP03.transforming.GIP03CONFIG' targetClass='opc.ua.data.GIP03.serving.GIP03OEESHIFTTIMESLIDE' create='new' language='objectscript' >
<assign value='source.EquipmentID' property='target.EquipmentID' action='set' />
<assign value='source.ShiftOperationID' property='target.ShiftOperationID' action='set' />
<assign value='source.TimeStampLocal' property='target.TimeStampLocal' action='set' />
<assign value='source.YearLocal' property='target.YearLocal' action='set' />
<assign value='source.MonthLocal' property='target.MonthLocal' action='set' />
<assign value='source.DayLocal' property='target.DayLocal' action='set' />
<assign value='source.TimeLocal' property='target.TimeLocal' action='set' />
<assign value='source.WorkOrder' property='target.WorkOrder' action='set' />
<assign value='source.ProducedQtyOrder' property='target.ProducedQtyOrder' action='set' />
<assign value='source.UoM' property='target.UoM' action='set' />
<assign value='source.Recipe' property='target.Recipe' action='set' />
<assign value='source.RecipeSpeed' property='target.RecipeSpeed' action='set' />
<assign value='source.MachineStatus' property='target.MachineStatus' action='set' />
<assign value='source.ActualSpeedTotalProduction' property='target.ActualSpeedTotalProduction' action='set' />
<assign value='source.TimeStamp' property='target.TimeStamp' action='set' />
</transform>
}

}
