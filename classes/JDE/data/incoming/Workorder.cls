Class JDE.data.incoming.Workorder Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property OrderType As %String;

Property DocumentNumber As %Integer;

Property OrderSuffix As %String;

Property "Related_PO_SO_WO_OrderType" As %String;

Property "Related_PO_SO_WO_Number" As %String;

Property LineNumber As %Double;

Property PegToWorkOrder As %Integer;

Property NumberParentWONumber As %String;

Property TypeWO As %String;

Property PriorityWO As %String;

Property Description As %String;

Property StatusComment As %String;

Property Company As %String;

Property BusinessUnit As %String;

Property Branch As %String;

Property Location As %String;

Property Aisle As %String;

Property Bin As %String;

Property StatusCodeWO As %String;

Property DateStatusChanged As %String;

Property Subsidiary As %String;

Property AddressNumber As %Integer;

Property AddressNumberOriginator As %Integer;

Property AddressNumberManager As %Integer;

Property Supervisor As %Integer;

Property AddressNumberAssignedTo As %Integer;

Property DateWOPlannedCompleted As %String;

Property AddressNumberInspector As %Integer;

Property NextAddressNumber As %Integer;

Property "DateOrder_Transaction" As %String;

Property DateStart As %String;

Property DateRequested As %String;

Property DateCompletion As %String;

Property DateAssignedTo As %String;

Property DateAssignedToInspector As %String;

Property DatePaperPrintedDate As %String;

Property CategoriesWorkOrder01 As %String;

Property CategoriesWorkOrder02 As %String;

Property CategoriesWorkOrder03 As %String;

Property CategoriesWorkOrder04 As %String;

Property CategoriesWorkOrder05 As %String;

Property PeopleSoftConsultingStatus As %String;

Property PeopleSoftConsultingServiceType As %String;

Property PeopleSoftConsultingSkillType As %String;

Property PeopleSoftConsultingExperienceLevel As %String;

Property CategoriesWorkOrder10 As %String;

Property Reference As %String;

Property Reference2 As %String;

Property AmountEstimated As %Double;

Property CrewSize As %Double;

Property RevenueRateMarkupOverride As %Double;

Property "Pay_Deduction_BenefitType" As %String;

Property AmountChangeToOriginalDollars As %Double;

Property HoursEstimated As %Double;

Property HoursChangeToOriginalHours As %Double;

Property AmountActual As %Double;

Property HoursActual As %Double;

Property ItemNumberShort As %Integer;

Property "3rdItemNumber" As %String;

Property "2ndItemNumber" As %String;

Property AssetItemNumber As %Integer;

Property UnitOrTagNumber As %String;

Property "UnitsOrder_TransactionQuantity" As %Double;

Property "UnitsQtyBackordered_Held" As %Double;

Property "UnitsQuantityCanceled_Scrapped" As %Double;

Property QuantityShipped As %Double;

Property UnitsShippedToDate As %Double;

Property UnitOfMeasureasInput As %String;

Property MessageNumber As %String;

Property "TimeBeginning_HH_MM_SS" As %Integer;

Property TypeBillOfMaterial As %String;

Property TypeOfRouting As %String;

Property WOPickListPrinted As %String;

Property PostingEdit As %String;

Property VarianceFlag As %String;

Property "BillOfMaterial_N" As %String;

Property "RouteSheet_N" As %String;

Property WorkOrderFlashMessage As %String;

Property WorkOrderFreezeCode As %String;

Property IndentedCode As %String;

Property ResequenceCode As %Double;

Property "AmountMilesOrHours_units" As %Double;

Property DateScheduledTickler As %String;

Property AmountMemoBudgetChanges As %Double;

Property PercentComplete As %Integer;

Property LeadtimeLevel As %Integer;

Property LeadtimeCumulative As %Integer;

Property HoursUnaccountedDirectLabor As %Double;

Property "Lot_SerialNumber" As %String;

Property LotPotency As %Double;

Property LotGrade As %String;

Property "Ratio_CriticalRatioPriority1" As %Double;

Property "Ratio_CriticalRatioPriority2" As %Double;

Property DocumentType As %String;

Property SubledgerInactiveCode As %String;

Property "CompanyKey_RelatedOrder" As %String;

Property BillRevisionLevel As %String;

Property RoutingRevisionLevel As %String;

Property DrawingChange As %String;

Property RoutingChange As %String;

Property NewPartNumber As %String;

Property ReasonForECO As %String;

Property PhaseIn As %String;

Property ExistingDisposition As %String;

Property BOMChange As %String;

Property UserReservedCode As %String;

Property UserReservedDate As %String;

Property UserReservedAmount As %Double;

Property UserReservedNumber As %Integer;

Property UserReservedReference As %String;

Property UserID As %String;

Property ProgramID As %String;

Property WorkStationID As %String;

Property DateUpdated As %String;

Property TimeOfDay As %Integer;

Property ParentNumber As %Integer;

Property NextStatusWO As %String;

Property CriticalityWorkOrder As %Integer;

Property EstimatedDowntimeHours As %Double;

Property ActualDowntimeHours As %Double;

Property ServiceAddressNumber As %Integer;

Property MeterPosition As %Integer;

Property ApprovalType As %String;

Property AmountEstimatedLabor As %Double;

Property AmountEstimatedMaterial As %Double;

Property AmountEstimatedOther As %Double;

Property AmountActualLabor As %Double;

Property AmountActualMaterial As %Double;

Relationship Routing As Routing [ Cardinality = children, Inverse = Workorder ];

Storage Default
{
<Data name="WorkorderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderType</Value>
</Value>
<Value name="3">
<Value>DocumentNumber</Value>
</Value>
<Value name="4">
<Value>OrderSuffix</Value>
</Value>
<Value name="5">
<Value>Related_PO_SO_WO_OrderType</Value>
</Value>
<Value name="6">
<Value>Related_PO_SO_WO_Number</Value>
</Value>
<Value name="7">
<Value>LineNumber</Value>
</Value>
<Value name="8">
<Value>PegToWorkOrder</Value>
</Value>
<Value name="9">
<Value>NumberParentWONumber</Value>
</Value>
<Value name="10">
<Value>TypeWO</Value>
</Value>
<Value name="11">
<Value>PriorityWO</Value>
</Value>
<Value name="12">
<Value>Description</Value>
</Value>
<Value name="13">
<Value>StatusComment</Value>
</Value>
<Value name="14">
<Value>Company</Value>
</Value>
<Value name="15">
<Value>BusinessUnit</Value>
</Value>
<Value name="16">
<Value>Branch</Value>
</Value>
<Value name="17">
<Value>Location</Value>
</Value>
<Value name="18">
<Value>Aisle</Value>
</Value>
<Value name="19">
<Value>Bin</Value>
</Value>
<Value name="20">
<Value>StatusCodeWO</Value>
</Value>
<Value name="21">
<Value>DateStatusChanged</Value>
</Value>
<Value name="22">
<Value>Subsidiary</Value>
</Value>
<Value name="23">
<Value>AddressNumber</Value>
</Value>
<Value name="24">
<Value>AddressNumberOriginator</Value>
</Value>
<Value name="25">
<Value>AddressNumberManager</Value>
</Value>
<Value name="26">
<Value>Supervisor</Value>
</Value>
<Value name="27">
<Value>AddressNumberAssignedTo</Value>
</Value>
<Value name="28">
<Value>DateWOPlannedCompleted</Value>
</Value>
<Value name="29">
<Value>AddressNumberInspector</Value>
</Value>
<Value name="30">
<Value>NextAddressNumber</Value>
</Value>
<Value name="31">
<Value>DateOrder_Transaction</Value>
</Value>
<Value name="32">
<Value>DateStart</Value>
</Value>
<Value name="33">
<Value>DateRequested</Value>
</Value>
<Value name="34">
<Value>DateCompletion</Value>
</Value>
<Value name="35">
<Value>DateAssignedTo</Value>
</Value>
<Value name="36">
<Value>DateAssignedToInspector</Value>
</Value>
<Value name="37">
<Value>DatePaperPrintedDate</Value>
</Value>
<Value name="38">
<Value>CategoriesWorkOrder01</Value>
</Value>
<Value name="39">
<Value>CategoriesWorkOrder02</Value>
</Value>
<Value name="40">
<Value>CategoriesWorkOrder03</Value>
</Value>
<Value name="41">
<Value>CategoriesWorkOrder04</Value>
</Value>
<Value name="42">
<Value>CategoriesWorkOrder05</Value>
</Value>
<Value name="43">
<Value>PeopleSoftConsultingStatus</Value>
</Value>
<Value name="44">
<Value>PeopleSoftConsultingServiceType</Value>
</Value>
<Value name="45">
<Value>PeopleSoftConsultingSkillType</Value>
</Value>
<Value name="46">
<Value>PeopleSoftConsultingExperienceLevel</Value>
</Value>
<Value name="47">
<Value>CategoriesWorkOrder10</Value>
</Value>
<Value name="48">
<Value>Reference</Value>
</Value>
<Value name="49">
<Value>Reference2</Value>
</Value>
<Value name="50">
<Value>AmountEstimated</Value>
</Value>
<Value name="51">
<Value>CrewSize</Value>
</Value>
<Value name="52">
<Value>RevenueRateMarkupOverride</Value>
</Value>
<Value name="53">
<Value>Pay_Deduction_BenefitType</Value>
</Value>
<Value name="54">
<Value>AmountChangeToOriginalDollars</Value>
</Value>
<Value name="55">
<Value>HoursEstimated</Value>
</Value>
<Value name="56">
<Value>HoursChangeToOriginalHours</Value>
</Value>
<Value name="57">
<Value>AmountActual</Value>
</Value>
<Value name="58">
<Value>HoursActual</Value>
</Value>
<Value name="59">
<Value>ItemNumberShort</Value>
</Value>
<Value name="60">
<Value>3rdItemNumber</Value>
</Value>
<Value name="61">
<Value>2ndItemNumber</Value>
</Value>
<Value name="62">
<Value>AssetItemNumber</Value>
</Value>
<Value name="63">
<Value>UnitOrTagNumber</Value>
</Value>
<Value name="64">
<Value>UnitsOrder_TransactionQuantity</Value>
</Value>
<Value name="65">
<Value>UnitsQtyBackordered_Held</Value>
</Value>
<Value name="66">
<Value>UnitsQuantityCanceled_Scrapped</Value>
</Value>
<Value name="67">
<Value>QuantityShipped</Value>
</Value>
<Value name="68">
<Value>UnitsShippedToDate</Value>
</Value>
<Value name="69">
<Value>UnitOfMeasureasInput</Value>
</Value>
<Value name="70">
<Value>MessageNumber</Value>
</Value>
<Value name="71">
<Value>TimeBeginning_HH_MM_SS</Value>
</Value>
<Value name="72">
<Value>TypeBillOfMaterial</Value>
</Value>
<Value name="73">
<Value>TypeOfRouting</Value>
</Value>
<Value name="74">
<Value>WOPickListPrinted</Value>
</Value>
<Value name="75">
<Value>PostingEdit</Value>
</Value>
<Value name="76">
<Value>VarianceFlag</Value>
</Value>
<Value name="77">
<Value>BillOfMaterial_N</Value>
</Value>
<Value name="78">
<Value>RouteSheet_N</Value>
</Value>
<Value name="79">
<Value>WorkOrderFlashMessage</Value>
</Value>
<Value name="80">
<Value>WorkOrderFreezeCode</Value>
</Value>
<Value name="81">
<Value>IndentedCode</Value>
</Value>
<Value name="82">
<Value>ResequenceCode</Value>
</Value>
<Value name="83">
<Value>AmountMilesOrHours_units</Value>
</Value>
<Value name="84">
<Value>DateScheduledTickler</Value>
</Value>
<Value name="85">
<Value>AmountMemoBudgetChanges</Value>
</Value>
<Value name="86">
<Value>PercentComplete</Value>
</Value>
<Value name="87">
<Value>LeadtimeLevel</Value>
</Value>
<Value name="88">
<Value>LeadtimeCumulative</Value>
</Value>
<Value name="89">
<Value>HoursUnaccountedDirectLabor</Value>
</Value>
<Value name="90">
<Value>Lot_SerialNumber</Value>
</Value>
<Value name="91">
<Value>LotPotency</Value>
</Value>
<Value name="92">
<Value>LotGrade</Value>
</Value>
<Value name="93">
<Value>Ratio_CriticalRatioPriority1</Value>
</Value>
<Value name="94">
<Value>Ratio_CriticalRatioPriority2</Value>
</Value>
<Value name="95">
<Value>DocumentType</Value>
</Value>
<Value name="96">
<Value>SubledgerInactiveCode</Value>
</Value>
<Value name="97">
<Value>CompanyKey_RelatedOrder</Value>
</Value>
<Value name="98">
<Value>BillRevisionLevel</Value>
</Value>
<Value name="99">
<Value>RoutingRevisionLevel</Value>
</Value>
<Value name="100">
<Value>DrawingChange</Value>
</Value>
<Value name="101">
<Value>RoutingChange</Value>
</Value>
<Value name="102">
<Value>NewPartNumber</Value>
</Value>
<Value name="103">
<Value>ReasonForECO</Value>
</Value>
<Value name="104">
<Value>PhaseIn</Value>
</Value>
<Value name="105">
<Value>ExistingDisposition</Value>
</Value>
<Value name="106">
<Value>BOMChange</Value>
</Value>
<Value name="107">
<Value>UserReservedCode</Value>
</Value>
<Value name="108">
<Value>UserReservedDate</Value>
</Value>
<Value name="109">
<Value>UserReservedAmount</Value>
</Value>
<Value name="110">
<Value>UserReservedNumber</Value>
</Value>
<Value name="111">
<Value>UserReservedReference</Value>
</Value>
<Value name="112">
<Value>UserID</Value>
</Value>
<Value name="113">
<Value>ProgramID</Value>
</Value>
<Value name="114">
<Value>WorkStationID</Value>
</Value>
<Value name="115">
<Value>DateUpdated</Value>
</Value>
<Value name="116">
<Value>TimeOfDay</Value>
</Value>
<Value name="117">
<Value>ParentNumber</Value>
</Value>
<Value name="118">
<Value>NextStatusWO</Value>
</Value>
<Value name="119">
<Value>CriticalityWorkOrder</Value>
</Value>
<Value name="120">
<Value>EstimatedDowntimeHours</Value>
</Value>
<Value name="121">
<Value>ActualDowntimeHours</Value>
</Value>
<Value name="122">
<Value>ServiceAddressNumber</Value>
</Value>
<Value name="123">
<Value>MeterPosition</Value>
</Value>
<Value name="124">
<Value>ApprovalType</Value>
</Value>
<Value name="125">
<Value>AmountEstimatedLabor</Value>
</Value>
<Value name="126">
<Value>AmountEstimatedMaterial</Value>
</Value>
<Value name="127">
<Value>AmountEstimatedOther</Value>
</Value>
<Value name="128">
<Value>AmountActualLabor</Value>
</Value>
<Value name="129">
<Value>AmountActualMaterial</Value>
</Value>
</Data>
<DataLocation>^JDE.data.incoming.WorkorderD</DataLocation>
<DefaultData>WorkorderDefaultData</DefaultData>
<IdLocation>^JDE.data.incoming.WorkorderD</IdLocation>
<IndexLocation>^JDE.data.incoming.WorkorderI</IndexLocation>
<StreamLocation>^JDE.data.incoming.WorkorderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
