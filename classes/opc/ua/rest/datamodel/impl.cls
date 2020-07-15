Include Ensemble

/// Smart Industry datamodel generation API<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.datamodel.spec<br/>
/// Updated Jul 15, 2020 10:15:52
Class opc.ua.rest.datamodel.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// Generate a new or update existing datamodels based on all configurations of the equipment<br/>
/// The method arguments hold values for:<br/>
///     body, Datamodel generation<br/>
ClassMethod PostDataModelGeneration(body As %DynamicObject) As %DynamicObject
{
	Set Equipment = body."equipment_name"
	Set Config = body."configuration_name"
	
	If Config '= "" {
		;== Generate data classes for a given equipment+configuration
		
		; Get all equipment configurations matching the specification (should be only one)
		Set stm = ##class(%SQL.Statement).%New()
		Set sc = stm.%PrepareClassQuery("opc.ua.config.EquipmentConfiguration", "ByEquipmentCfg")
		If 'sc Quit ..ServerError("Error preparing query for '{}'/'{}'", sc, Equipment, Config)
		#dim rs As %SQL.StatementResult
		Set rs = stm.%Execute(Equipment, Config)
		
		Set Count = 0
		While rs.%Next() {
			Set Count = Count + 1
			Set Id = rs.%Get("ID")
			Set sc = ##class(opc.ua.data.Generator).Generate(Id)
			If 'sc Return ..ServerError("Error generating data classes for EquipmentConfiguration '{}'", sc, Id)
		}
		If 'Count {
			; Combination not found
			Do ..%SetStatusCode(404)
			Quit ""
		}
	
	} Else {
		;== Generate Ensemble classes for the equipment (all configurations)
		
		; Get equipment id
		If '##class(opc.ua.config.Equipment).EquipmentNameIndexExists(Equipment, .EquipId) {
			Do ..%SetStatusCode(404)
			Quit ""
		}
		
		; Generate or update the Ensemble classes
		Set sc = ##class(opc.ua.util.EnsembleGenerator).Generate(EquipId)
		If 'sc Return ..ServerError("Error generating Ensemble classes for Equipment '{}'", sc, EquipId)
	}
	
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
