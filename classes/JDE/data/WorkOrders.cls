Class JDE.data.WorkOrders Extends (%Persistent,%JSON.Adaptor)
{
Parameter %JSONIGNOREINVALIDFIELD = 1;

Property ActualDowntimeHours As %Double;

Property AddressNumber As %Integer;

Property AddressNumberAssignedTo As %Integer;

Property AddressNumberInspector As %Integer;

Property AddressNumberManager As %Integer;

Property AddressNumberOriginator As %Integer;

Property Aisle As %String;

Property AmountActual As %Double;

Property AmountActualLabor As %Double;

Property AmountActualMaterial As %Double;

Property AmountChangeToOriginalDollars As %Double;

Property AmountEstimated As %Double;

Property AmountEstimatedLabor As %Double;

Property AmountEstimatedMaterial As %Double;

Property AmountEstimatedOther As %Double;

Property AmountMemoBudgetChanges As %Double;

Property AmountMilesOrHoursunits As %Double(%JSONFIELDNAME = "AmountMilesOrHours_units");

Property ApprovalType As %String;

Property AssetItemNumber As %Integer;

Property BOMChange As %String;

Property BillOfMaterialN As %String(%JSONFIELDNAME = "BillOfMaterial_N");

Property BillRevisionLevel As %String;

Property Bin As %String;

Property Branch As %String;

Property BusinessUnit As %String;

Property CategoriesWorkOrder01 As %String;

Property CategoriesWorkOrder02 As %String;

Property CategoriesWorkOrder03 As %String;

Property CategoriesWorkOrder04 As %String;

Property CategoriesWorkOrder05 As %String;

Property CategoriesWorkOrder10 As %String;

Property Company As %String;

Property CompanyKeyRelatedOrder As %String(%JSONFIELDNAME = "CompanyKey_RelatedOrder");

Property CrewSize As %Double;

Property CriticalityWorkOrder As %Integer;

Property DateAssignedTo As %String;

Property DateAssignedToInspector As %String;

Property DateCompletion As %String;

Property DateOrderTransaction As %String(%JSONFIELDNAME = "DateOrder_Transaction");

Property DatePaperPrintedDate As %String;

Property DateRequested As %String;

Property DateScheduledTickler As %String;

Property DateStart As %String;

Property DateStatusChanged As %String;

Property DateUpdated As %String;

Property DateWOPlannedCompleted As %String;

Property Description As %String;

Property DocumentNumber As %Integer;

Property DocumentType As %String;

Property DrawingChange As %String;

Property EstimatedDowntimeHours As %Double;

Property ExistingDisposition As %String;

Property HoursActual As %Double;

Property HoursChangeToOriginalHours As %Double;

Property HoursEstimated As %Double;

Property HoursUnaccountedDirectLabor As %Double;

Property IndentedCode As %String;

Property ItemNumberShort As %Integer;

Property LeadtimeCumulative As %Integer;

Property LeadtimeLevel As %Integer;

Property LineNumber As %Double;

Property Location As %String;

Property LotGrade As %String;

Property LotPotency As %Double;

Property LotSerialNumber As %String(%JSONFIELDNAME = "Lot_SerialNumber");

Property MessageNumber As %String;

Property MeterPosition As %Integer;

Property NewPartNumber As %String;

Property NextAddressNumber As %Integer;

Property NextStatusWO As %String;

Property NumberParentWONumber As %String;

Property OrderSuffix As %String;

Property OrderType As %String;

Property ParentNumber As %Integer;

Property PayDeductionBenefitType As %String(%JSONFIELDNAME = "Pay_Deduction_BenefitType");

Property PegToWorkOrder As %Integer;

Property PeopleSoftConsultingExperienceLevel As %String;

Property PeopleSoftConsultingServiceType As %String;

Property PeopleSoftConsultingSkillType As %String;

Property PeopleSoftConsultingStatus As %String;

Property PercentComplete As %Integer;

Property PhaseIn As %String;

Property PostingEdit As %String;

Property PriorityWO As %String;

Property ProgramID As %String;

Property QuantityShipped As %Double;

Property RatioCriticalRatioPriority1 As %Double(%JSONFIELDNAME = "Ratio_CriticalRatioPriority1");

Property RatioCriticalRatioPriority2 As %Double(%JSONFIELDNAME = "Ratio_CriticalRatioPriority2");

Property ReasonForECO As %String;

Property Reference As %String;

Property Reference2 As %String;

Property RelatedPOSOWONumber As %String(%JSONFIELDNAME = "Related_PO_SO_WO_Number");

Property RelatedPOSOWOOrderType As %String(%JSONFIELDNAME = "Related_PO_SO_WO_OrderType");

Property ResequenceCode As %Double;

Property RevenueRateMarkupOverride As %Double;

Property RouteSheetN As %String(%JSONFIELDNAME = "RouteSheet_N");

Property Routing As list Of JDE.data.Routing;

Property RoutingChange As %String;

Property RoutingRevisionLevel As %String;

Property ServiceAddressNumber As %Integer;

Property StatusCodeWO As %String;

Property StatusComment As %String;

Property SubledgerInactiveCode As %String;

Property Subsidiary As %String;

Property Supervisor As %Integer;

Property TimeBeginningHHMMSS As %Integer(%JSONFIELDNAME = "TimeBeginning_HH_MM_SS");

Property TimeOfDay As %Integer;

Property TypeBillOfMaterial As %String;

Property TypeOfRouting As %String;

Property TypeWO As %String;

Property UnitOfMeasureasInput As %String;

Property UnitOrTagNumber As %String;

Property UnitsOrderTransactionQuantity As %Double(%JSONFIELDNAME = "UnitsOrder_TransactionQuantity");

Property UnitsQtyBackorderedHeld As %Double(%JSONFIELDNAME = "UnitsQtyBackordered_Held");

Property UnitsQuantityCanceledScrapped As %Double(%JSONFIELDNAME = "UnitsQuantityCanceled_Scrapped");

Property UnitsShippedToDate As %Double;

Property UserID As %String;

Property UserReservedAmount As %Double;

Property UserReservedCode As %String;

Property UserReservedDate As %String;

Property UserReservedNumber As %Integer;

Property UserReservedReference As %String;

Property VarianceFlag As %String;

Property WOPickListPrinted As %String;

Property WorkOrderFlashMessage As %String;

Property WorkOrderFreezeCode As %String;

Property WorkStationID As %String;

Property n2ndItemNumber As %String(%JSONFIELDNAME = "2ndItemNumber");

Property n3rdItemNumber As %String(%JSONFIELDNAME = "3rdItemNumber");


Storage Default
{
<Data name="WorkOrdersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActualDowntimeHours</Value>
</Value>
<Value name="3">
<Value>AddressNumber</Value>
</Value>
<Value name="4">
<Value>AddressNumberAssignedTo</Value>
</Value>
<Value name="5">
<Value>AddressNumberInspector</Value>
</Value>
<Value name="6">
<Value>AddressNumberManager</Value>
</Value>
<Value name="7">
<Value>AddressNumberOriginator</Value>
</Value>
<Value name="8">
<Value>Aisle</Value>
</Value>
<Value name="9">
<Value>AmountActual</Value>
</Value>
<Value name="10">
<Value>AmountActualLabor</Value>
</Value>
<Value name="11">
<Value>AmountActualMaterial</Value>
</Value>
<Value name="12">
<Value>AmountChangeToOriginalDollars</Value>
</Value>
<Value name="13">
<Value>AmountEstimated</Value>
</Value>
<Value name="14">
<Value>AmountEstimatedLabor</Value>
</Value>
<Value name="15">
<Value>AmountEstimatedMaterial</Value>
</Value>
<Value name="16">
<Value>AmountEstimatedOther</Value>
</Value>
<Value name="17">
<Value>AmountMemoBudgetChanges</Value>
</Value>
<Value name="18">
<Value>AmountMilesOrHoursunits</Value>
</Value>
<Value name="19">
<Value>ApprovalType</Value>
</Value>
<Value name="20">
<Value>AssetItemNumber</Value>
</Value>
<Value name="21">
<Value>BOMChange</Value>
</Value>
<Value name="22">
<Value>BillOfMaterialN</Value>
</Value>
<Value name="23">
<Value>BillRevisionLevel</Value>
</Value>
<Value name="24">
<Value>Bin</Value>
</Value>
<Value name="25">
<Value>Branch</Value>
</Value>
<Value name="26">
<Value>BusinessUnit</Value>
</Value>
<Value name="27">
<Value>CategoriesWorkOrder01</Value>
</Value>
<Value name="28">
<Value>CategoriesWorkOrder02</Value>
</Value>
<Value name="29">
<Value>CategoriesWorkOrder03</Value>
</Value>
<Value name="30">
<Value>CategoriesWorkOrder04</Value>
</Value>
<Value name="31">
<Value>CategoriesWorkOrder05</Value>
</Value>
<Value name="32">
<Value>CategoriesWorkOrder10</Value>
</Value>
<Value name="33">
<Value>Company</Value>
</Value>
<Value name="34">
<Value>CompanyKeyRelatedOrder</Value>
</Value>
<Value name="35">
<Value>CrewSize</Value>
</Value>
<Value name="36">
<Value>CriticalityWorkOrder</Value>
</Value>
<Value name="37">
<Value>DateAssignedTo</Value>
</Value>
<Value name="38">
<Value>DateAssignedToInspector</Value>
</Value>
<Value name="39">
<Value>DateCompletion</Value>
</Value>
<Value name="40">
<Value>DateOrderTransaction</Value>
</Value>
<Value name="41">
<Value>DatePaperPrintedDate</Value>
</Value>
<Value name="42">
<Value>DateRequested</Value>
</Value>
<Value name="43">
<Value>DateScheduledTickler</Value>
</Value>
<Value name="44">
<Value>DateStart</Value>
</Value>
<Value name="45">
<Value>DateStatusChanged</Value>
</Value>
<Value name="46">
<Value>DateUpdated</Value>
</Value>
<Value name="47">
<Value>DateWOPlannedCompleted</Value>
</Value>
<Value name="48">
<Value>Description</Value>
</Value>
<Value name="49">
<Value>DocumentNumber</Value>
</Value>
<Value name="50">
<Value>DocumentType</Value>
</Value>
<Value name="51">
<Value>DrawingChange</Value>
</Value>
<Value name="52">
<Value>EstimatedDowntimeHours</Value>
</Value>
<Value name="53">
<Value>ExistingDisposition</Value>
</Value>
<Value name="54">
<Value>HoursActual</Value>
</Value>
<Value name="55">
<Value>HoursChangeToOriginalHours</Value>
</Value>
<Value name="56">
<Value>HoursEstimated</Value>
</Value>
<Value name="57">
<Value>HoursUnaccountedDirectLabor</Value>
</Value>
<Value name="58">
<Value>IndentedCode</Value>
</Value>
<Value name="59">
<Value>ItemNumberShort</Value>
</Value>
<Value name="60">
<Value>LeadtimeCumulative</Value>
</Value>
<Value name="61">
<Value>LeadtimeLevel</Value>
</Value>
<Value name="62">
<Value>LineNumber</Value>
</Value>
<Value name="63">
<Value>Location</Value>
</Value>
<Value name="64">
<Value>LotGrade</Value>
</Value>
<Value name="65">
<Value>LotPotency</Value>
</Value>
<Value name="66">
<Value>LotSerialNumber</Value>
</Value>
<Value name="67">
<Value>MessageNumber</Value>
</Value>
<Value name="68">
<Value>MeterPosition</Value>
</Value>
<Value name="69">
<Value>NewPartNumber</Value>
</Value>
<Value name="70">
<Value>NextAddressNumber</Value>
</Value>
<Value name="71">
<Value>NextStatusWO</Value>
</Value>
<Value name="72">
<Value>NumberParentWONumber</Value>
</Value>
<Value name="73">
<Value>OrderSuffix</Value>
</Value>
<Value name="74">
<Value>OrderType</Value>
</Value>
<Value name="75">
<Value>ParentNumber</Value>
</Value>
<Value name="76">
<Value>PayDeductionBenefitType</Value>
</Value>
<Value name="77">
<Value>PegToWorkOrder</Value>
</Value>
<Value name="78">
<Value>PeopleSoftConsultingExperienceLevel</Value>
</Value>
<Value name="79">
<Value>PeopleSoftConsultingServiceType</Value>
</Value>
<Value name="80">
<Value>PeopleSoftConsultingSkillType</Value>
</Value>
<Value name="81">
<Value>PeopleSoftConsultingStatus</Value>
</Value>
<Value name="82">
<Value>PercentComplete</Value>
</Value>
<Value name="83">
<Value>PhaseIn</Value>
</Value>
<Value name="84">
<Value>PostingEdit</Value>
</Value>
<Value name="85">
<Value>PriorityWO</Value>
</Value>
<Value name="86">
<Value>ProgramID</Value>
</Value>
<Value name="87">
<Value>QuantityShipped</Value>
</Value>
<Value name="88">
<Value>RatioCriticalRatioPriority1</Value>
</Value>
<Value name="89">
<Value>RatioCriticalRatioPriority2</Value>
</Value>
<Value name="90">
<Value>ReasonForECO</Value>
</Value>
<Value name="91">
<Value>Reference</Value>
</Value>
<Value name="92">
<Value>Reference2</Value>
</Value>
<Value name="93">
<Value>RelatedPOSOWONumber</Value>
</Value>
<Value name="94">
<Value>RelatedPOSOWOOrderType</Value>
</Value>
<Value name="95">
<Value>ResequenceCode</Value>
</Value>
<Value name="96">
<Value>RevenueRateMarkupOverride</Value>
</Value>
<Value name="97">
<Value>RouteSheetN</Value>
</Value>
<Value name="98">
<Value>Routing</Value>
</Value>
<Value name="99">
<Value>RoutingChange</Value>
</Value>
<Value name="100">
<Value>RoutingRevisionLevel</Value>
</Value>
<Value name="101">
<Value>ServiceAddressNumber</Value>
</Value>
<Value name="102">
<Value>StatusCodeWO</Value>
</Value>
<Value name="103">
<Value>StatusComment</Value>
</Value>
<Value name="104">
<Value>SubledgerInactiveCode</Value>
</Value>
<Value name="105">
<Value>Subsidiary</Value>
</Value>
<Value name="106">
<Value>Supervisor</Value>
</Value>
<Value name="107">
<Value>TimeBeginningHHMMSS</Value>
</Value>
<Value name="108">
<Value>TimeOfDay</Value>
</Value>
<Value name="109">
<Value>TypeBillOfMaterial</Value>
</Value>
<Value name="110">
<Value>TypeOfRouting</Value>
</Value>
<Value name="111">
<Value>TypeWO</Value>
</Value>
<Value name="112">
<Value>UnitOfMeasureasInput</Value>
</Value>
<Value name="113">
<Value>UnitOrTagNumber</Value>
</Value>
<Value name="114">
<Value>UnitsOrderTransactionQuantity</Value>
</Value>
<Value name="115">
<Value>UnitsQtyBackorderedHeld</Value>
</Value>
<Value name="116">
<Value>UnitsQuantityCanceledScrapped</Value>
</Value>
<Value name="117">
<Value>UnitsShippedToDate</Value>
</Value>
<Value name="118">
<Value>UserID</Value>
</Value>
<Value name="119">
<Value>UserReservedAmount</Value>
</Value>
<Value name="120">
<Value>UserReservedCode</Value>
</Value>
<Value name="121">
<Value>UserReservedDate</Value>
</Value>
<Value name="122">
<Value>UserReservedNumber</Value>
</Value>
<Value name="123">
<Value>UserReservedReference</Value>
</Value>
<Value name="124">
<Value>VarianceFlag</Value>
</Value>
<Value name="125">
<Value>WOPickListPrinted</Value>
</Value>
<Value name="126">
<Value>WorkOrderFlashMessage</Value>
</Value>
<Value name="127">
<Value>WorkOrderFreezeCode</Value>
</Value>
<Value name="128">
<Value>WorkStationID</Value>
</Value>
<Value name="129">
<Value>n2ndItemNumber</Value>
</Value>
<Value name="130">
<Value>n3rdItemNumber</Value>
</Value>
</Data>
<DataLocation>^JDE.data.WorkOrdersD</DataLocation>
<DefaultData>WorkOrdersDefaultData</DefaultData>
<IdLocation>^JDE.data.WorkOrdersD</IdLocation>
<IndexLocation>^JDE.data.WorkOrdersI</IndexLocation>
<StreamLocation>^JDE.data.WorkOrdersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}