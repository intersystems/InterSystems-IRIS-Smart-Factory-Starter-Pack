/// JDE workorders.
Class JDE.data.Workorder Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property OrderType As %String;

Property DocumentNumber As %Integer;

Property TypeWO As %String;

Property StatusCodeWO As %String;

Property SecondItemNumber As %String(%JSONFIELDNAME = "2dItemNumber");

Property Description As %String;

Property PriorityWO As %String;

Property UnitsOrderTransactionQuantity As %Double(%JSONFIELDNAME = "UnitsOrder_TransactionQuantity");

Property UnitsQuantityCanceledScrapped As %Double(%JSONFIELDNAME = "UnitsQuantityCanceled_Scrapped");

Property QuantityShipped As %Double;

Property UnitsQtyBackorderedHeld As %Double(%JSONFIELDNAME = "UnitsQtyBackordered_Held");

Property DateOrderTransaction As %String(%JSONFIELDNAME = "DateOrder_Transaction");

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

Property ThirdItemNumber As %String(%JSONFIELDNAME = "3rdItemNumber");

Property UnitOfMeasureasInput As %String;

Property TypeBillOfMaterial As %String;

Property TypeOfRouting As %String;

Property WorkOrderFlashMessage As %String;

Property CategoriesWorkOrder01 As %String;

Property CategoriesWorkOrder03 As %String;

Property WorkOrderFreezeCode As %String;

Relationship Routing As Routing [ Cardinality = children, Inverse = Workorder ];

Index DocumentNumberIndex On DocumentNumber;

Index DocumentDateTimeUpdated On (DocumentNumber, DateUpdated, TimeOfDay) [ Unique ];

/// Helper function to migrate workorders from the un-indexed version in JDE.data.filtered.Workorder to this class.
/// Converts at most 1000 records at a time to avoid overflowing the journal.
ClassMethod Migrate(maxRecords As %Integer = 1000) As %Status
{
	set qry = "SELECT DISTINCT DocumentNumber, DateUpdated, TimeOfDay FROM JDE_data_filtered.Workorder"
	set stm = ##class(%SQL.Statement).%New()
	set st = stm.%Prepare(qry)
	if st'=1 quit st
	set rs = stm.%Execute()
	set n = 0
	while (rs.%Next()&&(n<maxRecords)) {
		set doc = rs.%Get("DocumentNumber")
		set dat = rs.%Get("DateUpdated")
		set tod = rs.%Get("TimeOfDay")
		set id = ""
		&sql(SELECT TOP 1 ID INTO :id FROM JDE_data_filtered.Workorder WHERE DocumentNumber = :doc AND DateUpdated = :dat AND TimeOfDay = :tod)
		if id {
			write "Trying ID ",id,!
			set recIn = ##class(JDE.data.filtered.Workorder).%OpenId(id)
			set st = recIn.%JSONExportToString(.json)
			if st'=1 quit
			set recOut = ##class(JDE.data.Workorder).%New()
			set st = recOut.%JSONImport(json)
			if st'=1 quit
			set st = recOut.%Save()
			if st'=1 {
				set err = $system.Status.GetErrorCodes(st)
				if err'=5808 quit
			} else {
				set n = n + 1
			}
		}
	}
	write n," records migrated",!
	quit st
}

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
<Value>TypeWO</Value>
</Value>
<Value name="5">
<Value>StatusCodeWO</Value>
</Value>
<Value name="6">
<Value>SecondItemNumber</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>PriorityWO</Value>
</Value>
<Value name="9">
<Value>UnitsOrderTransactionQuantity</Value>
</Value>
<Value name="10">
<Value>UnitsQuantityCanceledScrapped</Value>
</Value>
<Value name="11">
<Value>QuantityShipped</Value>
</Value>
<Value name="12">
<Value>UnitsQtyBackorderedHeld</Value>
</Value>
<Value name="13">
<Value>DateOrderTransaction</Value>
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
<Value>ThirdItemNumber</Value>
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
<DataLocation>^JDE.data.WorkorderD</DataLocation>
<DefaultData>WorkorderDefaultData</DefaultData>
<IdLocation>^JDE.data.WorkorderD</IdLocation>
<IndexLocation>^JDE.data.WorkorderI</IndexLocation>
<StreamLocation>^JDE.data.WorkorderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
