/// Generated for:
/// - Equipment GIP03 machine (id 1)
/// - Configuration GIP03 OEE shift (id 3)
Class opc.ua.data.GIP03.serving.GIP03OEESHIFT Extends opc.ua.data.Base
{

Parameter XMLNAME = "GIP03.serving.GIP03OEESHIFT";

Parameter XMLTYPE = "GIP03.serving.GIP03OEESHIFT";

Property AverageChangeOverTotalTime As %Integer;

Property AverageChangeOverTotalTimeHistory As %Integer;

Property AverageChangeOverTotalTimeOCAP As %Integer;

Property AverageChangeOverTotalTimeTarget As %Integer;

Property ChangeOverTime As %Integer;

Property ChangeOverTotalTime As %Integer;

Property DayLocal As %Integer;

Property Equipment As %String;

Property EquipmentID As %Integer;

Property ForeRunnerTime As %Integer;

Property LineUpQty As %Integer;

Property LineupTime As %Integer;

Property MachineStatus As %Integer;

Property MisPasPercentage As %Double;

Property MisPasPercentageHistory As %Double;

Property MisPasPercentageOCAP As %Double;

Property MisPasPercentageTarget As %Double;

Property MisPasQty As %Integer;

Property MonthLocal As %Integer;

Property NoChangeOverStops As %Integer;

Property NoOfChangeOvers As %Integer;

Property NoOfLongStops As %Integer;

Property NoOfOrders As %Integer;

Property NoOfShortStops As %Integer;

Property OEEActualProductionTime As %Integer;

Property OEEAvailability As %Double;

Property OEEAvailabilityHistory As %Double;

Property OEEAvailabilityOCAP As %Double;

Property OEEAvailabilityTarget As %Double;

Property OEEFailureTime As %Integer;

Property OEENotScheduledOperatingTime As %Integer;

Property OEEOverall As %Double;

Property OEEOverallHistory As %Double;

Property OEEOverallOCAP As %Double;

Property OEEOverallTarget As %Double;

Property OEEPerformance As %Double;

Property OEEPerformanceHistory As %Double;

Property OEEPerformanceOCAP As %Double;

Property OEEPerformanceTarget As %Double;

Property OEEPotentialProductionTime As %Integer;

Property OEEProductivity As %Double;

Property OEEProductivityHistory As %Double;

Property OEEProductivityOCAP As %Double;

Property OEEProductivityTarget As %Double;

Property OEEQuality As %Double;

Property OEEQualityHistory As %Double;

Property OEEQualityOCAP As %Double;

Property OEEQualityTarget As %Double;

Property OEEUnscheduledDownTime As %Integer;

Property OEEUnscheduledIdleTime As %Integer;

Property OEEWaitingTime As %Integer;

Property OOELineRestraintTime As %Integer;

Property OutOfOrderTime As %Integer;

Property PreviousReading As opc.ua.data.GIP03.serving.GIP03OEESHIFT [ Transient ];

Property ProductionQty As %Integer;

Property ProductionTime As %Integer;

Property ShiftID As %Integer;

Property ShiftOperationID As %Integer;

Property StandByChangeOverTime As %Integer;

Property StandByLongStopTime As %Integer;

Property StandByShortStopTime As %Integer;

Property StopTime As %Integer;

Property TimeStampLocal As %TimeStamp;

Property UoM As %String;

Property Week As %Integer;

Property YearLocal As %Integer;

Storage Default
{
<Data name="GIP03OEESHIFTDefaultData">
<Subscript>"GIP03OEESHIFT"</Subscript>
<Value name="1">
<Value>AverageChangeOverTotalTime</Value>
</Value>
<Value name="2">
<Value>AverageChangeOverTotalTimeHistory</Value>
</Value>
<Value name="3">
<Value>AverageChangeOverTotalTimeOCAP</Value>
</Value>
<Value name="4">
<Value>AverageChangeOverTotalTimeTarget</Value>
</Value>
<Value name="5">
<Value>ChangeOverTime</Value>
</Value>
<Value name="6">
<Value>ChangeOverTotalTime</Value>
</Value>
<Value name="7">
<Value>DayLocal</Value>
</Value>
<Value name="8">
<Value>Equipment</Value>
</Value>
<Value name="9">
<Value>EquipmentID</Value>
</Value>
<Value name="10">
<Value>ForeRunnerTime</Value>
</Value>
<Value name="11">
<Value>LineUpQty</Value>
</Value>
<Value name="12">
<Value>LineupTime</Value>
</Value>
<Value name="13">
<Value>MachineStatus</Value>
</Value>
<Value name="14">
<Value>MisPasPercentage</Value>
</Value>
<Value name="15">
<Value>MisPasPercentageHistory</Value>
</Value>
<Value name="16">
<Value>MisPasPercentageOCAP</Value>
</Value>
<Value name="17">
<Value>MisPasPercentageTarget</Value>
</Value>
<Value name="18">
<Value>MisPasQty</Value>
</Value>
<Value name="19">
<Value>MonthLocal</Value>
</Value>
<Value name="20">
<Value>NoChangeOverStops</Value>
</Value>
<Value name="21">
<Value>NoOfChangeOvers</Value>
</Value>
<Value name="22">
<Value>NoOfLongStops</Value>
</Value>
<Value name="23">
<Value>NoOfOrders</Value>
</Value>
<Value name="24">
<Value>NoOfShortStops</Value>
</Value>
<Value name="25">
<Value>OEEActualProductionTime</Value>
</Value>
<Value name="26">
<Value>OEEAvailability</Value>
</Value>
<Value name="27">
<Value>OEEAvailabilityHistory</Value>
</Value>
<Value name="28">
<Value>OEEAvailabilityOCAP</Value>
</Value>
<Value name="29">
<Value>OEEAvailabilityTarget</Value>
</Value>
<Value name="30">
<Value>OEEFailureTime</Value>
</Value>
<Value name="31">
<Value>OEENotScheduledOperatingTime</Value>
</Value>
<Value name="32">
<Value>OEEOverall</Value>
</Value>
<Value name="33">
<Value>OEEOverallHistory</Value>
</Value>
<Value name="34">
<Value>OEEOverallOCAP</Value>
</Value>
<Value name="35">
<Value>OEEOverallTarget</Value>
</Value>
<Value name="36">
<Value>OEEPerformance</Value>
</Value>
<Value name="37">
<Value>OEEPerformanceHistory</Value>
</Value>
<Value name="38">
<Value>OEEPerformanceOCAP</Value>
</Value>
<Value name="39">
<Value>OEEPerformanceTarget</Value>
</Value>
<Value name="40">
<Value>OEEPotentialProductionTime</Value>
</Value>
<Value name="41">
<Value>OEEProductivity</Value>
</Value>
<Value name="42">
<Value>OEEProductivityHistory</Value>
</Value>
<Value name="43">
<Value>OEEProductivityOCAP</Value>
</Value>
<Value name="44">
<Value>OEEProductivityTarget</Value>
</Value>
<Value name="45">
<Value>OEEQuality</Value>
</Value>
<Value name="46">
<Value>OEEQualityHistory</Value>
</Value>
<Value name="47">
<Value>OEEQualityOCAP</Value>
</Value>
<Value name="48">
<Value>OEEQualityTarget</Value>
</Value>
<Value name="49">
<Value>OEEUnscheduledDownTime</Value>
</Value>
<Value name="50">
<Value>OEEUnscheduledIdleTime</Value>
</Value>
<Value name="51">
<Value>OEEWaitingTime</Value>
</Value>
<Value name="52">
<Value>OOELineRestraintTime</Value>
</Value>
<Value name="53">
<Value>OutOfOrderTime</Value>
</Value>
<Value name="54">
<Value>ProductionQty</Value>
</Value>
<Value name="55">
<Value>ProductionTime</Value>
</Value>
<Value name="56">
<Value>ShiftID</Value>
</Value>
<Value name="57">
<Value>ShiftOperationID</Value>
</Value>
<Value name="58">
<Value>StandByChangeOverTime</Value>
</Value>
<Value name="59">
<Value>StandByLongStopTime</Value>
</Value>
<Value name="60">
<Value>StandByShortStopTime</Value>
</Value>
<Value name="61">
<Value>StopTime</Value>
</Value>
<Value name="62">
<Value>TimeStampLocal</Value>
</Value>
<Value name="63">
<Value>UoM</Value>
</Value>
<Value name="64">
<Value>Week</Value>
</Value>
<Value name="65">
<Value>YearLocal</Value>
</Value>
</Data>
<DefaultData>GIP03OEESHIFTDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
