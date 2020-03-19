/// Generated for:
/// - Equipment GIP03 machine (id 1)
/// - Configuration GIP03 OEE shift workorder (id 4)
Class opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER Extends opc.ua.data.Base
{

Parameter XMLNAME = "GIP03.serving.GIP03OEESHIFTWORKORDER";

Parameter XMLTYPE = "GIP03.serving.GIP03OEESHIFTWORKORDER";

Property ActualSpeedTotalProduction As %Integer;

Property AverageSpeedPerformance As %Integer;

Property ChangeOverTime As %Integer;

Property ChangeOverTotalTime As %Integer;

Property Continuity As %Integer;

Property DayLocal As %Integer;

Property EquipmentID As %Integer;

Property ForeRunnerTime As %Integer;

Property LineUpQty As %Integer;

Property LineUpTime As %Integer;

Property MachineStatus As %Integer;

Property MachineStatusPreviousStatus As %Integer;

Property MisPasQty As %Integer;

Property MonthLocal As %Integer;

Property NoChangeOverStops As %Integer;

Property NoOfChangeOvers As %Integer;

Property NoOfLongStops As %Integer;

Property NoOfShortStops As %Integer;

Property OEEActualOutput As %Integer;

Property OEEActualProductionTime As %Integer;

Property OEEFailureTime As %Integer;

Property OEENotScheduledOperatingTime As %Integer;

Property OEEPotentialProductionTime As %Integer;

Property OEERejectedOutput As %Integer;

Property OEERework As %Integer;

Property OEEScrap As %Integer;

Property OEEStandardCycleTime As %Integer;

Property OEEUnScheduledDownTime As %Integer;

Property OEEUnScheduledIdleTime As %Integer;

Property OEEWaitingTime As %Integer;

Property OOELineRestraintTime As %Integer;

Property OutOfOrderTime As %Integer;

Property PreviousReading As opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER [ Transient ];

Property ProducedQtyOrder As %Integer;

Property ProductionQty As %Integer;

Property ProductionTime As %Integer;

Property Recipe As %String;

Property RecipeSpeed As %Integer;

Property "Sequence/Step" As %Integer;

Property ShiftID As %Integer;

Property ShiftOperationID As %Integer;

Property StandByChangeOverTime As %Integer;

Property StandByLongStopTime As %Integer;

Property StandByShortStopDuration As %Integer;

Property StandByShortStopTime As %Integer;

Property StandByType As %String;

/// Added Extra not in configuration
Property StartDateOrderShift As %Date;

Property StartTimeOrderShift As %Time;

Property StopTime As %Integer;

Property TimeStampLocal As %TimeStamp;

Property UoM As %String;

Property Week As %Integer;

Property WorkOrder As %String;

Property YearLocal As %Integer;

Storage Default
{
<Data name="GIP03OEESHIFTWORKORDERDefaultData">
<Subscript>"GIP03OEESHIFTWORKORDER"</Subscript>
<Value name="1">
<Value>ActualSpeedTotalProduction</Value>
</Value>
<Value name="2">
<Value>AverageSpeedPerformance</Value>
</Value>
<Value name="3">
<Value>ChangeOverTime</Value>
</Value>
<Value name="4">
<Value>ChangeOverTotalTime</Value>
</Value>
<Value name="5">
<Value>Continuity</Value>
</Value>
<Value name="6">
<Value>DayLocal</Value>
</Value>
<Value name="7">
<Value>EquipmentID</Value>
</Value>
<Value name="8">
<Value>ForeRunnerTime</Value>
</Value>
<Value name="9">
<Value>LineUpQty</Value>
</Value>
<Value name="10">
<Value>LineUpTime</Value>
</Value>
<Value name="11">
<Value>MachineStatus</Value>
</Value>
<Value name="12">
<Value>MachineStatusPreviousStatus</Value>
</Value>
<Value name="13">
<Value>MisPasQty</Value>
</Value>
<Value name="14">
<Value>MonthLocal</Value>
</Value>
<Value name="15">
<Value>NoChangeOverStops</Value>
</Value>
<Value name="16">
<Value>NoOfChangeOvers</Value>
</Value>
<Value name="17">
<Value>NoOfLongStops</Value>
</Value>
<Value name="18">
<Value>NoOfShortStops</Value>
</Value>
<Value name="19">
<Value>OEEActualOutput</Value>
</Value>
<Value name="20">
<Value>OEEActualProductionTime</Value>
</Value>
<Value name="21">
<Value>OEEFailureTime</Value>
</Value>
<Value name="22">
<Value>OEENotScheduledOperatingTime</Value>
</Value>
<Value name="23">
<Value>OEEPotentialProductionTime</Value>
</Value>
<Value name="24">
<Value>OEERejectedOutput</Value>
</Value>
<Value name="25">
<Value>OEERework</Value>
</Value>
<Value name="26">
<Value>OEEScrap</Value>
</Value>
<Value name="27">
<Value>OEEStandardCycleTime</Value>
</Value>
<Value name="28">
<Value>OEEUnScheduledDownTime</Value>
</Value>
<Value name="29">
<Value>OEEUnScheduledIdleTime</Value>
</Value>
<Value name="30">
<Value>OEEWaitingTime</Value>
</Value>
<Value name="31">
<Value>OOELineRestraintTime</Value>
</Value>
<Value name="32">
<Value>OutOfOrderTime</Value>
</Value>
<Value name="33">
<Value>ProducedQtyOrder</Value>
</Value>
<Value name="34">
<Value>ProductionQty</Value>
</Value>
<Value name="35">
<Value>ProductionTime</Value>
</Value>
<Value name="36">
<Value>Recipe</Value>
</Value>
<Value name="37">
<Value>RecipeSpeed</Value>
</Value>
<Value name="38">
<Value>Sequence/Step</Value>
</Value>
<Value name="39">
<Value>ShiftID</Value>
</Value>
<Value name="40">
<Value>ShiftOperationID</Value>
</Value>
<Value name="41">
<Value>StandByChangeOverTime</Value>
</Value>
<Value name="42">
<Value>StandByLongStopTime</Value>
</Value>
<Value name="43">
<Value>StandByShortStopDuration</Value>
</Value>
<Value name="44">
<Value>StandByShortStopTime</Value>
</Value>
<Value name="45">
<Value>StandByType</Value>
</Value>
<Value name="46">
<Value>StartTimeOrderShift</Value>
</Value>
<Value name="47">
<Value>StopTime</Value>
</Value>
<Value name="48">
<Value>TimeStampLocal</Value>
</Value>
<Value name="49">
<Value>UoM</Value>
</Value>
<Value name="50">
<Value>Week</Value>
</Value>
<Value name="51">
<Value>WorkOrder</Value>
</Value>
<Value name="52">
<Value>YearLocal</Value>
</Value>
<Value name="53">
<Value>StartDateOrderShift</Value>
</Value>
</Data>
<DefaultData>GIP03OEESHIFTWORKORDERDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
