Include Ensemble

/// Smart Industry datamodel generation API<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.datamodel.spec<br/>
/// Updated Aug 12, 2020 14:24:18
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
	If 'sc return ..ServerError("Error opening equipment '{}'", sc, EquipmentName)
	If Equipment = "" {
		Do ..%SetStatusCode(404)
		Quit ##class(opc.ua.rest.Error).GenerateErrorInJSON(400, "Equipment '"_EquipmentName_"' not found.")
	}
	
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
		Quit ##class(opc.ua.rest.Error).GenerateErrorInJSON(400, "No configurations for '"_EquipmentName_"' found.")
	}
	
	;== Generate Ensemble classes for the equipment (all configurations)
	
	; Generate or update the Ensemble classes
	Set sc = ##class(opc.ua.util.EnsembleGenerator).Generate(Equipment)
	If 'sc Return ..ServerError("Error generating Ensemble classes for Equipment '{}'", sc, EquipmentName)
	
	; Return 201 Created
	Do ..%SetStatusCode(201)
	
	Quit ""
}

/// Generate JSON node definitions from ASD CSV input.<br/>
/// The method arguments hold values for:<br/>
///     input, CSV input.<br/>
///     namespace, Namepace to use in opc_ua_node field of Node definition.<br/>
///     machine_name, Machine name to use in opc_ua_node field of Node definition.<br/>
ClassMethod NodeGeneration(input As %Stream.Object, namespace As %String, machinename As %String) As %DynamicObject
{
	Set Result = ##class(%Stream.TmpCharacter).%New()
	
	; Default line terminator is $c(13, 10); if posted with $c(10) we
	; get one single line. Prevent this, we'll strip the $c(13) below.
	Set input.LineTerminator = $c(10)
	
	; Open array
	Do Result.Write("[")
	
	Set (LineCount,ObjCount) = 0
	While 'input.AtEnd {
		Set Line = $ZStrip(input.ReadLine(), "<>WC")
		Set LineCount = LineCount + 1
		If Line = "" Continue
		
		Set Name = $Piece($Piece(Line, ",", 1), "=", 1)
		Set DataType = $Piece(Line, ",", 2)
		
		; If the datatype has an integer width/precision spec, remove it
		If $Locate(DataType, "[^\d]+", 1, , DataType) {}
		
		Set Node = ##class(opc.ua.config.Node).%New()
		Set Node.GUID = ""
		Set Node.Name = Name
		Set Node.DisplayName = Name
		Set Node.NodeId = "ns="_namespace_";s="_machinename_"."_Name
		Set Node.DatabaseAttribute = Name
		Set Node.DatabaseType = $Case(DataType,
		  "Real": "float",
		  "Int": "integer",
		  "DInt": "integer",
		  "X": "string",
		  : "")
		
		If Node.DatabaseType = "" {
			Do ..%SetStatusCode(400)
			Return {"error":("Unknown datatype '"_DataType_"' on line "_LineCount_".")}
		}
		
		; Write object separator comma
		If $Increment(ObjCount) > 1 Do Result.Write(",")
		
		; Convert to the Node JSON format and write to result
		Do Node.%JSONExportToStream(Result)
	}
	
	; Close array
	Do Result.Write("]")
	
	Quit Result
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
