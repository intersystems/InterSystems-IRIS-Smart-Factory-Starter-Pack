Class JDE.data.filtered.Workorder Extends (%Persistent, %XML.Adaptor)
{

Property OrderType As %String;

Property DocumentNumber As %Integer;

Property TypeWO As %String;

Property StatusCodeWO As %String;

Property "2dItemNumber" As %String;

Property Description As %String;

Property PriorityWO As %String;

Property "UnitsOrder_TransactionQuantity" As %Double;

Property "UnitsQuantityCanceled_Scrapped" As %Double;

Property QuantityShipped As %Double;

Property "UnitsQtyBackordered_Held" As %Double;

Property "DateOrder_Transaction" As %String;

Property DateWOPlannedCompleted As %String;

Property DateStart As %String;

Property DateRequested As %String;

Property UserReservedDate As %String;

Property DateCompletion As %String;

Property LeadtimeLevel As %Integer;

Property DateUpdated As %String;

Property TimeOfDay As %Integer;

Property UserID As %String;

Property ProgramID As %String;

Property DocumentType As %String;

Property Company As %String;

Property BusinessUnit As %String;

Property Branch As %String;

Property DateStatusChanged As %String;

Property AddressNumberOriginator As %Integer;

Property ItemNumberShort As %Integer;

Property "3rdItemNumber" As %String;

Property UnitOfMeasureasInput As %String;

Property TypeBillOfMaterial As %String;

Property TypeOfRouting As %String;

Property WorkOrderFlashMessage As %String;

Property CategoriesWorkOrder01 As %String;

Property CategoriesWorkOrder03 As %String;

Property WorkOrderFreezeCode As %String;

Relationship Routing As Routing [ Cardinality = children, Inverse = Workorder ];

Storage Default
{
<Data name="WorkorderDefaultData">
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
<Value>TypeWO</Value>
</Value>
<Value name="5">
<Value>StatusCodeWO</Value>
</Value>
<Value name="6">
<Value>2dItemNumber</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>PriorityWO</Value>
</Value>
<Value name="9">
<Value>UnitsOrder_TransactionQuantity</Value>
</Value>
<Value name="10">
<Value>UnitsQuantityCanceled_Scrapped</Value>
</Value>
<Value name="11">
<Value>QuantityShipped</Value>
</Value>
<Value name="12">
<Value>UnitsQtyBackordered_Held</Value>
</Value>
<Value name="13">
<Value>DateOrder_Transaction</Value>
</Value>
<Value name="14">
<Value>DateWOPlannedCompleted</Value>
</Value>
<Value name="15">
<Value>DateStart</Value>
</Value>
<Value name="16">
<Value>DateRequested</Value>
</Value>
<Value name="17">
<Value>UserReservedDate</Value>
</Value>
<Value name="18">
<Value>DateCompletion</Value>
</Value>
<Value name="19">
<Value>LeadtimeLevel</Value>
</Value>
<Value name="20">
<Value>DateUpdated</Value>
</Value>
<Value name="21">
<Value>TimeOfDay</Value>
</Value>
<Value name="22">
<Value>UserID</Value>
</Value>
<Value name="23">
<Value>ProgramID</Value>
</Value>
<Value name="24">
<Value>DocumentType</Value>
</Value>
<Value name="25">
<Value>Company</Value>
</Value>
<Value name="26">
<Value>BusinessUnit</Value>
</Value>
<Value name="27">
<Value>Branch</Value>
</Value>
<Value name="28">
<Value>DateStatusChanged</Value>
</Value>
<Value name="29">
<Value>AddressNumberOriginator</Value>
</Value>
<Value name="30">
<Value>ItemNumberShort</Value>
</Value>
<Value name="31">
<Value>3rdItemNumber</Value>
</Value>
<Value name="32">
<Value>UnitOfMeasureasInput</Value>
</Value>
<Value name="33">
<Value>TypeBillOfMaterial</Value>
</Value>
<Value name="34">
<Value>TypeOfRouting</Value>
</Value>
<Value name="35">
<Value>WorkOrderFlashMessage</Value>
</Value>
<Value name="36">
<Value>CategoriesWorkOrder01</Value>
</Value>
<Value name="37">
<Value>CategoriesWorkOrder03</Value>
</Value>
<Value name="38">
<Value>WorkOrderFreezeCode</Value>
</Value>
</Data>
<DataLocation>^JDE.data.filtered.WorkorderD</DataLocation>
<DefaultData>WorkorderDefaultData</DefaultData>
<IdLocation>^JDE.data.filtered.WorkorderD</IdLocation>
<IndexLocation>^JDE.data.filtered.WorkorderI</IndexLocation>
<StreamLocation>^JDE.data.filtered.WorkorderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
