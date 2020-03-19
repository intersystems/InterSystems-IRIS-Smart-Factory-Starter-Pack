Class JDE.data.incoming.Routing Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property DocumentNumber As %Integer;

Property OrderType As %String;

Property OrderSuffix As %String;

Property TypeOfRouting As %String;

Property "Parent_ShortItemNumber" As %Integer;

Property Kit2ndItemNumber As %String;

Property "3rdItemNumberKit" As %String;

Property Branch As %String;

Property "Line_CellIdentifier" As %String;

Property BusinessUnit As %String;

Property AutoLoadDescription As %String;

Property Description As %String;

Property SequenceNumberOperations As %Double;

Property TypeOperationCode As %String;

Property OperationStatusCodeWO As %String;

Property InspectionCode As %String;

Property TimeBasisCode As %String;

Property LabororMachine As %String;

Property PayPointCode As %String;

Property PayPointStatus As %String;

Property "JobType_CraftCode" As %String;

Property AddressNumber As %Integer;

Property CriticalRatio As %Double;

Property SlackTimeRatio As %Double;

Property "DateOrder_Transaction" As %String;

Property DateRequested As %String;

Property DateStart As %String;

Property DateCompletion As %String;

Property ShiftCodeRequested As %String;

Property ShiftCodeStart As %String;

Property ShiftCodeCompleted As %String;

Property PercentLeadtimeOverlap As %Double;

Property PercentOverlap As %Double;

Property PercentOperationalPlannedYield As %Double;

Property PercentCumulativePlannedYield As %Double;

Property SequenceNumberNextOperation As %Double;

Property CrewSize As %Double;

Property MoveHoursStandard As %Double;

Property QueueHoursStandard As %Double;

Property RunMachineStandard As %Double;

Property RunLaborStandard As %Double;

Property SetupLaborStandard As %Double;

Property RunMachineActual As %Double;

Property RunLaborActual As %Double;

Property HoursSetupLaborHoursActual As %Double;

Property FactorOperationShrinkageFactor As %Double;

Property "UnitsOrder_TransactionQuantity" As %Double;

Property "UnitsQuantityCanceled_Scrapped" As %Double;

Property QuantityShipped As %Double;

Property UnitsQuantityatOperation As %Double;

Property RatePiecework As %Double;

Property UnitOfMeasureAsInput As %String;

Property HoursUnaccountedSetupLabor As %Double;

Property HoursUnaccountedMachineHours As %Double;

Property AmountUnaccountedDirectLabor As %Double;

Property AmountUnaccountedSetupLabor As %Double;

Property AmountUnaccountedMachine As %Double;

Property UnitOrTagNumber As %String;

Property MessageNumber As %String;

Property ProjectBusinessUnit As %String;

Property ObjectAccount As %String;

Property Subsidiary As %String;

Property "Primary_LastSupplierNumber" As %Integer;

Property "CompanyKey_RelatedOrder" As %String;

Property "Related_PO_SO_WO_Number" As %String;

Property "Related_PO_SO_WO_OrderType" As %String;

Property "Related_PO_SO_LineNumber" As %Double;

Property DocumentType As %String;

Property UserReservedCode As %String;

Property UserReservedDate As %String;

Property UserReservedAmount As %Double;

Property UserReservedReference As %String;

Property UserReservedNumber As %Integer;

Property UserID As %String;

Property ProgramID As %String;

Property WorkStationID As %String;

Property DateUpdated As %String;

Property TimeOfDay As %Integer;

Property Location As %String;

Property ResourceUnitsConsumed As %Double;

Property CapacityUnitOfMeasure As %String;

Property WorkcenterBranch As %String;

Property RunMachineCurrent As %Double;

Property RunLaborCurrent As %Double;

Property SetupLaborCurrent As %Double;

Property CostComponent As %String;

Property "Activity-BasedCostingActivityCode" As %String;

Property AssetItemNumber As %Integer;

Property AmountUnaccountedScrap As %Double;

Property UnitsUnaccountedScrap As %Double;

Property HoursUnaccountedDirectLabor As %Double;

Property RunLaborRate As %Double;

Property RunMachineRate As %Double;

Property SetupLaborRate As %Double;

Property ConstraintsFlag As %String;

Property "TimeScheduledStart_HH_MM_SS" As %Integer;

Property "TimeScheduledEnd_HH_MM_SS" As %Integer;

Property TimeCompleted As %Integer;

Property DateActualStart As %String;

Property "TimeStart_HH_MM_SS" As %Integer;

Property CompetencyType As %String;

Property CompetencyCode As %String;

Property CompetencyLevelFrom As %Double;

Property CompetencyLevelTo As %Double;

Property RuleMatchFlag As %String;

Property AddressNumberManager As %Integer;

Property Supervisor As %Integer;

Property AddressNumberAssignedTo As %Integer;

Property MaintenanceScheduleFlag As %String;

Property ResourcesAssigned As %String;

Relationship Workorder As Workorder [ Cardinality = parent, Inverse = Routing ];

Index WorkorderIndex On Workorder;

Storage Default
{
<Data name="RoutingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentNumber</Value>
</Value>
<Value name="3">
<Value>OrderType</Value>
</Value>
<Value name="4">
<Value>OrderSuffix</Value>
</Value>
<Value name="5">
<Value>TypeOfRouting</Value>
</Value>
<Value name="6">
<Value>Parent_ShortItemNumber</Value>
</Value>
<Value name="7">
<Value>Kit2ndItemNumber</Value>
</Value>
<Value name="8">
<Value>3rdItemNumberKit</Value>
</Value>
<Value name="9">
<Value>Branch</Value>
</Value>
<Value name="10">
<Value>Line_CellIdentifier</Value>
</Value>
<Value name="11">
<Value>BusinessUnit</Value>
</Value>
<Value name="12">
<Value>AutoLoadDescription</Value>
</Value>
<Value name="13">
<Value>Description</Value>
</Value>
<Value name="14">
<Value>SequenceNumberOperations</Value>
</Value>
<Value name="15">
<Value>TypeOperationCode</Value>
</Value>
<Value name="16">
<Value>OperationStatusCodeWO</Value>
</Value>
<Value name="17">
<Value>InspectionCode</Value>
</Value>
<Value name="18">
<Value>TimeBasisCode</Value>
</Value>
<Value name="19">
<Value>LabororMachine</Value>
</Value>
<Value name="20">
<Value>PayPointCode</Value>
</Value>
<Value name="21">
<Value>PayPointStatus</Value>
</Value>
<Value name="22">
<Value>JobType_CraftCode</Value>
</Value>
<Value name="23">
<Value>AddressNumber</Value>
</Value>
<Value name="24">
<Value>CriticalRatio</Value>
</Value>
<Value name="25">
<Value>SlackTimeRatio</Value>
</Value>
<Value name="26">
<Value>DateOrder_Transaction</Value>
</Value>
<Value name="27">
<Value>DateRequested</Value>
</Value>
<Value name="28">
<Value>DateStart</Value>
</Value>
<Value name="29">
<Value>DateCompletion</Value>
</Value>
<Value name="30">
<Value>ShiftCodeRequested</Value>
</Value>
<Value name="31">
<Value>ShiftCodeStart</Value>
</Value>
<Value name="32">
<Value>ShiftCodeCompleted</Value>
</Value>
<Value name="33">
<Value>PercentLeadtimeOverlap</Value>
</Value>
<Value name="34">
<Value>PercentOverlap</Value>
</Value>
<Value name="35">
<Value>PercentOperationalPlannedYield</Value>
</Value>
<Value name="36">
<Value>PercentCumulativePlannedYield</Value>
</Value>
<Value name="37">
<Value>SequenceNumberNextOperation</Value>
</Value>
<Value name="38">
<Value>CrewSize</Value>
</Value>
<Value name="39">
<Value>MoveHoursStandard</Value>
</Value>
<Value name="40">
<Value>QueueHoursStandard</Value>
</Value>
<Value name="41">
<Value>RunMachineStandard</Value>
</Value>
<Value name="42">
<Value>RunLaborStandard</Value>
</Value>
<Value name="43">
<Value>SetupLaborStandard</Value>
</Value>
<Value name="44">
<Value>RunMachineActual</Value>
</Value>
<Value name="45">
<Value>RunLaborActual</Value>
</Value>
<Value name="46">
<Value>HoursSetupLaborHoursActual</Value>
</Value>
<Value name="47">
<Value>FactorOperationShrinkageFactor</Value>
</Value>
<Value name="48">
<Value>UnitsOrder_TransactionQuantity</Value>
</Value>
<Value name="49">
<Value>UnitsQuantityCanceled_Scrapped</Value>
</Value>
<Value name="50">
<Value>QuantityShipped</Value>
</Value>
<Value name="51">
<Value>UnitsQuantityatOperation</Value>
</Value>
<Value name="52">
<Value>RatePiecework</Value>
</Value>
<Value name="53">
<Value>UnitOfMeasureAsInput</Value>
</Value>
<Value name="54">
<Value>HoursUnaccountedSetupLabor</Value>
</Value>
<Value name="55">
<Value>HoursUnaccountedMachineHours</Value>
</Value>
<Value name="56">
<Value>AmountUnaccountedDirectLabor</Value>
</Value>
<Value name="57">
<Value>AmountUnaccountedSetupLabor</Value>
</Value>
<Value name="58">
<Value>AmountUnaccountedMachine</Value>
</Value>
<Value name="59">
<Value>UnitOrTagNumber</Value>
</Value>
<Value name="60">
<Value>MessageNumber</Value>
</Value>
<Value name="61">
<Value>ProjectBusinessUnit</Value>
</Value>
<Value name="62">
<Value>ObjectAccount</Value>
</Value>
<Value name="63">
<Value>Subsidiary</Value>
</Value>
<Value name="64">
<Value>Primary_LastSupplierNumber</Value>
</Value>
<Value name="65">
<Value>CompanyKey_RelatedOrder</Value>
</Value>
<Value name="66">
<Value>Related_PO_SO_WO_Number</Value>
</Value>
<Value name="67">
<Value>Related_PO_SO_WO_OrderType</Value>
</Value>
<Value name="68">
<Value>Related_PO_SO_LineNumber</Value>
</Value>
<Value name="69">
<Value>DocumentType</Value>
</Value>
<Value name="70">
<Value>UserReservedCode</Value>
</Value>
<Value name="71">
<Value>UserReservedDate</Value>
</Value>
<Value name="72">
<Value>UserReservedAmount</Value>
</Value>
<Value name="73">
<Value>UserReservedReference</Value>
</Value>
<Value name="74">
<Value>UserReservedNumber</Value>
</Value>
<Value name="75">
<Value>UserID</Value>
</Value>
<Value name="76">
<Value>ProgramID</Value>
</Value>
<Value name="77">
<Value>WorkStationID</Value>
</Value>
<Value name="78">
<Value>DateUpdated</Value>
</Value>
<Value name="79">
<Value>TimeOfDay</Value>
</Value>
<Value name="80">
<Value>Location</Value>
</Value>
<Value name="81">
<Value>ResourceUnitsConsumed</Value>
</Value>
<Value name="82">
<Value>CapacityUnitOfMeasure</Value>
</Value>
<Value name="83">
<Value>WorkcenterBranch</Value>
</Value>
<Value name="84">
<Value>RunMachineCurrent</Value>
</Value>
<Value name="85">
<Value>RunLaborCurrent</Value>
</Value>
<Value name="86">
<Value>SetupLaborCurrent</Value>
</Value>
<Value name="87">
<Value>CostComponent</Value>
</Value>
<Value name="88">
<Value>Activity-BasedCostingActivityCode</Value>
</Value>
<Value name="89">
<Value>AssetItemNumber</Value>
</Value>
<Value name="90">
<Value>AmountUnaccountedScrap</Value>
</Value>
<Value name="91">
<Value>UnitsUnaccountedScrap</Value>
</Value>
<Value name="92">
<Value>HoursUnaccountedDirectLabor</Value>
</Value>
<Value name="93">
<Value>RunLaborRate</Value>
</Value>
<Value name="94">
<Value>RunMachineRate</Value>
</Value>
<Value name="95">
<Value>SetupLaborRate</Value>
</Value>
<Value name="96">
<Value>ConstraintsFlag</Value>
</Value>
<Value name="97">
<Value>TimeScheduledStart_HH_MM_SS</Value>
</Value>
<Value name="98">
<Value>TimeScheduledEnd_HH_MM_SS</Value>
</Value>
<Value name="99">
<Value>TimeCompleted</Value>
</Value>
<Value name="100">
<Value>DateActualStart</Value>
</Value>
<Value name="101">
<Value>TimeStart_HH_MM_SS</Value>
</Value>
<Value name="102">
<Value>CompetencyType</Value>
</Value>
<Value name="103">
<Value>CompetencyCode</Value>
</Value>
<Value name="104">
<Value>CompetencyLevelFrom</Value>
</Value>
<Value name="105">
<Value>CompetencyLevelTo</Value>
</Value>
<Value name="106">
<Value>RuleMatchFlag</Value>
</Value>
<Value name="107">
<Value>AddressNumberManager</Value>
</Value>
<Value name="108">
<Value>Supervisor</Value>
</Value>
<Value name="109">
<Value>AddressNumberAssignedTo</Value>
</Value>
<Value name="110">
<Value>MaintenanceScheduleFlag</Value>
</Value>
<Value name="111">
<Value>ResourcesAssigned</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Routing")</DataLocation>
<DefaultData>RoutingDefaultData</DefaultData>
<IdLocation>^JDE.data.incoming.WorkorderC("Routing")</IdLocation>
<IndexLocation>^JDE.data.incoming.RoutingI</IndexLocation>
<StreamLocation>^JDE.data.incoming.RoutingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
