/// JDE routing.
Class JDE.data.Routing Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property DocumentNumber As %Integer;

Property OrderType As %String;

Property Kit2ndItemNumber As %String;

Property SequenceNumberOperations As %Double;

Property UserReservedCode As %String;

Property BusinessUnit As %String;

Property Description As %String;

Property MessageNumber As %String;

Property DateOrderTransaction As %String(%JSONFIELDNAME = "DateOrder_Transaction");

Property DateStart As %String;

Property TimeScheduledStartHHMMSS As %Integer(%JSONFIELDNAME = "TimeScheduledStart_HH_MM_SS");

Property DateRequested As %String;

Property TimeScheduledEndHHMMSS As %Integer(%JSONFIELDNAME = "TimeScheduledEnd_HH_MM_SS");

Property OperationStatusCodeWO As %String;

Property DateCompletion As %String;

Property UnitsOrderTransactionQuantity As %Double(%JSONFIELDNAME = "UnitsOrder_TransactionQuantity");

Property UnitsQuantityatOperation As %Double;

Property QuantityShipped As %Double;

Property UnitsQuantityCanceledScrapped As %Double(%JSONFIELDNAME = "UnitsQuantityCanceled_Scrapped");

Property TypeOfRouting As %String;

Property ParentShortItemNumber As %Integer(%JSONFIELDNAME = "Parent_ShortItemNumber");

Property Branch As %String;

Property ThirdItemNumberKit As %String(%JSONFIELDNAME = "3rdItemNumberKit");

Property DateUpdated As %String;

Property TimeOfDay As %Integer;

Property UserID As %String;

Property ProgramID As %String;

Property TimeBasisCode As %String;

Property HoursSetupLaborHoursActual As %Double;

Property RunMachineStandard As %Double;

Property MoveHoursStandard As %Double;

Property QueueHoursStandard As %Double;

Property AddressNumber As %Integer;

Property PercentOperationalPlannedYield As %Double;

Property PercentCumulativePlannedYield As %Double;

Property RunLaborStandard As %Double;

Property SetupLaborStandard As %Double;

Property CrewSize As %Double;

Property UnitOfMeasureAsInput As %String;

Property DocumentType As %String;

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
<Value>Kit2ndItemNumber</Value>
</Value>
<Value name="5">
<Value>SequenceNumberOperations</Value>
</Value>
<Value name="6">
<Value>UserReservedCode</Value>
</Value>
<Value name="7">
<Value>BusinessUnit</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
<Value name="9">
<Value>MessageNumber</Value>
</Value>
<Value name="10">
<Value>DateOrderTransaction</Value>
</Value>
<Value name="11">
<Value>DateStart</Value>
</Value>
<Value name="12">
<Value>TimeScheduledStartHHMMSS</Value>
</Value>
<Value name="13">
<Value>DateRequested</Value>
</Value>
<Value name="14">
<Value>TimeScheduledEndHHMMSS</Value>
</Value>
<Value name="15">
<Value>OperationStatusCodeWO</Value>
</Value>
<Value name="16">
<Value>DateCompletion</Value>
</Value>
<Value name="17">
<Value>UnitsOrderTransactionQuantity</Value>
</Value>
<Value name="18">
<Value>UnitsQuantityatOperation</Value>
</Value>
<Value name="19">
<Value>QuantityShipped</Value>
</Value>
<Value name="20">
<Value>UnitsQuantityCanceledScrapped</Value>
</Value>
<Value name="21">
<Value>TypeOfRouting</Value>
</Value>
<Value name="22">
<Value>ParentShortItemNumber</Value>
</Value>
<Value name="23">
<Value>Branch</Value>
</Value>
<Value name="24">
<Value>ThirdItemNumberKit</Value>
</Value>
<Value name="25">
<Value>DateUpdated</Value>
</Value>
<Value name="26">
<Value>TimeOfDay</Value>
</Value>
<Value name="27">
<Value>UserID</Value>
</Value>
<Value name="28">
<Value>ProgramID</Value>
</Value>
<Value name="29">
<Value>TimeBasisCode</Value>
</Value>
<Value name="30">
<Value>HoursSetupLaborHoursActual</Value>
</Value>
<Value name="31">
<Value>RunMachineStandard</Value>
</Value>
<Value name="32">
<Value>MoveHoursStandard</Value>
</Value>
<Value name="33">
<Value>QueueHoursStandard</Value>
</Value>
<Value name="34">
<Value>AddressNumber</Value>
</Value>
<Value name="35">
<Value>PercentOperationalPlannedYield</Value>
</Value>
<Value name="36">
<Value>PercentCumulativePlannedYield</Value>
</Value>
<Value name="37">
<Value>RunLaborStandard</Value>
</Value>
<Value name="38">
<Value>SetupLaborStandard</Value>
</Value>
<Value name="39">
<Value>CrewSize</Value>
</Value>
<Value name="40">
<Value>UnitOfMeasureAsInput</Value>
</Value>
<Value name="41">
<Value>DocumentType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Routing")</DataLocation>
<DefaultData>RoutingDefaultData</DefaultData>
<IdLocation>^JDE.data.WorkorderC("Routing")</IdLocation>
<IndexLocation>^JDE.data.RoutingI</IndexLocation>
<StreamLocation>^JDE.data.RoutingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
