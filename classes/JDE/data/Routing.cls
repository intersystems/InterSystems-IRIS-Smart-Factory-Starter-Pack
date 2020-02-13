Class JDE.data.Routing Extends (%Persistent,%JSON.Adaptor)
{
Parameter %JSONIGNOREINVALIDFIELD = 1;

Property ActivityBasedCostingActivityCode As %String(%JSONFIELDNAME = "Activity-BasedCostingActivityCode");

Property AddressNumber As %Integer;

Property AddressNumberAssignedTo As %Integer;

Property AddressNumberManager As %Integer;

Property AmountUnaccountedDirectLabor As %Double;

Property AmountUnaccountedMachine As %Double;

Property AmountUnaccountedScrap As %Double;

Property AmountUnaccountedSetupLabor As %Double;

Property AssetItemNumber As %Integer;

Property AutoLoadDescription As %String;

Property Branch As %String;

Property BusinessUnit As %String;

Property CapacityUnitOfMeasure As %String;

Property CompanyKeyRelatedOrder As %String(%JSONFIELDNAME = "CompanyKey_RelatedOrder");

Property CompetencyCode As %String;

Property CompetencyLevelFrom As %Double;

Property CompetencyLevelTo As %Double;

Property CompetencyType As %String;

Property ConstraintsFlag As %String;

Property CostComponent As %String;

Property CrewSize As %Double;

Property CriticalRatio As %Double;

Property DateActualStart As %String;

Property DateCompletion As %String;

Property DateOrderTransaction As %String(%JSONFIELDNAME = "DateOrder_Transaction");

Property DateRequested As %String;

Property DateStart As %String;

Property DateUpdated As %String;

Property Description As %String;

Property DocumentNumber As %Integer;

Property DocumentType As %String;

Property FactorOperationShrinkageFactor As %Double;

Property HoursSetupLaborHoursActual As %Double;

Property HoursUnaccountedDirectLabor As %Double;

Property HoursUnaccountedMachineHours As %Double;

Property HoursUnaccountedSetupLabor As %Double;

Property InspectionCode As %String;

Property JobTypeCraftCode As %String(%JSONFIELDNAME = "JobType_CraftCode");

Property Kit2ndItemNumber As %String;

Property LabororMachine As %String;

Property LineCellIdentifier As %String(%JSONFIELDNAME = "Line_CellIdentifier");

Property Location As %String;

Property MaintenanceScheduleFlag As %String;

Property MessageNumber As %String;

Property MoveHoursStandard As %Double;

Property ObjectAccount As %String;

Property OperationStatusCodeWO As %String;

Property OrderSuffix As %String;

Property OrderType As %String;

Property ParentShortItemNumber As %Integer(%JSONFIELDNAME = "Parent_ShortItemNumber");

Property PayPointCode As %String;

Property PayPointStatus As %String;

Property PercentCumulativePlannedYield As %Double;

Property PercentLeadtimeOverlap As %Double;

Property PercentOperationalPlannedYield As %Double;

Property PercentOverlap As %Double;

Property PrimaryLastSupplierNumber As %Integer(%JSONFIELDNAME = "Primary_LastSupplierNumber");

Property ProgramID As %String;

Property ProjectBusinessUnit As %String;

Property QuantityShipped As %Double;

Property QueueHoursStandard As %Double;

Property RatePiecework As %Double;

Property RelatedPOSOLineNumber As %Double(%JSONFIELDNAME = "Related_PO_SO_LineNumber");

Property RelatedPOSOWONumber As %String(%JSONFIELDNAME = "Related_PO_SO_WO_Number");

Property RelatedPOSOWOOrderType As %String(%JSONFIELDNAME = "Related_PO_SO_WO_OrderType");

Property ResourceUnitsConsumed As %Double;

Property ResourcesAssigned As %String;

Property RuleMatchFlag As %String;

Property RunLaborActual As %Double;

Property RunLaborCurrent As %Double;

Property RunLaborRate As %Double;

Property RunLaborStandard As %Double;

Property RunMachineActual As %Double;

Property RunMachineCurrent As %Double;

Property RunMachineRate As %Double;

Property RunMachineStandard As %Double;

Property SequenceNumberNextOperation As %Double;

Property SequenceNumberOperations As %Double;

Property SetupLaborCurrent As %Double;

Property SetupLaborRate As %Double;

Property SetupLaborStandard As %Double;

Property ShiftCodeCompleted As %String;

Property ShiftCodeRequested As %String;

Property ShiftCodeStart As %String;

Property SlackTimeRatio As %Double;

Property Subsidiary As %String;

Property Supervisor As %Integer;

Property TimeBasisCode As %String;

Property TimeCompleted As %Integer;

Property TimeOfDay As %Integer;

Property TimeScheduledEndHHMMSS As %Integer(%JSONFIELDNAME = "TimeScheduledEnd_HH_MM_SS");

Property TimeScheduledStartHHMMSS As %Integer(%JSONFIELDNAME = "TimeScheduledStart_HH_MM_SS");

Property TimeStartHHMMSS As %Integer(%JSONFIELDNAME = "TimeStart_HH_MM_SS");

Property TypeOfRouting As %String;

Property TypeOperationCode As %String;

Property UnitOfMeasureAsInput As %String;

Property UnitOrTagNumber As %String;

Property UnitsOrderTransactionQuantity As %Double(%JSONFIELDNAME = "UnitsOrder_TransactionQuantity");

Property UnitsQuantityCanceledScrapped As %Double(%JSONFIELDNAME = "UnitsQuantityCanceled_Scrapped");

Property UnitsQuantityatOperation As %Double;

Property UnitsUnaccountedScrap As %Double;

Property UserID As %String;

Property UserReservedAmount As %Double;

Property UserReservedCode As %String;

Property UserReservedDate As %String;

Property UserReservedNumber As %Integer;

Property UserReservedReference As %String;

Property WorkStationID As %String;

Property WorkcenterBranch As %String;

Property n3rdItemNumberKit As %String(%JSONFIELDNAME = "3rdItemNumberKit");

Storage Default
{
<Data name="RoutingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActivityBasedCostingActivityCode</Value>
</Value>
<Value name="3">
<Value>AddressNumber</Value>
</Value>
<Value name="4">
<Value>AddressNumberAssignedTo</Value>
</Value>
<Value name="5">
<Value>AddressNumberManager</Value>
</Value>
<Value name="6">
<Value>AmountUnaccountedDirectLabor</Value>
</Value>
<Value name="7">
<Value>AmountUnaccountedMachine</Value>
</Value>
<Value name="8">
<Value>AmountUnaccountedScrap</Value>
</Value>
<Value name="9">
<Value>AmountUnaccountedSetupLabor</Value>
</Value>
<Value name="10">
<Value>AssetItemNumber</Value>
</Value>
<Value name="11">
<Value>AutoLoadDescription</Value>
</Value>
<Value name="12">
<Value>Branch</Value>
</Value>
<Value name="13">
<Value>BusinessUnit</Value>
</Value>
<Value name="14">
<Value>CapacityUnitOfMeasure</Value>
</Value>
<Value name="15">
<Value>CompanyKeyRelatedOrder</Value>
</Value>
<Value name="16">
<Value>CompetencyCode</Value>
</Value>
<Value name="17">
<Value>CompetencyLevelFrom</Value>
</Value>
<Value name="18">
<Value>CompetencyLevelTo</Value>
</Value>
<Value name="19">
<Value>CompetencyType</Value>
</Value>
<Value name="20">
<Value>ConstraintsFlag</Value>
</Value>
<Value name="21">
<Value>CostComponent</Value>
</Value>
<Value name="22">
<Value>CrewSize</Value>
</Value>
<Value name="23">
<Value>CriticalRatio</Value>
</Value>
<Value name="24">
<Value>DateActualStart</Value>
</Value>
<Value name="25">
<Value>DateCompletion</Value>
</Value>
<Value name="26">
<Value>DateOrderTransaction</Value>
</Value>
<Value name="27">
<Value>DateRequested</Value>
</Value>
<Value name="28">
<Value>DateStart</Value>
</Value>
<Value name="29">
<Value>DateUpdated</Value>
</Value>
<Value name="30">
<Value>Description</Value>
</Value>
<Value name="31">
<Value>DocumentNumber</Value>
</Value>
<Value name="32">
<Value>DocumentType</Value>
</Value>
<Value name="33">
<Value>FactorOperationShrinkageFactor</Value>
</Value>
<Value name="34">
<Value>HoursSetupLaborHoursActual</Value>
</Value>
<Value name="35">
<Value>HoursUnaccountedDirectLabor</Value>
</Value>
<Value name="36">
<Value>HoursUnaccountedMachineHours</Value>
</Value>
<Value name="37">
<Value>HoursUnaccountedSetupLabor</Value>
</Value>
<Value name="38">
<Value>InspectionCode</Value>
</Value>
<Value name="39">
<Value>JobTypeCraftCode</Value>
</Value>
<Value name="40">
<Value>Kit2ndItemNumber</Value>
</Value>
<Value name="41">
<Value>LabororMachine</Value>
</Value>
<Value name="42">
<Value>LineCellIdentifier</Value>
</Value>
<Value name="43">
<Value>Location</Value>
</Value>
<Value name="44">
<Value>MaintenanceScheduleFlag</Value>
</Value>
<Value name="45">
<Value>MessageNumber</Value>
</Value>
<Value name="46">
<Value>MoveHoursStandard</Value>
</Value>
<Value name="47">
<Value>ObjectAccount</Value>
</Value>
<Value name="48">
<Value>OperationStatusCodeWO</Value>
</Value>
<Value name="49">
<Value>OrderSuffix</Value>
</Value>
<Value name="50">
<Value>OrderType</Value>
</Value>
<Value name="51">
<Value>ParentShortItemNumber</Value>
</Value>
<Value name="52">
<Value>PayPointCode</Value>
</Value>
<Value name="53">
<Value>PayPointStatus</Value>
</Value>
<Value name="54">
<Value>PercentCumulativePlannedYield</Value>
</Value>
<Value name="55">
<Value>PercentLeadtimeOverlap</Value>
</Value>
<Value name="56">
<Value>PercentOperationalPlannedYield</Value>
</Value>
<Value name="57">
<Value>PercentOverlap</Value>
</Value>
<Value name="58">
<Value>PrimaryLastSupplierNumber</Value>
</Value>
<Value name="59">
<Value>ProgramID</Value>
</Value>
<Value name="60">
<Value>ProjectBusinessUnit</Value>
</Value>
<Value name="61">
<Value>QuantityShipped</Value>
</Value>
<Value name="62">
<Value>QueueHoursStandard</Value>
</Value>
<Value name="63">
<Value>RatePiecework</Value>
</Value>
<Value name="64">
<Value>RelatedPOSOLineNumber</Value>
</Value>
<Value name="65">
<Value>RelatedPOSOWONumber</Value>
</Value>
<Value name="66">
<Value>RelatedPOSOWOOrderType</Value>
</Value>
<Value name="67">
<Value>ResourceUnitsConsumed</Value>
</Value>
<Value name="68">
<Value>ResourcesAssigned</Value>
</Value>
<Value name="69">
<Value>RuleMatchFlag</Value>
</Value>
<Value name="70">
<Value>RunLaborActual</Value>
</Value>
<Value name="71">
<Value>RunLaborCurrent</Value>
</Value>
<Value name="72">
<Value>RunLaborRate</Value>
</Value>
<Value name="73">
<Value>RunLaborStandard</Value>
</Value>
<Value name="74">
<Value>RunMachineActual</Value>
</Value>
<Value name="75">
<Value>RunMachineCurrent</Value>
</Value>
<Value name="76">
<Value>RunMachineRate</Value>
</Value>
<Value name="77">
<Value>RunMachineStandard</Value>
</Value>
<Value name="78">
<Value>SequenceNumberNextOperation</Value>
</Value>
<Value name="79">
<Value>SequenceNumberOperations</Value>
</Value>
<Value name="80">
<Value>SetupLaborCurrent</Value>
</Value>
<Value name="81">
<Value>SetupLaborRate</Value>
</Value>
<Value name="82">
<Value>SetupLaborStandard</Value>
</Value>
<Value name="83">
<Value>ShiftCodeCompleted</Value>
</Value>
<Value name="84">
<Value>ShiftCodeRequested</Value>
</Value>
<Value name="85">
<Value>ShiftCodeStart</Value>
</Value>
<Value name="86">
<Value>SlackTimeRatio</Value>
</Value>
<Value name="87">
<Value>Subsidiary</Value>
</Value>
<Value name="88">
<Value>Supervisor</Value>
</Value>
<Value name="89">
<Value>TimeBasisCode</Value>
</Value>
<Value name="90">
<Value>TimeCompleted</Value>
</Value>
<Value name="91">
<Value>TimeOfDay</Value>
</Value>
<Value name="92">
<Value>TimeScheduledEndHHMMSS</Value>
</Value>
<Value name="93">
<Value>TimeScheduledStartHHMMSS</Value>
</Value>
<Value name="94">
<Value>TimeStartHHMMSS</Value>
</Value>
<Value name="95">
<Value>TypeOfRouting</Value>
</Value>
<Value name="96">
<Value>TypeOperationCode</Value>
</Value>
<Value name="97">
<Value>UnitOfMeasureAsInput</Value>
</Value>
<Value name="98">
<Value>UnitOrTagNumber</Value>
</Value>
<Value name="99">
<Value>UnitsOrderTransactionQuantity</Value>
</Value>
<Value name="100">
<Value>UnitsQuantityCanceledScrapped</Value>
</Value>
<Value name="101">
<Value>UnitsQuantityatOperation</Value>
</Value>
<Value name="102">
<Value>UnitsUnaccountedScrap</Value>
</Value>
<Value name="103">
<Value>UserID</Value>
</Value>
<Value name="104">
<Value>UserReservedAmount</Value>
</Value>
<Value name="105">
<Value>UserReservedCode</Value>
</Value>
<Value name="106">
<Value>UserReservedDate</Value>
</Value>
<Value name="107">
<Value>UserReservedNumber</Value>
</Value>
<Value name="108">
<Value>UserReservedReference</Value>
</Value>
<Value name="109">
<Value>WorkStationID</Value>
</Value>
<Value name="110">
<Value>WorkcenterBranch</Value>
</Value>
<Value name="111">
<Value>n3rdItemNumberKit</Value>
</Value>
</Data>
<DataLocation>^JDE.data.RoutingD</DataLocation>
<DefaultData>RoutingDefaultData</DefaultData>
<IdLocation>^JDE.data.RoutingD</IdLocation>
<IndexLocation>^JDE.data.RoutingI</IndexLocation>
<StreamLocation>^JDE.data.RoutingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}