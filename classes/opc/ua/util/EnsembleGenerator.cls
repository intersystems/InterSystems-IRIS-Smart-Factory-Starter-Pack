Class opc.ua.util.EnsembleGenerator Extends %RegisteredObject
{

/// The equipment to generate the Ensemble components for
Property Equipment As opc.ua.config.Equipment;

/// The staging configuration (should be only one)
Property StagingConfig As opc.ua.config.EquipmentConfiguration;

/// One or more transforming configurations
Property TransformingConfigs As list Of opc.ua.config.EquipmentConfiguration;

/// One or more serving configurations
Property ServingConfigs As list Of opc.ua.config.EquipmentConfiguration;

/// The production to create/update
Property Production As Ens.Config.Production;

// =====

ClassMethod Generate(Equipment As opc.ua.config.Equipment) As %Status
{
	set Me = ..%New()
	
	if $IsObject(Equipment) {
		set Me.Equipment = Equipment
		
	} else {
		; Support passing by id
		do Me.EquipmentSetObjectId(Equipment)
		
	}
	
	; Actual implementation in method
	return Me.GenerateImpl()
}

/// Generate default Ensemble components for equipment
Method GenerateImpl() As %Status
{
	; Get/create a production configuration object
	set sc = ..GetProductionConfig(.Production)
	If 'sc Quit sc
	Set ..Production = Production
	
	; Loop through the configurations for this equipment
	set key = ""
	for  {
		#dim EquipConfig As opc.ua.config.EquipmentConfiguration
		set EquipConfig = ..Equipment.EquipmentConfiguration.GetNext(.key)
		if key = "" quit
		set Config = EquipConfig.Configuration
		
		#dim Config As opc.ua.config.Configuration
		if Config.ConfigType = "staging" {
			set ..StagingConfig = EquipConfig
		} elseif Config.ConfigType = "transforming" {
			do ..TransformingConfigs.Insert(EquipConfig)
		} else {
			do ..ServingConfigs.Insert(EquipConfig)
		}
	}
	
	; Create serving request class
	set MsgPkg = "opc.client.msg"
	set sc = ..CreateServingReq(MsgPkg)
	if 'sc return sc
	
	; Generate all transforming BPs
	for i = 1:1:..TransformingConfigs.Count() {
		set sc = ..GenerateTransforming(..TransformingConfigs.GetAt(i))
		if 'sc return sc
	}
	
	; Generate all serving BPs
	for i = 1:1:..ServingConfigs.Count() {
		set sc = ..GenerateServing(..ServingConfigs.GetAt(i))
		if 'sc return sc
	}
	
	; Update the production
	set sc = ..UpdateProduction()
	if 'sc return sc
	
	quit $$$OK
}

Method GenerateTransforming(EquipConfig As opc.ua.config.EquipmentConfiguration) As %Status
{
	#dim Config As opc.ua.config.Configuration
	Set Config = EquipConfig.Configuration
	
	; Packages to use for various classes
	set BasePkg = ..Equipment.ClassPackage
	set ProcessPkg = BasePkg_".bp"
	set RulePkg = BasePkg_".rule"
	set TransformPkg = BasePkg_".dtl"
	
	set MsgPkg = "opc.client.msg"
	set ServingReqClass = MsgPkg_"."_..Equipment.Name_"ServingRequest"
	
	; Names of data classe we receive and create
	set DataClassIn = ##class(opc.ua.data.Generator).GetClassName(..StagingConfig)
	set DataClassOut = ##class(opc.ua.data.Generator).GetClassName(EquipConfig)
	
	; Name of business process, rule, DTL
	set ProcessClass = ProcessPkg_"."_Config.ConfigType_"."_Config.Name
	set ProcessName = ..Equipment.Name_" "_Config.Name
	set RuleClass = RulePkg_"."_Config.ConfigType_"."_Config.Name
	set TransformClass = TransformPkg_"."_Config.ConfigType_"."_Config.Name
	
	; Replacement strings for BPL XData
	set Replacements("{RequestClass}") = "opc.ua.msg.TransformingReq"
	set Replacements("{ResponseClass}") = "Ens.Response"
	set Replacements("{DataClassIn}") = DataClassIn
	set Replacements("{DataClassOut}") = DataClassOut
	set Replacements("{RuleClass}") = RuleClass
	set Replacements("{TransformName}") = TransformClass
	set Replacements("{ServingReqClass}") = ServingReqClass
	set Replacements("{TransformingProperty}") = Config.Name
	
	set sc = ..CreateBP(ProcessClass, "TransformProcess", ProcessName, .Replacements)
	if 'sc quit ..BuildStatus("Error creating BP {}", sc, ProcessClass)
	
	set sc = ..CreateRule(RuleClass, "Rule", ProcessClass)
	if 'sc quit ..BuildStatus("Error creating rule {}", sc, RuleClass)
	
	; Replacement strings for DTL XData
	set Replacements("{InputClass}") = "opc.ua.msg.TransformingReq"
	set Replacements("{OutputClass}") = DataClassOut
	set Replacements("{InputRef}") = ".StagingData"
	
	set sc = ..CreateDTL(TransformClass, "Transform", .Replacements)
	if 'sc quit ..BuildStatus("Error creating DTL {}", sc, TransformClass)
	
	Quit $$$OK
}

Method GenerateServing(EquipConfig As opc.ua.config.EquipmentConfiguration) As %Status
{
	#dim Config As opc.ua.config.Configuration
	Set Config = EquipConfig.Configuration
	
	Set BasePkg = ..Equipment.ClassPackage
	set ProcessPkg = BasePkg_".bp"
	set RulePkg = BasePkg_".rule"
	set TransformPkg = BasePkg_".dtl"
	
	set MsgPkg = "opc.client.msg"
	set ServingReqClass = MsgPkg_"."_..Equipment.Name_"ServingRequest"
	
	set DataClassOut = ##class(opc.ua.data.Generator).GetClassName(EquipConfig)
	
	; Name of business process, rule, DTL
	set ProcessClass = ProcessPkg_"."_Config.ConfigType_"."_Config.Name
	set ProcessName = ..Equipment.Name_" "_Config.Name
	set RuleClass = RulePkg_"."_Config.ConfigType_"."_Config.Name
	set TransformClass = TransformPkg_"."_Config.ConfigType_"."_Config.Name
	
	; Replacement strings for BPL XData
	set Replacements("{RequestClass}") = ServingReqClass
	set Replacements("{ResponseClass}") = "Ens.Response"
	set Replacements("{DataClassOut}") = DataClassOut
	set Replacements("{RuleClass}") = RuleClass
	set Replacements("{TransformClass}") = TransformClass
	
	set sc = ..CreateBP(ProcessClass, "ServingProcess", ProcessName, .Replacements)
	if 'sc quit ..BuildStatus("Error creating BP {}", sc, ProcessClass)
	
	set sc = ..CreateRule(RuleClass, "Rule", ProcessClass)
	if 'sc quit ..BuildStatus("Error creating rule {}", sc, RuleClass)
	
	; Replacement strings for DTL XData
	set Replacements("{InputClass}") = ServingReqClass
	set Replacements("{OutputClass}") = DataClassOut
	set Replacements("{InputRef}") = ".StagingData"
	
	set sc = ..CreateDTL(TransformClass, "Transform", .Replacements)
	if 'sc quit ..BuildStatus("Error creating DTL {}", sc, TransformClass)
	
	Quit $$$OK
}

Method CreateBP(ClassName As %String, TplName As %String, ProdItemName As %String, ByRef Replacements As %String) As %Status
{
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName) Quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ClassName, 25)
	set ClassDef.Super = "Ens.BusinessProcessBPL"
	
	; Insert default BPL XData block
	set BPL = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||"_TplName)
	set BPL = BPL.%ConstructClone()
	set BPL.Name = "BPL"
	do ClassDef.XDatas.Insert(BPL)
	
	; Replace template data
	set Data = BPL.Data.Read()
	set Key = ""
	for  {
		set Key = $Order(Replacements(Key), 1, Value)
		if Key = "" quit
		set Data = $Replace(Data, Key, Value)
	}
	do BPL.Data.Clear(), BPL.Data.Write(Data)
	
	; Save the new class
	set sc = ClassDef.%Save()
	if 'sc Quit sc
	
	; Add to production
	Set sc = ..AddProductionItem(ProdItemName, ClassName)
	if 'sc quit ..BuildStatus("Error adding item {} to production:", sc, ClassName)
	
	return $$$OK
}

Method CreateRule(ClassName As %String, TplName As %String, ProcessClass As %String) As %Status
{
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ClassName, 25)
	set ClassDef.Super = "Ens.Rule.Definition"
	
	; Insert default rule definition XData block
	set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||"_TplName)
	set RuleDef = RuleDef.%ConstructClone()
	set RuleDef.Name = "RuleDefinition"
	do ClassDef.XDatas.Insert(RuleDef)
	
	; Add context class to rule
	set Data = RuleDef.Data.Read()
	set Data = $Replace(Data, "context=""""", "context="""_ProcessClass_".Context""")
	do RuleDef.Data.Clear(), RuleDef.Data.Write(Data)
	
	; Save
	set sc = ClassDef.%Save()
	if 'sc Quit sc
	
	return $$$OK
}

Method CreateDTL(ClassName As %String, TplName As %String, ByRef Replacements As %String) As %Status
{
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ClassName, 25)
	set ClassDef.Super = "Ens.DataTransformDTL"
	set ClassDef.DependsOn = Replacements("{InputClass}")_","_Replacements("{OutputClass}")
	
	; Insert default rule definition XData block
	set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||"_TplName)
	set RuleDef = RuleDef.%ConstructClone()
	set RuleDef.Name = "DTL"
	do ClassDef.XDatas.Insert(RuleDef)
	
	; Add context class to rule
	set Data = RuleDef.Data.Read()
	set Key = ""
	for  {
		set Key = $Order(Replacements(Key), 1, Value)
		if Key = "" quit
		set Data = $Replace(Data, Key, Value)
	}
	do RuleDef.Data.Clear(), RuleDef.Data.Write(Data)
	
	; Save
	set sc = ClassDef.%Save()
	if 'sc Quit sc
	
	return $$$OK
}

Method CreateServingReq(MsgPkg As %String, Output ServingReqClass As %String) As %Status
{
	set ServingReqClass = MsgPkg_"."_..Equipment.Name_"ServingRequest"
	
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ServingReqClass) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ServingReqClass, 25)
	set ClassDef.Super = "Ens.Response"
	
	; Add property for staging data
	set StagingDataClass = ##class(opc.ua.data.Generator).GetClassName(..StagingConfig)
	#dim PropDef As %Dictionary.PropertyDefinition
	set PropDef = ..GetElement(ClassDef.Properties, "StagingData")
	set PropDef.Type = StagingDataClass
	Set PropDef.SequenceNumber = $Increment(SequenceNumber)
	
	; Add properties for all transforming configurations
	for i = 1:1:..TransformingConfigs.Count() {
		#dim EquipConfig As opc.ua.config.EquipmentConfiguration
		Set EquipConfig = ..TransformingConfigs.GetAt(i)
		Set DataClass = ##class(opc.ua.data.Generator).GetClassName(EquipConfig)
		Set PropName = EquipConfig.Configuration.Name
		set PropDef = ..GetElement(ClassDef.Properties, PropName)
		set PropDef.Type = DataClass
		Set PropDef.SequenceNumber = $Increment(SequenceNumber)
	}
	
	; Save
	set sc = ClassDef.%Save()
	if 'sc Quit sc
	
	return $$$OK
}

Method UpdateProduction() As %Status
{
	; Add routers, if not yet present
	
	Set Name = "TransformRouter"
	Set sc = ..AddProductionItem(Name, "EnsLib.MsgRouter.RoutingEngine")
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set Name = "ServingRouter"
	Set sc = ..AddProductionItem(Name, "EnsLib.MsgRouter.RoutingEngine")
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	
	; Add services for equipment, if not yet present
	
	Set EquipmentName = ..Equipment.Name
	
	Set Name = EquipmentName_"Data"
	Set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	Set sc = ..AddProductionItem(Name, "opc.ua.service.DataService", .Settings)
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set Name = EquipmentName_"ReplayService"
	Set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	Set sc = ..AddProductionItem(Name, "opc.ua.service.ReplayDataService", .Settings)
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set Name = EquipmentName_"Subscription"
	Set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	Set sc = ..AddProductionItem(Name, "opc.ua.service.SubscriptionService", .Settings)
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set sc = ..Production.SaveToClass()
	If 'sc Quit ..BuildStatus("Error saving configuration for production {}:", sc, ..Production.Name)
	
	Quit $$$OK
}

/*
/// Entry point: generates the Ensemble components for the
/// given equipment configuration.
ClassMethod GenerateOld(EquipmentConfiguration As opc.ua.config.EquipmentConfiguration) As %Status
{
	set Me = ..%New()
	
	if $IsObject(EquipmentConfiguration) {
		set Me.Config = EquipmentConfiguration
		
	} else {
		; Support passing by id
		do Me.ConfigSetObjectId(EquipmentConfiguration)
		
	}
	
	; Actual implementation in method
	return Me.GenerateImpl()
}

/// Generate default Ensemble components for new machine configuration
Method GenerateImplOld() As %Status
{
	/*
	; We only need components for transforming and serving
	set ..Type = ..Config.Configuration.ConfigType
	if ..Type = "staging" return $$$OK
	
	set EquipmentName = ..Config.Equipment.Name
	set ConfigName = ..Config.Configuration.Name
	
	; Get/create a production configuration object
	set sc = ..GetProductionConfig(.Production)
	If 'sc Quit sc
	Set ..Production = Production
	
	; ===
	
	Set BasePkg = "gj."_..Config.Equipment.ClassPackage
	set ProcessPkg = BasePkg_".bp"
	set RulePkg = BasePkg_".rule"
	set TransformPkg = BasePkg_".dtl"
	
	set Stage = $Select(..Type = "transforming": "Transform", 1: "Serving")
	
	; Determine names of various components to generate
	
	set ProcessName = ProcessPkg_"."_EquipmentName_Stage
	if ..Type = "transforming" {
		set RequestClass = "opc.ua.msg.TransformingReq"
	} else {
		set RequestClass = "opc.ua.msg.ServingReq"
	}
	set ResponseClass = ProcessPkg_"."_EquipmentName_Stage_"."_EquipmentName_Stage_"Resp"
	set RuleName = RulePkg_"."_EquipmentName_Stage
	set TransformName = TransformPkg_"."_EquipmentName_Stage
	
	set DataClassIn = ..DetermineInputDataClass()
	set DataClassOut = ##class(opc.ua.data.Generator).GetClassName(..Config)
	
	; == Generate empty business process
	
	if '##class(%Dictionary.ClassDefinition).%ExistsId(ProcessName) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ProcessName, 25)
		set ClassDef.Super = "Ens.BusinessProcessBPL"
		
		; Insert default BPL XData block
		set BPL = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||"_Stage_"Process")
		set BPL = BPL.%ConstructClone()
		set BPL.Name = "BPL"
		do ClassDef.XDatas.Insert(BPL)
		
		; Replace dataclass name template
		set Data = BPL.Data.Read()
		set Data = $Replace(Data, "{RequestClass}", RequestClass)
		set Data = $Replace(Data, "{ResponseClass}", ResponseClass)
		set Data = $Replace(Data, "{DataClassIn}", DataClassIn)
		set Data = $Replace(Data, "{DataClassOut}", DataClassOut)
		set Data = $Replace(Data, "{RuleClass}", RuleName)
		set Data = $Replace(Data, "{TransformName}", TransformName)
		do BPL.Data.Clear(), BPL.Data.Write(Data)
		
		; The BP doesn't need compilation, because it doesn't do anything yet
		set sc = ClassDef.%Save()
		if 'sc Quit sc
		
		; Add to production
		Set sc = ..AddProductionItem(ConfigName, ProcessName)
		if 'sc quit ..BuildStatus("Error adding item {} to production:", sc, ProcessName)
	}
	
	; Response class
	if '##class(%Dictionary.ClassDefinition).%ExistsId(ResponseClass) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ResponseClass, 25)
		set ClassDef.Super = "Ens.Response"
		
		set sc = ClassDef.%Save()
		if 'sc Quit sc
		set sc = $System.OBJ.Compile(RequestClass, "k-d")
		if 'sc Quit sc
	}
	
	; == Generate empty business rule
	
	if '##class(%Dictionary.ClassDefinition).%ExistsId(RuleName) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(RuleName, 25)
		set ClassDef.Super = "Ens.Rule.Definition"
		
		; Insert default rule definition XData block
		set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||Rule")
		set RuleDef = RuleDef.%ConstructClone()
		set RuleDef.Name = "RuleDefinition"
		do ClassDef.XDatas.Insert(RuleDef)
		
		; Add context class to rule
		set Data = RuleDef.Data.Read()
		set Data = $Replace(Data, "context=""""", "context="""_ProcessName_".Context""")
		do RuleDef.Data.Clear(), RuleDef.Data.Write(Data)
		
		; The rule doesn't need compilation, because it doesn't do anything yet
		set sc = ClassDef.%Save()
		if 'sc Quit sc
	}
	
	; == Generate empty DTL
	
	if '##class(%Dictionary.ClassDefinition).%ExistsId(TransformName) {
		set ClassDef = ##class(%Dictionary.ClassDefinition).%New(TransformName, 25)
		set ClassDef.Super = "Ens.DataTransformDTL"
		set ClassDef.DependsOn = DataClassIn_","_DataClassOut
		
		; Insert default rule definition XData block
		set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||Transform")
		set RuleDef = RuleDef.%ConstructClone()
		set RuleDef.Name = "DTL"
		do ClassDef.XDatas.Insert(RuleDef)
		
		; Add context class to rule
		set Data = RuleDef.Data.Read()
		set Data = $Replace(Data, "{DataClassIn}", DataClassIn)
		set Data = $Replace(Data, "{DataClassOut}", DataClassOut)
		do RuleDef.Data.Clear(), RuleDef.Data.Write(Data)
		
		; The DTL doesn't need compilation, because it doesn't do anything yet
		set sc = ClassDef.%Save()
		if 'sc Quit sc
	}
	
	; === Production
	
	; Add routers, if not yet present
	
	Set Name = "TransformRouter"
	Set sc = ..AddProductionItem(Name, "EnsLib.MsgRouter.RoutingEngine")
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set Name = "ServingRouter"
	Set sc = ..AddProductionItem(Name, "EnsLib.MsgRouter.RoutingEngine")
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	
	; Add services for equipment, if not yet present
	
	Set Name = EquipmentName_"Data"
	Set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	Set sc = ..AddProductionItem(Name, "opc.ua.service.DataService", .Settings)
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set Name = EquipmentName_"ReplayService"
	Set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	Set sc = ..AddProductionItem(Name, "opc.ua.service.ReplayDataService", .Settings)
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	Set Name = EquipmentName_"Subscription"
	Set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	Set sc = ..AddProductionItem(Name, "opc.ua.service.SubscriptionService", .Settings)
	If 'sc Quit ..BuildStatus("Error adding {} to production:", sc, Name)
	
	
	
	
	
	Set sc = ..Production.SaveToClass()
	If 'sc Quit ..BuildStatus("Error saving configuration for production {}:", sc, ..Production.Name)
	
	
	Quit $$$OK
	
}
	*/

// ===== Production helpers

/// Retrieves the production configuration to be used to add
/// items to. Creates a new default production if one doesn't
/// exist yet.
ClassMethod GetProductionConfig(Output Production As Ens.Config.Production) As %Status
{
	; Did we create the production here?
	Set IsNew = 0
	
	; Get name of latest running production
	Set ProdName = "" ;;##class(Ens.Director).GetActiveProductionName()
	If ProdName = "" {
		; No current or previously used production; use default name
		Set ProdName = "opc.client.Production"
		
		; If the production class doesn't yet exist, create it
		If '##class(%Dictionary.ClassDefinition).%ExistsId(ProdName) {
			Set sc = ..CreateProduction(ProdName)
			If 'sc Quit ..BuildStatus("Error creating new production {}:", sc, ProdName)
			Set IsNew = 1
		}
	}
	
	; Create configuration item to return
	Set sc = ##class(Ens.Config.Production).LoadFromClass(ProdName)
	If 'sc Quit ..BuildStatus("Error loading production {} configuration:", sc, ProdName)
	Set Production = ##class(Ens.Config.Production).%OpenId(ProdName, , .sc)
	If 'sc Quit ..BuildStatus("Error opening production {} configuration:", sc, ProdName)
	
	Quit $$$OK
}

/// Creates a new production with the given name.
ClassMethod CreateProduction(Name As %String) As %Status
{
	; The physical production class
	Set Prod = ##class(%Dictionary.ClassDefinition).%New(Name, 25)
	Set Prod.Super = "Ens.Production"
	Set XData = ..GetElement(Prod.XDatas, "ProductionDefinition")
	Do XData.Data.WriteLine("<Production></Production>")
	Set sc = Prod.%Save()
	If 'sc Quit ..BuildStatus("Error saving new production {}:", sc, Name)
	
	; Production class needs to be compiled for further configuration
	Set sc = $System.OBJ.Compile(Name, "cku-d")
	If 'sc Quit ..BuildStatus("Error compiling new production {}:", sc, Name)
	
	; Create configuration object with a few default settings
	Set ProdCfg = ##class(Ens.Config.Production).%New(Name)
	Set ProdCfg.Description = "OPC UA Production"
	Set ProdCfg.TestingEnabled = 1
	Set ProdCfg.ActorPoolSize = 10
	
	; Save configuration
	Set sc = ProdCfg.SaveToClass()
	If 'sc Quit ..BuildStatus("Error saving production configuration:", sc)
	
	Quit $$$OK
}

/// Adds a new item to the production, but only if it doesn't exist yet.
Method AddProductionItem(Name As %String, ClassName As %String, ByRef Settings As %String) As %Status
{
	; Add the item, unless it already exists
	Set Item = ..AddElement(..Production.Items, Name)
	If Item = "" Quit $$$OK
	
	Set Item.ClassName = ClassName
	If $Get(Settings) Do Item.UpdateSettings(.Settings)
	
	If $$$comClassKeyGet("opc.ua.service.DataService", $$$cCLASSprimarysuper) [ "~Ens.BusinessProcess~" {
		; Set the pool size of business processes to 1, which mimicks what
		; the management portal does when adding one there.
		If $ClassMethod(ClassName, "%IsA", "Ens.BusinessProcess") Set Item.PoolSize = 1
	}
	
	Kill Settings
	
	Quit $$$OK
}

// ===== Helpers

/// Attempt to determine the input data class. This is the data class
/// created at the previous stage; e.g., if we are generating serving
/// classes, the input data is that generated for the transforming
/// layer.
Method DetermineInputDataClass()
{
	/*
	set EquipmentName = ..Config.Equipment.Name
	set ConfigName = ..Config.Configuration.Name
	
	; Attempt to find configuration for previous stage
	set ConfigType = $Case(..Type,
	  "transforming": "staging",
	  "serving": "transforming",
	  : "unknown")
	set PrevConfig = ##class(opc.ua.config.EquipmentConfiguration).Get(EquipmentName, ConfigType, ConfigName, .sc)
	
	; If the configuration is not found, it may have a different name.
	; Fall back to the default in this case.
	if 'sc return "opc.ua.data.Base"
	
	; Ask generator to determine data class name
	Set InputDataClass = ##class(opc.ua.data.Generator).GetClassName(PrevConfig)
	
	return InputDataClass
	*/
}

/// Retrieves, by the Name property, an element from a collection.
/// Creates and inserts it if it doesn't already exist.
ClassMethod GetElement(Collection As %Collection.ListOfObj, Name As %String) As %RegisteredObject
{
	; Check if the element already exists
	set key = ""
	for  {
		set def = Collection.GetNext(.key)
		if key = "" quit
		if def.Name = Name return def
	}
	
	; Not found; create and insert
	set def = $ClassMethod(Collection.ElementType, "%New")
	set def.Name = Name
	do Collection.Insert(def)
	
	return def
}

/// Adds an element with the given name to a collection, and
/// returns it. If an element with that name already exists,
/// an empty string is returned.
ClassMethod AddElement(Collection As %Collection.ListOfObj, Name As %String) As %RegisteredObject
{
	; Make sure the element doesn't already exist
	set key = ""
	for  {
		set def = Collection.GetNext(.key)
		if key = "" quit
		if def.Name = Name return ""
	}
	
	; Not found; create and insert
	set def = $ClassMethod(Collection.ElementType, "%New")
	set def.Name = Name
	do Collection.Insert(def)
	
	return def
}

/// Builds a %Status from a message and (optionally) an existing %Status.
ClassMethod BuildStatus(Message As %String, Status As %Status = "", Args... As %String)
{
	; Check for message arguments, replace if present
	for i = 1:1:$Get(Args) {
		set Arg = $Get(Args(i))
		set Message = $Replace(Message, "{}", Arg, , 1)
	}
	set MsgStatus = $$$ERROR($$$GeneralError, Message)
	
	if 'Status, Status '= "" {
		set MsgStatus = $System.Status.AppendStatus(MsgStatus, Status)
	}
	
	return MsgStatus
}

// ===== Templates

/// Template data for the automatic generation of the business process
XData TransformProcess [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='{RequestClass}' response='{ResponseClass}' >
<context>
<property name='StagingData' type='{DataClassIn}' instantiate='0' />
<property name='TransformingData' type='{DataClassOut}' instantiate='1' />
</context>
<sequence  >
<assign name="Data to context" property="context.StagingData" value="request.StagingData" action="set"  />
<rule name='Process' rule='{RuleClass}' />
<transform name='Transform' class='{TransformClass}' source='context.StagingData' target='context.TransformingData' />
<call name='Send to ServingRouter' target='ServingRouter' async='1' xpos='200' ypos='1950' >
<request type='{ServingReqClass}' >
<assign property="callrequest.StagingData" value="context.StagingData" action="set" />
<assign property="callrequest.{TransformingProperty}" value="context.TransformingData" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

XData ServingProcess [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='{RequestClass}' response='{ResponseClass}' >
<context>
<property name='ServingData' type='{DataClassOut}' instantiate='1' />
</context>
<sequence  >
<rule name='Process' rule='{RuleClass}' />
<transform name='Transform' class='{TransformClass}' source='request' target='context.ServingData' />
</sequence>
</process>
}

/// Template data for the automatic generation of business rules
XData Rule [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
</ruleSet>
</ruleDefinition>
}

/// Template data for the automatic generation of DTL
XData Transform [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='{InputClass}' targetClass='{OutputClass}' create='existing' language='objectscript' >
<assign value='source{InputRef}.TimeStamp' property='target.TimeStamp' action='set' />
<assign value='source{InputRef}.TimeStampLocal' property='target.TimeStampLocal' action='set' />
<assign value='source{InputRef}.YearLocal' property='target.YearLocal' action='set' />
<assign value='source{InputRef}.MonthLocal' property='target.MonthLocal' action='set' />
<assign value='source{InputRef}.DayLocal' property='target.DayLocal' action='set' />
<assign value='source{InputRef}.WeekDayLocal' property='target.WeekDayLocal' action='set' />
<assign value='source{InputRef}.TimeLocal' property='target.TimeLocal' action='set' />
</transform>
}

}
