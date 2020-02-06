Include Ensemble

/// This is an OPC UA server callback service of InterSystems. This functionality is used when data notifications from subscriptions needs to be inserted in InterSystems<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.spec<br/>
/// Updated Feb 3, 2020 13:20:08
Class opc.ua.rest.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// Add a data change notification of the equipment<br/>
/// The method arguments hold values for:<br/>
///     equipment, Name of the equipment<br/>
///     configuration, Name of the active configuration<br/>
///     body, Data notification to be stored for specified equipment<br/>
ClassMethod addDataChangeNotification(equipment As %String, configuration As %String, body As %DynamicObject) As %DynamicObject
{
	
	/// Step 1: Check content type
	if (..%GetContentType() '= "application/json") {
		do ..%SetStatusCode("405")
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"Only application/json content-type allowed")
	}	
	
	/// Step 2: Search the equipment by name
	#dim tEquipment As opc.ua.config.Equipment
	set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(equipment)
	if (tEquipment = "") {
		do ..%SetStatusCode("404")
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(404,"Equipment ["_equipment_"] not found")		
	}
		
	/// Step 3: Search the configuration by name
	#dim tConfiguration As opc.ua.config.Configuration
	set tConfiguration = tEquipment.SearchCurrentConfigurationByName(configuration)
	if (tConfiguration = "") {
		do ..%SetStatusCode("404")
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(404,"Configuration ["_configuration_"] not found")		
	}
	
	/// Step 4: Get class name
	if 'tEquipment.IsClassDefinitionAvailable(tConfiguration.Name) {
		do ..%SetStatusCode("405")
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"ClassDef not found")
	}
		
	set tClassName = tEquipment.GetClassDefinition(tConfiguration.Name)
	set tData = ##class(opc.ua.rest.Data).%New()
	set sc = tData.%JSONImport(body)
	if $$$ISERR(sc) {
		$$$LOGERROR("Error loading input data: "_$System.Status.GetErrorText(sc))
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"Problem importing data")
	}	
	
	/// Step 5: Insert the data
	set sc = $classmethod(tClassName, "Insert", tData, .RowId)
	if $$$ISERR(sc) {
		$$$LOGERROR("Error saving input data: "_$System.Status.GetErrorText(sc))
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"Problem storing data")
	}
	
	set DataObj = $classmethod(tClassName, "%OpenId", RowId,, .sc)
	if $$$ISERR(sc) {
		$$$LOGERROR("Error opening stored data: "_$System.Status.GetErrorText(sc))
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"Problem opening data")
	}
	
	/// Step 6: Send to DataService
	#dim bs As opc.ua.service.DataService
	set sc = ##class(Ens.Director).CreateBusinessService(tEquipment.Name_"Data", .bs)
	if $$$ISERR(sc) {
		$$$LOGERROR("Error creating business service: "_$System.Status.GetErrorText(sc))
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"Problem creating business service")
	}
	
	Set sc = bs.SendData(DataObj)
	if $$$ISERR(sc) {
		$$$LOGERROR("Error sending data: "_$System.Status.GetErrorText(sc))
		return ##class(opc.ua.rest.Error).GenerateErrorInJSON(405,"Problem sending data")
	}
	
	do ..%SetStatusCode("201")	
	return ""
}

}
