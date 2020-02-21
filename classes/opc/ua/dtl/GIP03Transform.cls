Class opc.ua.dtl.GIP03Transform Extends Ens.DataTransformDTL [ DependsOn = (opc.ua.data.GIP03.staging.GIP03CONFIG, opc.ua.data.GIP03.transforming.GIP03CONFIG) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='opc.ua.data.GIP03.staging.GIP03CONFIG' targetClass='opc.ua.data.GIP03.transforming.GIP03CONFIG' create='existing' language='objectscript' >
<annotation>GIP03 transformation</annotation>
<if condition='source.MachineStatus &apos;= source.PreviousReading.MachineStatus' >
<annotation>IF previous sample MachineStatus &lt;&gt; new sample MachineStatus THEN Transfer value previous sample MachineStatus</annotation>
<true>
<assign value='source.MachineStatus' property='target.MachineStatusPreviousStatus' action='set' />
</true>
<false>
<assign value='source.PreviousReading.MachineStatus' property='target.MachineStatusPreviousStatus' action='set' />
</false>
</if>
<if condition='target.NewOrder = 1' >
<true>
<assign value='source.WerkOrder' property='target.WorkOrder' action='set' />
</true>
<false>
<assign value='source.PreviousReading.WerkOrder' property='target.WorkOrder' action='set' />
</false>
</if>
<assign value='source."MT1_1"' property='target."MT1_1"' action='set' />
<assign value='source."MT1_2"' property='target."MT1_2"' action='set' />
<assign value='source.TimeStamp' property='target.TimeStamp' action='set' />
<assign value='##class(opc.ua.util.FunctionSet).ConvertUTCToLocalTimeStamp(source.TimeStamp)' property='target.TimeStampLocal' action='set' />
<assign value='$P(##class(opc.ua.util.FunctionSet).ConvertUTCtoLocal(source.TimeStamp,3), "-",2)' property='target.MonthLocal' action='set' />
<assign value='$P(##class(opc.ua.util.FunctionSet).ConvertUTCtoLocal(source.TimeStamp,3),"-",1)' property='target.YearLocal' action='set' />
<assign value='source.MachineStatus' property='target.MachineStatus' action='set' />
<assign value='source."MT1_3"' property='target."MT1_3"' action='set' />
<assign value='source."MT1_4"' property='target."MT1_4"' action='set' />
<assign value='source."MT1_5"' property='target."MT1_5"' action='set' />
<assign value='source."MT1_6"' property='target."MT1_6"' action='set' />
<assign value='source."MT1_7"' property='target."MT1_7"' action='set' />
<assign value='source."MT4_1"' property='target."MT4_1"' action='set' />
<assign value='source."MT4_2"' property='target."MT4_2"' action='set' />
<assign value='source."MT4_3"' property='target."MT4_3"' action='set' />
<assign value='source."MT4_4"' property='target."MT4_4"' action='set' />
<assign value='source."MT4_5"' property='target."MT4_5"' action='set' />
<assign value='source."MT4_6"' property='target."MT4_6"' action='set' />
<assign value='source."MT4_7"' property='target."MT4_7"' action='set' />
<assign value='##class(opc.ua.util.FunctionSet).ConvertUTCtoLocal(source.TimeStamp,10)' property='target.DayLocal' action='set' />
<assign value='source.PreviousReading.MachineStatus' property='target.MachineStatusPreviousSample' action='set' />
<assign value='$ZTIMEH($P(target.TimeStampLocal," ",2))' property='target.TimeLocal' action='set' />
<assign value='source.Yards' property='target.ProducedQtyEquipment' action='set' />
<trace value='"["_target.PreviousReading.TimeStamp_"] and MachineStatus ["_target.PreviousReading.MachineStatus_"]"' >
<annotation>Read the latest Transforming reading for testing purpose</annotation>
</trace>
</transform>
}

}
