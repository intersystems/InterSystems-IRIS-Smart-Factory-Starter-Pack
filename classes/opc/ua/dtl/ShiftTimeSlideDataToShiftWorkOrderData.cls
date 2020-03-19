Class opc.ua.dtl.ShiftTimeSlideDataToShiftWorkOrderData Extends Ens.DataTransformDTL [ DependsOn = (opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq, opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq' targetClass='opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER' create='existing' language='objectscript' >
<assign value='source.TransformData.TimeStampLocal' property='target.TimeStampLocal' action='set' />
<assign value='source.TransformData.ProducedQtyOrder' property='target.ProducedQtyOrder' action='set' />
<assign value='source.TransformData.ActualSpeedTotalProduction' property='target.ActualSpeedTotalProduction' action='set' />
<assign value='source.TransformData.Recipe' property='target.Recipe' action='set' />
<assign value='source.TransformData.RecipeSpeed' property='target.RecipeSpeed' action='set' />
<assign value='source.TransformData.MachineStatus' property='target.MachineStatus' action='set' />
<assign value='source.TransformData.MachineStatusPreviousStatus' property='target.MachineStatusPreviousStatus' action='set' />
<assign value='target.MisPasQty + source.TransformData.MisPasQtyIncrement' property='target.MisPasQty' action='set' />
<if condition='..In(source.TransformData.MachineStatus ,4,5,15)'  expanded='false' >
<true>
<if condition='target.PreviousReading.StandByType = ""' >
<true>
<if condition='&apos;..In(source.TransformData.MachineStatusPreviousSample,8,9,10,11,29,31,15)'  expanded='false' >
<true>
<assign value='"ChangeOver"' property='target.StandByType' action='set' />
</true>
<false>
<assign value='"ShortStop"' property='target.StandByType' action='set' />
</false>
</if>
</true>
<false>
<if condition='((target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement) &gt;= 180) &amp;&amp; (target.PreviousReading.StandByType = "ShortStop")'  expanded='false' >
<true>
<assign value='"LongStop"' property='target.StandByType' action='set' />
</true>
</if>
</false>
</if>
</true>
<false>
<if condition='target.PreviousReading.StandByType &apos;= ""'  expanded='false' >
<true>
<assign value='""' property='target.StandByType' action='set' />
</true>
</if>
</false>
</if>
<if condition='&apos;(..In(source.TransformData.MachineStatus,1,8,9,10,11,29,31,15) &amp;&amp; ..In(target.StandByType,ShortStop,LongStop))'  expanded='false' >
<annotation>{Max value = 1}
IF SOURCE.MachineStatus = NOT ( &lt;OutOfOrder&gt;
          OR &lt;TotalProductionStatus&gt;
          OR &lt;TransProdToStandBy&gt;            
          OR ( StandByType = &quot;ShortStop&quot; OR &quot;LongStop&quot;) 
THEN
      TRANSFER 1
ELSE
      TRANSFER 0.
ENDIF     </annotation>
<true>
<assign value='1' property='target.NoOfChangeOvers' action='set' />
</true>
<false>
<assign value='0' property='target.NoOfChangeOvers' action='set' />
</false>
</if>
<if condition='..In(source.TransformData.MachineStatus,10,11,31)'  expanded='false' >
<true>
<assign value='target.ProductionQty + source.TransformData.ProducedQtyIncrement' property='target.ProductionQty' action='set' />
</true>
</if>
<if condition='..In(source.TransformData.MachineStatus,8,9,29)'  expanded='false' >
<true>
<assign value='target.LineUpQty + source.TransformData.ProducedQtyIncrement' property='target.LineUpQty' action='set' />
</true>
</if>
<if condition='source.TransformData.MachineStatusPreviousSample = 1'  expanded='false' >
<true>
<assign value='target.OutOfOrderTime + source.TransformData.DurationIncrement' property='target.OutOfOrderTime' action='set' />
</true>
</if>
<if condition='..In(source.TransformData.MachineStatus,5,15)'  expanded='false' >
<true>
<if condition='target.PreviousReading.StandByType = "ShortStop"' >
<true>
<if condition='(target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement) &gt;= 180'  expanded='false' >
<true>
<assign value='target.StandByLongStopTime + target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement' property='target.StandByLongStopTime' action='set' />
</true>
<false>
<if condition='target.PreviousReading.StandByType ="LongStop"' >
<true>
<assign value='target.StandByLongStopTime + source.DurationIncrement' property='target.StandByLongStopTime' action='set' />
</true>
</if>
</false>
</if>
</true>
</if>
</true>
<false>
<if condition='target.PreviousReading.StandByType = "ShortStop"'  expanded='false' >
<true>
<if condition='(target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement) &gt;=180' >
<true>
<assign value='target.StandByLongStopTime + target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement' property='target.StandByLongStopTime' action='set' />
</true>
<false>
<if condition='target.PreviousReading.StandByType = "LongStop"' >
<true>
<assign value='StandByLongStopTime + source.TransformData.DurationIncrement' property='target.StandByLongStopTime' action='set' />
</true>
</if>
</false>
</if>
</true>
</if>
</false>
</if>
<if condition='..In(source.TransformData.MachineStatus,5,15)'  expanded='false' >
<true>
<if condition='target.PreviousReading.StandByType = "ShortStop"'  expanded='false' >
<true>
<if condition='(target.PreviousReading.StandByShortDuration + source.TransformData.DurationIncrement) &gt;= 180' >
<true>
<assign value='target.StandByShortStopTime - target.PreviousReading.StandByShortStopDuration' property='target.StandByShortStopTime' action='set' />
</true>
<false>
<assign value='target.StandByShortStopTime + source.TransformData.DurationIncrement' property='target.StandByShortStopTime' action='set' />
</false>
</if>
</true>
</if>
</true>
<false>
<if condition='target.PreviousReading.StandByType = "ShortStop"'  expanded='false' >
<true>
<if condition='(target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement) &gt;= 180' >
<true>
<assign value='target.StandByShortStopTime - target.PreviousReading.StandByShortStopDuration' property='target.StandByShortStopTime' action='set' />
</true>
<false>
<assign value='target.StandByShortStopTime + source.TransformData.DurationIncrement' property='target.StandByShortStopTime' action='set' />
</false>
</if>
</true>
</if>
</false>
</if>
<if condition='..In(source.TransformData.MachineStatus,5,15)'  expanded='false' >
<true>
<if condition='target.PreviousReading.StandByType = "ShortStop"'  expanded='false' >
<true>
<if condition='(target.PreviousReading.StandByShortStopDuration + source.TransformData.DurationIncrement) &gt;= 180'  expanded='false' >
<true>
<assign value='0' property='target.StandByShortStopDuration' action='set' />
</true>
<false>
<assign value='target.StandByShortStopDuration + source.TransformData.DurationIncrement' property='target.StandByShortStopDuration' action='set' />
</false>
</if>
</true>
</if>
</true>
<false>
<if condition='target.PreviousReading.StandByType = "ShortStop"'  expanded='false' >
<true>
<assign value='0' property='target.StandByShortStopDuration' action='set' />
</true>
</if>
</false>
</if>
<if condition='..In(source.TransformData.MachineStatusPreviousSample,10,11)'  expanded='false' >
<annotation>ProductionTime</annotation>
<true>
<assign value='target.ProductionTime + source.TransformData.DurationIncrement' property='target.ProductionTime' action='set' />
</true>
</if>
<if condition='##class(opc.ua.util.FunctionSet).IsShiftActive(source.TransformData.ShiftOperationID)' >
<true>
<assign value='target.OutOfOrderTime' property='target.OEENotScheduledOperatingTime' action='set' />
</true>
</if>
<assign value='target.StandByChangeOverTime' property='target.OOELineRestraintTime' action='set' />
<assign value='target.ChangeOverTime' property='target.OEEWaitingTime' action='set' />
<if condition='##class(opc.ua.util.FunctionSet).IsShiftActive(source.TransformData.ShiftOperationID)' >
<annotation>OEEUnScheduledDownTime</annotation>
<true>
<assign value='target.OutOfOrderTime' property='target.OEEUnScheduledDownTime' action='set' />
</true>
</if>
<assign value='target.MisPasQty' property='target.OEEScrap' action='set' />
<assign value='target.OOEScrap + target.OEERework' property='target.OEERejectedOutput' action='set' />
<assign value='(target.RecipeSpeed * 60) * -1' property='target.OEEStandardCycleTime' action='set' />
<assign value='target.LineUpQty + target.ProductionQty' property='target.OEEActualOutput' action='set' />
<if condition='##class(opc.ua.util.FunctionSet).IsShiftActive(source.TransformData.ShiftOperationID)' >
<true>
<assign value='target.OEEPotentialProductionTime + source.TransformData.DurationIncrement' property='target.OEEPotentialProductionTime' action='set' />
</true>
</if>
<assign value='target.ProductionTime + target.StandByShortStopTime + target.LineUpTime' property='target.OEEActualProductionTime' action='set' />
<assign value='target.OEEActualOuput / target.OEEActualProductionTime' property='target.AverageSpeedPerformance' action='set' />
</transform>
}

}
