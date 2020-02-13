Include Ensemble

/// This is an OPC UA server callback service of InterSystems. This functionality is used when data notifications from subscriptions needs to be inserted in InterSystems<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.spec<br/>
/// Updated Feb 10, 2020 14:56:43
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
	Set $ZTrap = "Error"
	
	/// Check content type
	if ..%GetContentType() '= "application/json" {
		return ..ReturnError(405, "Only application/json content-type allowed")
	}	
	
	; Get the equipment/configuration bridge class instance
	#dim EquipCfg As opc.ua.config.EquipmentConfiguration
	set EquipCfg = ##class(opc.ua.config.EquipmentConfiguration).Get(equipment, "staging", configuration)
	if EquipCfg = "" {
		return ..ReturnError(404, "Combo of equipment ["_equipment_"]/config ["_configuration_"] not found")
	}
	
	; Get classname and check whether it exists
	set ClassName = ##class(opc.ua.data.Generator).GetClassName(EquipCfg, .Exists)
	if 'Exists return ..ReturnError(404, "Class '"_ClassName_"' not found", "No class for EquipmentConfig "_EquipCfg.%Id())
	
	; Get data in generated REST class
	set tData = ##class(opc.ua.rest.Data).%New()
	set sc = tData.%JSONImport(body)
	if $$$ISERR(sc) return ..ReturnError(400, "Problem importing data", "Error loading input data", sc)
	
	/// Insert the data
	set sc = $classmethod(ClassName, "Insert", tData, .RowId)
	if $$$ISERR(sc) return ..ReturnError(500, "Problem storing data", "Error saving input data", sc)
	
	/// Create Business Service
	#dim bs As opc.ua.service.DataService
	set sc = ##class(Ens.Director).CreateBusinessService(EquipCfg.Equipment.Name_"Data", .bs)
	if $$$ISERR(sc) return ..ReturnError(500, "Problem creating business service", "Error creating business service", sc)
	
	; Send the data to next stage
	Set sc = bs.SendData(RowId)
	if $$$ISERR(sc) return ..ReturnError(500, "Problem sending data", "Error sending data", sc)
	
	; All went well, return HTTP status "201 Created"
	do ..%SetStatusCode("201")
		
	return ""
	
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", "Error trapped: "_$ZError)
}

// =====

/// Returns an error to the caller. If ErrorStatus and/or LogMsg are specified,
/// this information is logged in the Ensemble event log.
ClassMethod ReturnError(HttpStatus As %String = "500", ReturnMsg As %String = "", ErrorStatus As %Status = "", LogMsg As %String = "") As %DynamicObject
{
	do ..%SetStatusCode(HttpStatus)
	
	; Add additional information, if present, to the event log
	if ErrorStatus '= "" {
		if LogMsg '= "" set LogMsg = LogMsg_": "
		set LogMsg = LogMsg_$System.Status.GetErrorText(ErrorStatus)
	}
	if LogMsg '= "" {
		$$$LOGWARNING(LogMsg)
	}
	
	set Msg = ##class(opc.ua.rest.Error).GenerateErrorInJSON(HttpStatus, ReturnMsg)
	
	return Msg
}

}
