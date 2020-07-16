Include Ensemble

/// Smart Industry datamodel generation API<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.datamodel.spec<br/>
/// Updated Jul 16, 2020 15:52:10
Class opc.ua.rest.datamodel.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// Generate a new or update existing datamodels based on all configurations of the equipment<br/>
/// The method arguments hold values for:<br/>
///     body, Datamodel generation<br/>
ClassMethod PostDataModelGeneration(body As %DynamicObject) As %DynamicObject
{
	Set EquipmentName = body."equipment_name"
	
	;== Generate data classes for all equipment+configuration
	
	#dim Equipment As opc.ua.config.Equipment
	Set Equipment = ##class(opc.ua.config.Equipment).SearchByName(EquipmentName, .sc)
	If Equipment = "" return ..ServerError("Error opening equipment '{}'", sc, EquipmentName)
	
	; Generate the data classes
	Set key = "", Count = 0
	For  {
		Set EquipConfig = Equipment.EquipmentConfiguration.GetNext(.key)
		If key = "" Quit
		
		Set Count = Count + 1
		Set sc = ##class(opc.ua.data.Generator).Generate(EquipConfig)
		If 'sc Return ..ServerError("Error generating data classes for EquipmentConfiguration '{}'", sc, EquipConfig.%Id())
	}
	If Count = 0 {
		; No configurations for this equipment
		Do ..%SetStatusCode(404)
		Quit ""
	}
	
	;== Generate Ensemble classes for the equipment (all configurations)
	
	; Generate or update the Ensemble classes
	Set sc = ##class(opc.ua.util.EnsembleGenerator).Generate(Equipment)
	If 'sc Return ..ServerError("Error generating Ensemble classes for Equipment '{}'", sc, EquipmentName)
	
	; Return 201 Created
	Do ..%SetStatusCode(201)
	
	Quit ""
}

/// Returns a HTTP 500, and places debugging information in the Ensemble
/// event log. If class parameter ExposeServerExceptions is true, the
/// information is returned as JSON to the caller as well.
ClassMethod ServerError(Message As %String = "", Status As %Status = "", Args... As %String) As %String
{
	Do ..%SetStatusCode(500)
	
	; Check for message arguments, replace if present
	For i = 1:1:$Get(Args) {
		Set Arg = $Get(Args(i))
		Set Message = $Replace(Message, "{}", Arg, , 1)
	}
	Set LogMsg = Message
	
	If 'Status, Status '= "" {
		If LogMsg '= "" Set LogMsg = LogMsg_": "
		Set LogMsg = LogMsg_$System.Status.GetErrorText(Status)
	}
	
	; Place resulting message in event log:
	$$$LOGERROR(LogMsg)
	
	If ..#ExposeServerExceptions {
		; Return as JSON fragment as well
		Quit ##class(opc.ua.rest.Error).GenerateErrorInJSON(500, LogMsg)
	}
	
	Quit ""
}

}
