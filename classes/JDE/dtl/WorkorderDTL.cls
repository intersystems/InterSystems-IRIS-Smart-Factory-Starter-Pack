Class JDE.dtl.WorkorderDTL Extends Ens.DataTransformDTL [ DependsOn = (JDE.msg.incoming.WorkorderRequest, JDE.msg.filtered.WorkorderRequest) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='JDE.msg.incoming.WorkorderRequest' targetClass='JDE.msg.filtered.WorkorderRequest' create='new' language='objectscript' >
<assign value='source.Workorder.OrderType' property='target.Workorder.OrderType' action='set' />
<assign value='source.Workorder.DocumentNumber' property='target.Workorder.DocumentNumber' action='set' />
<assign value='source.Workorder.TypeWO' property='target.Workorder.TypeWO' action='set' />
<assign value='source.Workorder.StatusCodeWO' property='target.Workorder.StatusCodeWO' action='set' />
<assign value='source.Workorder."2ndItemNumber"' property='target.Workorder."2dItemNumber"' action='set' />
<assign value='source.Workorder.Description' property='target.Workorder.Description' action='set' />
<assign value='source.Workorder.PriorityWO' property='target.Workorder.PriorityWO' action='set' />
<assign value='source.Workorder."UnitsOrder_TransactionQuantity"' property='target.Workorder."UnitsOrder_TransactionQuantity"' action='set' />
<assign value='source.Workorder."UnitsQuantityCanceled_Scrapped"' property='target.Workorder."UnitsQuantityCanceled_Scrapped"' action='set' />
<assign value='source.Workorder.QuantityShipped' property='target.Workorder.QuantityShipped' action='set' />
<assign value='source.Workorder."UnitsQtyBackordered_Held"' property='target.Workorder."UnitsQtyBackordered_Held"' action='set' />
<assign value='source.Workorder."DateOrder_Transaction"' property='target.Workorder."DateOrder_Transaction"' action='set' />
<assign value='source.Workorder.DateWOPlannedCompleted' property='target.Workorder.DateWOPlannedCompleted' action='set' />
<assign value='source.Workorder.DateStart' property='target.Workorder.DateStart' action='set' />
<assign value='source.Workorder.DateRequested' property='target.Workorder.DateRequested' action='set' />
<assign value='source.Workorder.UserReservedDate' property='target.Workorder.UserReservedDate' action='set' />
<assign value='source.Workorder.DateCompletion' property='target.Workorder.DateCompletion' action='set' />
<assign value='source.Workorder.LeadtimeLevel' property='target.Workorder.LeadtimeLevel' action='set' />
<assign value='source.Workorder.DateUpdated' property='target.Workorder.DateUpdated' action='set' />
<assign value='source.Workorder.TimeOfDay' property='target.Workorder.TimeOfDay' action='set' />
<assign value='source.Workorder.UserID' property='target.Workorder.UserID' action='set' />
<assign value='source.Workorder.ProgramID' property='target.Workorder.ProgramID' action='set' />
<assign value='source.Workorder.DocumentType' property='target.Workorder.DocumentType' action='set' />
<assign value='source.Workorder.Company' property='target.Workorder.Company' action='set' />
<assign value='source.Workorder.BusinessUnit' property='target.Workorder.BusinessUnit' action='set' />
<assign value='source.Workorder.Branch' property='target.Workorder.Branch' action='set' />
<assign value='source.Workorder.DateStatusChanged' property='target.Workorder.DateStatusChanged' action='set' />
<assign value='source.Workorder.AddressNumberOriginator' property='target.Workorder.AddressNumberOriginator' action='set' />
<assign value='source.Workorder.ItemNumberShort' property='target.Workorder.ItemNumberShort' action='set' />
<assign value='source.Workorder."3rdItemNumber"' property='target.Workorder."3rdItemNumber"' action='set' />
<assign value='source.Workorder.UnitOfMeasureasInput' property='target.Workorder.UnitOfMeasureasInput' action='set' />
<assign value='source.Workorder.TypeBillOfMaterial' property='target.Workorder.TypeBillOfMaterial' action='set' />
<assign value='source.Workorder.TypeOfRouting' property='target.Workorder.TypeOfRouting' action='set' />
<assign value='source.Workorder.WorkOrderFlashMessage' property='target.Workorder.WorkOrderFlashMessage' action='set' />
<assign value='source.Workorder.CategoriesWorkOrder01' property='target.Workorder.CategoriesWorkOrder01' action='set' />
<assign value='source.Workorder.CategoriesWorkOrder03' property='target.Workorder.CategoriesWorkOrder03' action='set' />
<assign value='source.Workorder.WorkOrderFreezeCode' property='target.Workorder.WorkOrderFreezeCode' action='set' />
<foreach property='source.Workorder.Routing()' key='k1' >
<assign value='##class(JDE.data.filtered.Routing).%New()' property='routing' action='set' />
<assign value='source.Workorder.Routing.(k1).DocumentNumber' property='routing.DocumentNumber' action='set' />
<assign value='source.Workorder.Routing.(k1).OrderType' property='routing.OrderType' action='set' />
<assign value='source.Workorder.Routing.(k1).Kit2ndItemNumber' property='routing.Kit2ndItemNumber' action='set' />
<assign value='source.Workorder.Routing.(k1).SequenceNumberOperations' property='routing.SequenceNumberOperations' action='set' />
<assign value='source.Workorder.Routing.(k1).UserReservedCode' property='routing.UserReservedCode' action='set' />
<assign value='source.Workorder.Routing.(k1).BusinessUnit' property='routing.BusinessUnit' action='set' />
<assign value='source.Workorder.Routing.(k1).Description' property='routing.Description' action='set' />
<assign value='source.Workorder.Routing.(k1).MessageNumber' property='routing.MessageNumber' action='set' />
<assign value='source.Workorder.Routing.(k1)."DateOrder_Transaction"' property='routing."DateOrder_Transaction"' action='set' />
<assign value='source.Workorder.Routing.(k1).DateStart' property='routing.DateStart' action='set' />
<assign value='source.Workorder.Routing.(k1)."TimeScheduledStart_HH_MM_SS"' property='routing."TimeScheduledStart_HH_MM_SS"' action='set' />
<assign value='source.Workorder.Routing.(k1).DateRequested' property='routing.DateRequested' action='set' />
<assign value='source.Workorder.Routing.(k1)."TimeScheduledEnd_HH_MM_SS"' property='routing."TimeScheduledEnd_HH_MM_SS"' action='set' />
<assign value='source.Workorder.Routing.(k1).OperationStatusCodeWO' property='routing.OperationStatusCodeWO' action='set' />
<assign value='source.Workorder.Routing.(k1).DateCompletion' property='routing.DateCompletion' action='set' />
<assign value='source.Workorder.Routing.(k1)."UnitsOrder_TransactionQuantity"' property='routing."UnitsOrder_TransactionQuantity"' action='set' />
<assign value='source.Workorder.Routing.(k1).UnitsQuantityatOperation' property='routing.UnitsQuantityatOperation' action='set' />
<assign value='source.Workorder.Routing.(k1).QuantityShipped' property='routing.QuantityShipped' action='set' />
<assign value='source.Workorder.Routing.(k1)."UnitsQuantityCanceled_Scrapped"' property='routing."UnitsQuantityCanceled_Scrapped"' action='set' />
<assign value='source.Workorder.Routing.(k1).TypeOfRouting' property='routing.TypeOfRouting' action='set' />
<assign value='source.Workorder.Routing.(k1)."Parent_ShortItemNumber"' property='routing."Parent_ShortItemNumber"' action='set' />
<assign value='source.Workorder.Routing.(k1).Branch' property='routing.Branch' action='set' />
<assign value='source.Workorder.Routing.(k1)."3rdItemNumberKit"' property='routing."3rdItemNumberKit"' action='set' />
<assign value='source.Workorder.Routing.(k1).DateUpdated' property='routing.DateUpdated' action='set' />
<assign value='source.Workorder.Routing.(k1).TimeOfDay' property='routing.TimeOfDay' action='set' />
<assign value='source.Workorder.Routing.(k1).UserID' property='routing.UserID' action='set' />
<assign value='source.Workorder.Routing.(k1).ProgramID' property='routing.ProgramID' action='set' />
<assign value='source.Workorder.Routing.(k1).TimeBasisCode' property='routing.TimeBasisCode' action='set' />
<assign value='source.Workorder.Routing.(k1).HoursSetupLaborHoursActual' property='routing.HoursSetupLaborHoursActual' action='set' />
<assign value='source.Workorder.Routing.(k1).RunMachineStandard' property='routing.RunMachineStandard' action='set' />
<assign value='source.Workorder.Routing.(k1).MoveHoursStandard' property='routing.MoveHoursStandard' action='set' />
<assign value='source.Workorder.Routing.(k1).QueueHoursStandard' property='routing.QueueHoursStandard' action='set' />
<assign value='source.Workorder.Routing.(k1).AddressNumber' property='routing.AddressNumber' action='set' />
<assign value='source.Workorder.Routing.(k1).PercentOperationalPlannedYield' property='routing.PercentOperationalPlannedYield' action='set' />
<assign value='source.Workorder.Routing.(k1).PercentCumulativePlannedYield' property='routing.PercentCumulativePlannedYield' action='set' />
<assign value='source.Workorder.Routing.(k1).RunLaborStandard' property='routing.RunLaborStandard' action='set' />
<assign value='source.Workorder.Routing.(k1).SetupLaborStandard' property='routing.SetupLaborStandard' action='set' />
<assign value='source.Workorder.Routing.(k1).CrewSize' property='routing.CrewSize' action='set' />
<assign value='source.Workorder.Routing.(k1).UnitOfMeasureAsInput' property='routing.UnitOfMeasureAsInput' action='set' />
<assign value='source.Workorder.Routing.(k1).DocumentType' property='routing.DocumentType' action='set' />
<assign value='source.Workorder.Routing.(k1).Workorder' property='routing.Workorder' action='set' />
<assign value='target.Workorder.Routing.Insert(routing)' property='st' action='set' />
</foreach>
<trace value='"DTL says: Filtered workorder "_source.Workorder.DocumentNumber_"; "_target.Workorder.Routing.Count()_" routing"_$case(target.Workorder.Routing.Count(),1:"",:"s")_" processed"' />
</transform>
}

}
