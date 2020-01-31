/// OPC UA data importer service
Class opc.ua.service.SubscriptionService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "Connection:OPC:,Equipment:OPC:,Configuration:OPC:,PollingInterval:OPC:,PythonTemplatePath:OPC:,LogFilePath:OPC,TargetConfigNames:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// The target for the trigger.
Property TargetConfigNames As %String;

/// Equipment configuration to subscribe on.
Property Equipment As %String;

/// Property configuration name
Property Configuration As %String;

/// Property python template path 
Property PythonTemplatePath As %String(MAXLEN=2048);

/// Connection string to the OPC UA server.
/// Example: opc.tcp://<host>:<port>
Property Connection As %String(MAXLEN = 100);

/// OPC subscription polling interval in milliseconds
Property PollingInterval As %Integer[InitialExpression = 1000];

/// Log file path
Property LogFilePath As %String(MAXLEN=2048);

/// Process the input
Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status{
		
	$$$LOGINFO("Start OPC UA client connection to ["_..Connection_"] for equipment ["_..Equipment_"]")
	
	/// Check if equipment, configuration and connection value has been configured
	if ((..Equipment '= "") && (..Configuration '= "") && (..Connection '= "") && (..PythonTemplatePath '= "")) { 
		
		/// Search the equipment by Name
		#dim tEquipment As opc.ua.config.Equipment
		set tEquipment = ##class(opc.ua.config.Equipment).SearchByName(..Equipment)	
		
		if (tEquipment '= "") {
			
			#dim tConfiguration As opc.ua.config.Configuration
			set tConfiguration = tEquipment.SearchCurrentConfigurationByName(..Configuration)
					
			if (tConfiguration '= "") {
		
				/// Check if machine class definition is available
				if ('tEquipment.IsClassDefinitionAvailable(tConfiguration.Name)) {
					$$$LOGINFO("Class definition is not available for this combination of equipment ["_..Equipment_"] and configuration ["_..Configuration_"]")
					$$$LOGINFO("Generating class definition for equipment ["_..Equipment_"] and configuration ["_..Configuration_"]")
					set sc = tEquipment.GenerateClassDefinition(tConfiguration.Name)
					return:$$$ISERR(sc) sc
				}
				
				/// Get python template 
				set tPythonCode = ..GeneratePythonCode(tEquipment, tConfiguration)				
				if (tPythonCode '= "") {

					/// Execute python code						
					set sc = ..ExecutePythonCode(tPythonCode)
					return:$$$ISERR(sc) sc
					
				}						
				
			}	
		}	
	} else {
		$$$LOGERROR("One or more required fields are not configured [Equipment, Configuration, Connection or PythonTemplatePath]")
	}
	
	return $$$OK
}

/// Teardown the subscription service before this business service is stopped
Method OnTearDown() As %Status
{
	
	return $$$OK
}

/// Execute the python code
Method ExecutePythonCode(pCode As %ListOfDataTypes) As %Status {
	
	if (pCode '= "") {
		$$$TRACE("Lines of code ["_pCode.Count()_"]")
		for i=1:1:pCode.Count() {
	 		set line = pCode.GetAt(i)
				
			$$$TRACE("Execute ["_line_"]") 
		 	set sc = ##class(isc.py.Main).SimpleString(line)
		 	if $$$ISERR(sc) {
		 		$$$LOGERROR("Execute error ["_sc_"]")
		 		return sc
		 	}	
		}		
	}
	
	return $$$OK	
}

/// Generate the nodes for the python scripts
Method GeneratePythonCodeNodes(pEquipment As opc.ua.config.Equipment, pConfiguration As opc.ua.config.Configuration) As %String
{
	set tNodeString = ""
	set tIsFirst = 1
	
	set tNodeList = pEquipment.GetNodesForConfiguration(pConfiguration.Name)
	for i=1:1:tNodeList.Count() {
		
		#dim tNode As opc.ua.config.Node
	 	set tNode = tNodeList.GetAt(i)
	 		 	
	 	if tIsFirst {
	 		set tNodeString = "'"_tNode.NodeId_"'"
	 		set tIsFirst = 0
	 	}
	 	else {
	 		set tNodeString = tNodeString_",'"_tNode.NodeId_"'"
	 	}	
	}
	
	return tNodeString
}

/// Generate the python template based on the input provided
Method GeneratePythonCode(pEquipment As opc.ua.config.Equipment, pConfiguration As opc.ua.config.Configuration) As %Collection.ListOfDT
{	
 	
 	#dim tTemplateCode As %List
 	set tTemplateCode = ##class(%ListOfDataTypes).%New()
 	
	/// Template path filled
	if (..PythonTemplatePath '= "") {
		
		/// Check if file exists
		if (##class(%File).Exists(..PythonTemplatePath)) {			
			$$$TRACE("File exists"_..PythonTemplatePath)	
				
			/// Open python template	
			#dim tFile As %Library.File		
			set tFile = ##class(%File).%New(..PythonTemplatePath)
			if (tFile '= "") {
			
				do tFile.Open("R")
				while 'tFile.AtEnd {
					set line = tFile.ReadLine()
					set line = $REPLACE(line, "##CONNECTION##", "'"_..Connection_"'")
					set line = $REPLACE(line, "##SUBSCRIPTIONNODES##", ..GeneratePythonCodeNodes(pEquipment, pConfiguration))
					set line = $REPLACE(line, "##POLLINGINTERVAL##", ..PollingInterval)
					set line = $REPLACE(line, "##LOGFILEPATH##", "'"_..LogFilePath_"'")
										
					do tTemplateCode.Insert(line)
				 }
				
				/// Close the file
				set tFile = "" 
			}	
		}	
	}	

	return tTemplateCode
	
}

/// To draw connections for the Dynamic setting TargetConfigNames in the management portal, this method will be called.
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	do ##super(.pArray,pItem)
	if pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		for i=1:1:$L(tValue,",") { set tOne=$ZStrip($P(tValue,",",i),"<>W")  continue:""=tOne  set pArray(tOne)="" }
	}
}

}
