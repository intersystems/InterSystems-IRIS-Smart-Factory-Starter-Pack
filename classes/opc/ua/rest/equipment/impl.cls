Include Ensemble

/// Smart Industry equipment configuration<br/>
/// Business logic class defined by OpenAPI in opc.ua.rest.equipment.spec<br/>
/// Updated Jul 16, 2020 13:00:15
Class opc.ua.rest.equipment.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Return all equipments
ClassMethod GetEquipments() As %DynamicObject
{
    set $ZTrap = "Error"
    
    set tEquipmentList = ##class(opc.ua.config.Equipment).GetAllEquipment()
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tEquipmentList, .tResponse) 
    return tResponse
    
Error
	set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Add new equipment definition<br/>
/// The method arguments hold values for:<br/>
///     body, Add new equipment<br/>
ClassMethod PostEquipment(body As %DynamicArray) As %DynamicObject
{
	Set $ZTrap = "Error"
	
    set tSC = ##class(opc.ua.util.JSON).LoadJSONList(body,"opc.ua.config.Equipment",.tEquipmentList)
    if $$$ISERR(tSC) {
		return ..ReturnError(500, "Can not add equipment", tSC)
	}
	
	// start a transaction
 	TSTART
 	    
    for i=1:1:tEquipmentList.Count() {	    
	    set tEquipment = tEquipmentList.GetAt(i)
	    
	    // Check if equipmenttype name already exists
	    if (tEquipment.EquipmentType.Name '= ""){
	    	set tEquipmentType = ##class(opc.ua.config.EquipmentType).SearchByName(tEquipment.EquipmentType.Name)
	    	if (tEquipmentType '= "") set tEquipment.EquipmentType = tEquipmentType
	    }
	    	    
	    // Check if yield name already exists
	    set tYieldList = ##class(%ListOfObjects).%New()  
	    for i=1:1:tEquipment.Yields.Count() {
		    if (tEquipment.Yields.GetAt(i).Name '= "") {
		    	set tYield = ##class(opc.ua.config.Yield).SearchByName(tEquipment.Yields.GetAt(i).Name)
		   		if (tYield '= "") {
			    	do tYieldList.Insert(tYield)
		    	} else {
			    	do tYieldList.Insert(tEquipment.Yields.GetAt(i))
		    	} 
		    }	   		     
	    }	    
	    set tEquipment.Yields = tYieldList
	    
	    set tSC = tEquipment.%Save()
	    if $$$ISERR(tSC) {
		    TROLLBACK
		    return ..ReturnError(500, "Can not add equipment "_tEquipment.Name, tSC)
	    }
    }       
    
    TCOMMIT
    
    do ..%SetStatusCode(201)
    return ""
    
Error
	Set $ZTrap = ""
	TROLLBACK
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Add configuration to the equipment<br/>
/// The method arguments hold values for:<br/>
///     equipment_name<br/>
///     configuration_name<br/>
ClassMethod AddConfigurationToEquipment(equipmentname As %String, configurationname As %String) As %DynamicObject
{
	set $ZTrap = "Error"
	
	if (equipmentname = "") return ..ReturnError(400, "Bad Request", ,"Equipment name required")
	if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")
    
    set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(equipmentname)
	if tEquipment = "" return ..ReturnError(404, "Not Found", ,"Equipment "_equipmentname)
    
    /// Return only the current version of the configuration
    set tConfiguration = ##class(opc.ua.config.Configuration).SearchByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname) 
    
    set tIsConfigInEquipment = ##class(opc.ua.config.Equipment).isConfigurationInEquipment(tEquipment.Name, tConfiguration.Name)
	if 'tIsConfigInEquipment {
		
		/// Add Configuration to Equipment
		set tEquipmentConfiguration = ##class(opc.ua.config.EquipmentConfiguration).%New()
		set tEquipmentConfiguration.Equipment = tEquipment
		set tEquipmentConfiguration.Configuration = tConfiguration
		set tSC = tEquipmentConfiguration.%Save()
		if $$$ISERR(tSC) return ..ReturnError(500, "Can not add configuration "_tConfiguration.Name_" to equipment "_tEquipment.Name, tSC)
	} else {	      
		do ..%SetStatusCode(409)
	}
	
	return ""    
        
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns info for the given equipment name<br/>
/// The method arguments hold values for:<br/>
///     equipment_name<br/>
ClassMethod GetEquipment(equipmentname As %String) As %DynamicObject
{
	set $ZTrap = "Error"
	
	if (equipmentname = "") return ..ReturnError(400, "Bad Request", ,"Equipment name required")
	
	set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(equipmentname)
	if tEquipment = "" return ..ReturnError(404, "Not Found", ,"Equipment "_equipmentname)
    do tEquipment.%JSONExportToString(.tResponse) 
    return tResponse
    
Error
	set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Updates given equipment<br/>
/// The method arguments hold values for:<br/>
///     equipment_name<br/>
///     body, Update the equipment<br/>
ClassMethod PutEquipment(equipmentname As %String, body As %DynamicObject) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (equipmentname = "") return ..ReturnError(400, "Bad Request", ,"Equipment name required")
    
    set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(equipmentname)
	if tEquipment = "" return ..ReturnError(404, "Not Found", ,"Equipment "_equipmentname)
	
	set tSC = tEquipment.%JSONImport(body)
    if $$$ISERR(tSC) return ..ReturnError(400, "Bad Request", ,"Equipment body isn't correct") 
    
    // Check if equipmenttype name already exists
	if (tEquipment.EquipmentType.Name '= ""){
		set tEquipmentType = ##class(opc.ua.config.EquipmentType).SearchByName(tEquipment.EquipmentType.Name)
	    if (tEquipmentType '= "") set tEquipment.EquipmentType = tEquipmentType
	}
	    	    
	// Check if yield name already exists
	set tYieldList = ##class(%ListOfObjects).%New()  
	for i=1:1:tEquipment.Yields.Count() {
		if (tEquipment.Yields.GetAt(i).Name '= "") {
		  	set tYield = ##class(opc.ua.config.Yield).SearchByName(tEquipment.Yields.GetAt(i).Name)
			if (tYield '= "") {
		    	do tYieldList.Insert(tYield)
		   	} else {
		    	do tYieldList.Insert(tEquipment.Yields.GetAt(i))
		   	} 
		}	   		     
	}	    
	set tEquipment.Yields = tYieldList
	    
    set tSC = tEquipment.%Save()
    if $$$ISERR(tSC) return ..ReturnError(500, "Can not update equipment "_tEquipment.Name, tSC)
    
    return "" 	
    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns the specified configuration for the given equipment name<br/>
/// The method arguments hold values for:<br/>
///     equipment_name<br/>
ClassMethod GetEquipmentConfigurations(equipmentname As %String) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (equipmentname = "") return ..ReturnError(400, "Bad Request", ,"Equipment name required")
    
    set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(equipmentname)
	if tEquipment = "" return ..ReturnError(404, "Not Found", ,"Equipment "_equipmentname)
    
    /// Return only the current version of the configuration
    set tConfigurationList = tEquipment.SearchEquipmentConfigurations()    
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tConfigurationList, .tResponse) 
    return tResponse
     
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns the specified configuration for the given equipment name<br/>
/// The method arguments hold values for:<br/>
///     equipment_name<br/>
///     configuration_name<br/>
ClassMethod GetEquipmentConfiguration(equipmentname As %String, configurationname As %String) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (equipmentname = "") return ..ReturnError(400, "Bad Request", ,"Equipment name required")
    if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")
    
    set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(equipmentname)
	if tEquipment = "" return ..ReturnError(404, "Not Found", ,"Equipment "_equipmentname)
    
    /// Return only the current version of the configuration
    set tConfiguration = tEquipment.SearchCurrentConfigurationByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname) 
    
    do tConfiguration.%JSONExportToString(.tResponse)  
	return tResponse
    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns all configurations
ClassMethod GetConfigurations() As %DynamicObject
{
    set $ZTrap = "Error"
    
    set tConfigurationList = ##class(opc.ua.config.Configuration).GetAllConfigurations()
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tConfigurationList, .tResponse) 
    return tResponse
    
Error
	set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Add new configuration<br/>
/// The method arguments hold values for:<br/>
///     body, Add new configuration<br/>
ClassMethod PostConfigurations(body As %DynamicArray) As %DynamicObject
{
    Set $ZTrap = "Error"
         	
    set tSC= ##class(opc.ua.util.JSON).LoadJSONList(body,"opc.ua.config.Configuration",.tConfigurationList)
    if $$$ISERR(tSC) {
		return ..ReturnError(500, "Can not add configuration", tSC)
	}
	
	// start a transaction
 	TSTART
	
    for i=1:1:tConfigurationList.Count() {	    
	    set tConfiguration = tConfigurationList.GetAt(i)	    
	    set tSC = tConfiguration.%Save()
	    if $$$ISERR(tSC) {
		    TROLLBACK
		    return ..ReturnError(500, "Can not add configuration "_tConfiguration.Name, tSC)
	    }
    }       
    
    TCOMMIT
    
    do ..%SetStatusCode(201)
    return ""
    
Error
	Set $ZTrap = ""
	TROLLBACK
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns configuration for specified name<br/>
/// The method arguments hold values for:<br/>
///     configuration_name<br/>
ClassMethod GetConfiguration(configurationname As %String) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")
     
    set tConfiguration = ##class(opc.ua.config.Configuration).SearchByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname)    
    do tConfiguration.%JSONExportToString(.tResponse)  
	return tResponse
    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", "Error trapped: "_$ZError)
}

/// Updates given configuration<br/>
/// The method arguments hold values for:<br/>
///     configuration_name<br/>
///     body, Update the Configuration<br/>
ClassMethod PutConfiguration(configurationname As %String, body As %DynamicObject) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")    
    
    set tConfiguration = ##class(opc.ua.config.Configuration).SearchByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname)
    
    set tSC = tConfiguration.%JSONImport(body)
    if $$$ISERR(tSC) return ..ReturnError(400, "Bad Request", ,"Configuration body isn't correct") 
    
    set tSC = tConfiguration.%Save()
    if $$$ISERR(tSC) return ..ReturnError(500, "Can not update configuration "_tConfiguration.Name, tSC)
    
    return "" 
    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns list of nodes for the given configuration<br/>
/// The method arguments hold values for:<br/>
///     configuration_name<br/>
ClassMethod GetNodesForConfiguration(configurationname As %String) As %DynamicObject
{
    Set $ZTrap = "Error"
        
    if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")    
    
    set tConfiguration = ##class(opc.ua.config.Configuration).SearchByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname) 
    
    set tNodeList = ##class(opc.ua.config.Configuration).GetNodes(configurationname)
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tNodeList, .tResponse)    	
    return tResponse 
	    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Add the specified node to the configuration<br/>
/// The method arguments hold values for:<br/>
///     configuration_name<br/>
///     node_id<br/>
ClassMethod AddNodeToConfiguration(configurationname As %String, nodeid As %String) As %DynamicObject
{
    Set $ZTrap = "Error"
        
    if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")
    if (nodeid = "") return ..ReturnError(400, "Bad Request", ,"Node identifier required")      
    
    set tConfiguration = ##class(opc.ua.config.Configuration).SearchByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname) 
    
    set tNode = ##class(opc.ua.config.Node).SearchByGUID(nodeid)
    if tNode = "" return ..ReturnError(404, "Not Found", ,"Node "_nodeid)
    
    set tIsNodeInConfig = ##class(opc.ua.config.Configuration).isNodeInConfiguration(tConfiguration.Name, tNode.GUID)
	if 'tIsNodeInConfig {
		
		/// Add Node to Config
		set tConfigurationNode = ##class(opc.ua.config.ConfigurationNode).%New()
		set tConfigurationNode.Configuration = tConfiguration
		set tConfigurationNode.Node = tNode
		set tSC = tConfigurationNode.%Save()
		if $$$ISERR(tSC) return ..ReturnError(500, "Can not add node "_tNode.GUID_" to configuration "_tConfiguration.Name, tSC)
	} else {	      
		do ..%SetStatusCode(409)
	}
	
	return ""
    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Add nodes to the configuration<br/>
/// The method arguments hold values for:<br/>
///     configuration_name<br/>
///     body, Add new nodes to the configuration<br/>
ClassMethod PostConfigurationNodes(configurationname As %String, body As %DynamicArray) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (configurationname = "") return ..ReturnError(400, "Bad Request", ,"Configuration name required")
    
    set tConfiguration = ##class(opc.ua.config.Configuration).SearchByName(configurationname)
    if tConfiguration = "" return ..ReturnError(404, "Not Found", ,"Configuration "_configurationname) 
             	
    set tSC= ##class(opc.ua.util.JSON).LoadJSONList(body,"opc.ua.config.Node",.tNodeList)
    if $$$ISERR(tSC) {
		return ..ReturnError(500, "Can not add nodes to configuration "_configurationname, tSC)
	}
	
	// start a transaction
 	TSTART
	
    for i=1:1:tNodeList.Count() {	    
	    set tNode = tNodeList.GetAt(i)	    	    
	    set tSC = tNode.%Save()
	    
	    set tConfigurationNode = ##class(opc.ua.config.ConfigurationNode).%New()
	    set tConfigurationNode.Configuration = tConfiguration
	    set tConfigurationNode.Node = tNode
	    set tSC= tConfigurationNode.%Save()
	    
	    if $$$ISERR(tSC) {
		    TROLLBACK
		    return ..ReturnError(500, "Can not add nodes to configuration "_configurationname, tSC)
	    }
    }       
    
    TCOMMIT
    
    do ..%SetStatusCode(201)
    return ""
    
Error
	Set $ZTrap = ""
	TROLLBACK
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Returns all nodes
ClassMethod GetNodes() As %DynamicObject
{
    set $ZTrap = "Error"
    
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    set tNodeList = ##class(opc.ua.config.Node).GetAllNodes()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tNodeList, .tResponse)    	
    return tResponse   
	
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Add a new node<br/>
/// The method arguments hold values for:<br/>
///     body, Add new Node<br/>
ClassMethod PostNode(body As %DynamicArray) As %DynamicObject
{
    set $ZTrap = "Error"
    
    set tSC = ##class(opc.ua.util.JSON).LoadJSONList(body,"opc.ua.config.Node",.tNodeList)
    if $$$ISERR(tSC) {
		return ..ReturnError(500, "Can not add node", tSC)
	}
	
    // start a transaction
 	TSTART 	
    
    for i=1:1:tNodeList.Count() {	    
	    set tNode = tNodeList.GetAt(i)	    
	    set tSC = tNode.%Save()
	    if $$$ISERR(tSC) {
		    TROLLBACK
		    return ..ReturnError(500, "Can not add node "_tNode.Name, tSC)
	    }
    }       
    
    TCOMMIT
    
    do ..%SetStatusCode(201)
    return ""
        
Error
	set $ZTrap = ""
	TROLLBACK
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Update the specified node<br/>
/// The method arguments hold values for:<br/>
///     node_id<br/>
///     body, Update the Node<br/>
ClassMethod PutNode(nodeid As %String, body As %DynamicObject) As %DynamicObject
{
    Set $ZTrap = "Error"
    
    if (nodeid = "") return ..ReturnError(400, "Bad Request", ,"Node identifier required")    
    
    set tNode = ##class(opc.ua.config.Node).SearchByGUID(nodeid)
    if tNode = "" return ..ReturnError(404, "Not Found", ,"Node "_nodeid)
        
    set tSC = tNode.%JSONImport(body)
    if $$$ISERR(tSC) return ..ReturnError(400, "Bad Request", ,"Node body isn't correct") 
    
    set tSC = tNode.%Save()
    if $$$ISERR(tSC) return ..ReturnError(500, "Can not update node "_tNode.Name, tSC)
    
    return ""
    
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Get the specified node<br/>
/// The method arguments hold values for:<br/>
///     node_id<br/>
ClassMethod GetNode(nodeid As %String) As %DynamicObject
{
    set $ZTrap = "Error"
    
    if (nodeid = "") return ..ReturnError(400, "Bad Request", ,"Node identifier required")    
    
    set tNode = ##class(opc.ua.config.Node).SearchByGUID(nodeid)
    if tNode = "" return ..ReturnError(404, "Not Found", ,"Node "_nodeid)
    do tNode.%JSONExportToString(.tResponse)  
	return tResponse     
    
Error
	set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Return all yields
ClassMethod GetYields() As %DynamicObject
{
    set $ZTrap = "Error"
    
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    set tYieldList = ##class(opc.ua.config.Yield).GetAllYields()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tYieldList, .tResponse)    	
    return tResponse   
	
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
}

/// Return all equipment types
ClassMethod GetEquipmentTypes() As %DynamicObject
{
    set $ZTrap = "Error"
    
    set tResponse = ##class(%Stream.GlobalCharacter).%New()
    set tEquipmentTypeList = ##class(opc.ua.config.EquipmentType).GetAllEquipmentTypes()
    do ##class(opc.ua.util.JSON).ListToJSONStream(tEquipmentTypeList, .tResponse)    	
    return tResponse   
	
Error
	Set $ZTrap = ""
	return ..ReturnError(500, "Internal server error", ,"Error trapped: "_$ZError)
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
