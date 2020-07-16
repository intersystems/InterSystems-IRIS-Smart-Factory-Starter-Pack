Class opc.ua.util.EnsembleGenerator Extends %RegisteredObject
{

/// The equipment to generate the Ensemble components for
Property Equipment As opc.ua.config.Equipment;

// ===== Scratch data

/// The staging configuration (should be only one)
Property StagingConfig As opc.ua.config.EquipmentConfiguration;

/// One or more transforming configurations
Property TransformingConfigs As list Of opc.ua.config.EquipmentConfiguration;

/// One or more serving configurations
Property ServingConfigs As list Of opc.ua.config.EquipmentConfiguration;

/// The package for Ensemble message classes
Property MessagePackage As %String;

/// The production to create/update
Property Production As Ens.Config.Production;

// =====

/// Entry point. Generates Ensemble components for a given equipment object.
/// Equipment may be passed by id as well.
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

/// Implementation: generate default Ensemble components for equipment.
Method GenerateImpl() As %Status
{
	; Get/create an Ensemble production configuration object
	set sc = ..GetProductionConfig(.Production)
	if 'sc return sc
	set ..Production = Production
	
	; Loop through the configurations for this equipment
	set key = ""
	for  {
		#dim EquipConfig As opc.ua.config.EquipmentConfiguration
		set EquipConfig = ..Equipment.EquipmentConfiguration.GetNext(.key)
		if key = "" quit
		set Config = EquipConfig.Configuration
		
		#dim Config As opc.ua.config.Configuration
		if Config.ConfigType = "staging" {
			; We expect/support only one staging configuration per equipment
			set ..StagingConfig = EquipConfig
		} elseif Config.ConfigType = "transforming" {
			do ..TransformingConfigs.Insert(EquipConfig)
		} else {
			do ..ServingConfigs.Insert(EquipConfig)
		}
	}
	
	set ..MessagePackage = ..Equipment.ClassPackage_".msg"
	
	; Create transforming and serving request classes
	set sc = ..CreateTransformingReq()
	if 'sc return sc
	set sc = ..CreateServingReq()
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
	
	; Compile compile all uncompiled classes in the package.
	set sc = $System.OBJ.CompilePackage(..Equipment.ClassPackage, "uk-d")
	if 'sc return sc
	
	
	return $$$OK
}

/// Generates classes for a transforming stage.
Method GenerateTransforming(EquipConfig As opc.ua.config.EquipmentConfiguration) As %Status
{
	#dim Config As opc.ua.config.Configuration
	set Config = EquipConfig.Configuration
	
	; Packages to use for various classes
	set BasePkg = ..Equipment.ClassPackage
	set ProcessPkg = BasePkg_".bp."_..Equipment.Name
	set RulePkg = BasePkg_".rule."_..Equipment.Name
	set TransformPkg = BasePkg_".dtl."_..Equipment.Name
	
	set TransformingReqClass = ..MessagePackage_"."_..Equipment.Name_"TransformingRequest"
	set ServingReqClass = ..MessagePackage_"."_..Equipment.Name_"ServingRequest"
	
	; Names of data classes the BP receives and creates
	set DataClassIn = ##class(opc.ua.data.Generator).GetClassName(..StagingConfig)
	set DataClassOut = ##class(opc.ua.data.Generator).GetClassName(EquipConfig)
	
	; Name of business process, rule, DTL
	set ProcessClass = ProcessPkg_"."_Config.ConfigType_"."_Config.Name
	set ProcessName = Config.Name
	set RuleClass = RulePkg_"."_Config.ConfigType_"."_Config.Name
	set TransformClass = TransformPkg_"."_Config.ConfigType_"."_Config.Name
	
	; Replacement strings for BPL XData
	set Replacements("{RequestClass}") = TransformingReqClass
	set Replacements("{ResponseClass}") = "Ens.Response"
	set Replacements("{DataClassIn}") = DataClassIn
	set Replacements("{DataClassOut}") = DataClassOut
	set Replacements("{RuleClass}") = RuleClass
	set Replacements("{TransformClass}") = TransformClass
	set Replacements("{ServingReqClass}") = ServingReqClass
	set Replacements("{TransformingProperty}") = Config.Name
	
	set sc = ..CreateBP(ProcessClass, "TransformProcess", ProcessName, .Replacements)
	if 'sc quit ..BuildStatus("Error creating BP {}", sc, ProcessClass)
	
	; Replacement strings for business rule
	kill Replacements
	set Replacements("{RuleContext}") = ProcessClass_".Context"
	set Replacements("{ProductionName}") = ..Production.Name
	set sc = ..CreateRule(RuleClass, "Rule", .Replacements)
	if 'sc quit ..BuildStatus("Error creating rule {}", sc, RuleClass)
	
	; Replacement strings for DTL XData
	kill Replacements
	set Replacements("{InputClass}") = TransformingReqClass
	set Replacements("{OutputClass}") = DataClassOut
	set Replacements("{InputRef}") = ".Staging"
	
	set sc = ..CreateDTL(TransformClass, "Transform", .Replacements)
	if 'sc quit ..BuildStatus("Error creating DTL {}", sc, TransformClass)
	
	return $$$OK
}

/// Generates classes for a serving stage.
Method GenerateServing(EquipConfig As opc.ua.config.EquipmentConfiguration) As %Status
{
	#dim Config As opc.ua.config.Configuration
	set Config = EquipConfig.Configuration
	
	set BasePkg = ..Equipment.ClassPackage
	set ProcessPkg = BasePkg_".bp."_..Equipment.Name
	set RulePkg = BasePkg_".rule."_..Equipment.Name
	set TransformPkg = BasePkg_".dtl."_..Equipment.Name
	
	set ServingReqClass = ..MessagePackage_"."_..Equipment.Name_"ServingRequest"
	
	; Name of data class the BP creates
	set DataClassOut = ##class(opc.ua.data.Generator).GetClassName(EquipConfig)
	
	; Name of business process, rule, DTL
	set ProcessClass = ProcessPkg_"."_Config.ConfigType_"."_Config.Name
	set ProcessName = Config.Name
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
	
	; Replacement strings for business rule
	kill Replacements
	set Replacements("{RuleContext}") = ProcessClass_".Context"
	set Replacements("{ProductionName}") = ..Production.Name
	set sc = ..CreateRule(RuleClass, "Rule", .Replacements)
	if 'sc quit ..BuildStatus("Error creating rule {}", sc, RuleClass)
	
	; Replacement strings for DTL XData
	set Replacements("{InputClass}") = ServingReqClass
	set Replacements("{OutputClass}") = DataClassOut
	set Replacements("{InputRef}") = ".Staging"
	
	set sc = ..CreateDTL(TransformClass, "Transform", .Replacements)
	if 'sc quit ..BuildStatus("Error creating DTL {}", sc, TransformClass)
	
	return $$$OK
}

/// Creates a Business Process and adds it to the production
Method CreateBP(ClassName As %String, TplName As %String, ProdItemName As %String, ByRef Replacements As %String) As %Status
{
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName) return $$$OK
	
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
	if 'sc return sc
	
	; Add to production
	set sc = ..AddProductionItem(ProdItemName, ClassName)
	if 'sc quit ..BuildStatus("Error adding item {} to production:", sc, ClassName)
	
	return $$$OK
}

/// Creates a Business Rule
Method CreateRule(ClassName As %String, TplName As %String, ByRef Replacements As %String) As %Status
{
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ClassName, 25)
	set ClassDef.Super = "Ens.Rule.Definition"
	
	#dim Parm As %Dictionary.ParameterDefinition
	set Parm = ..GetElement(ClassDef.Parameters, "RuleAssistClass")
	set Parm.Default = "EnsLib.MsgRouter.RuleAssist"
	Set Parm.SequenceNumber = $Increment(SeqNr)
	
	; Insert default rule definition XData block
	set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||"_TplName)
	set RuleDef = RuleDef.%ConstructClone()
	set RuleDef.Name = "RuleDefinition"
	Set RuleDef.SequenceNumber = $Increment(SeqNr)
	do ClassDef.XDatas.Insert(RuleDef)
	
	; Handle replacements
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
	if 'sc return sc
	
	return $$$OK
}

/// Creates a Data Transformation
Method CreateDTL(ClassName As %String, TplName As %String, ByRef Replacements As %String) As %Status
{
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ClassName) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ClassName, 25)
	set ClassDef.Super = "Ens.DataTransformDTL"
	set ClassDef.DependsOn = Replacements("{InputClass}")_","_Replacements("{OutputClass}")
	
	; Insert default transformation XData block
	set RuleDef = ##class(%Dictionary.XDataDefinition).%OpenId(..%ClassName(1)_"||"_TplName)
	set RuleDef = RuleDef.%ConstructClone()
	set RuleDef.Name = "DTL"
	do ClassDef.XDatas.Insert(RuleDef)
	
	; Handle replacements
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
	if 'sc return sc
	
	return $$$OK
}

/// Creates the request class for all Serving business processes for
/// the equipment. Will contain a property for each of the transforming
/// data classes.
Method CreateTransformingReq(Output TransformingReqClass As %String) As %Status
{
	set TransformingReqClass = ..MessagePackage_"."_..Equipment.Name_"TransformingRequest"
	
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(TransformingReqClass) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(TransformingReqClass, 25)
	set ClassDef.Super = "Ens.Response"
	
	; Add property for staging data
	set StagingDataClass = ##class(opc.ua.data.Generator).GetClassName(..StagingConfig)
	#dim PropDef As %Dictionary.PropertyDefinition
	set PropDef = ..GetElement(ClassDef.Properties, "Staging")
	set PropDef.Type = StagingDataClass
	set PropDef.SequenceNumber = $Increment(SequenceNumber)
	
	; Save
	set sc = ClassDef.%Save()
	if 'sc return sc
	
	return $$$OK
}

/// Creates the request class for all Serving business processes for
/// the equipment. Will contain a property for each of the transforming
/// data classes.
Method CreateServingReq(Output ServingReqClass As %String) As %Status
{
	set ServingReqClass = ..MessagePackage_"."_..Equipment.Name_"ServingRequest"
	
	; Don't do anything if the class already exists
	if ##class(%Dictionary.ClassDefinition).%ExistsId(ServingReqClass) quit $$$OK
	
	set ClassDef = ##class(%Dictionary.ClassDefinition).%New(ServingReqClass, 25)
	set ClassDef.Super = "Ens.Response"
	
	; Add property for staging data
	set StagingDataClass = ##class(opc.ua.data.Generator).GetClassName(..StagingConfig)
	#dim PropDef As %Dictionary.PropertyDefinition
	set PropDef = ..GetElement(ClassDef.Properties, "Staging")
	set PropDef.Type = StagingDataClass
	set PropDef.SequenceNumber = $Increment(SequenceNumber)
	
	; Add properties for all transforming configurations
	for i = 1:1:..TransformingConfigs.Count() {
		#dim EquipConfig As opc.ua.config.EquipmentConfiguration
		set EquipConfig = ..TransformingConfigs.GetAt(i)
		set DataClass = ##class(opc.ua.data.Generator).GetClassName(EquipConfig)
		set PropName = EquipConfig.Configuration.Name
		set PropDef = ..GetElement(ClassDef.Properties, PropName)
		set PropDef.Type = DataClass
		set PropDef.SequenceNumber = $Increment(SequenceNumber)
	}
	
	; Save
	set sc = ClassDef.%Save()
	if 'sc return sc
	
	return $$$OK
}

/// Adds various components to the production, if not already present
Method UpdateProduction() As %Status
{
	; Create the two routing rules, if they don't exist
	
	set Replacements("{RuleContext}") = "EnsLib.MsgRouter.RoutingEngine"
	set Replacements("{ProductionName}") = ..Production.Name
	
	set TransformRuleClass = ..Equipment.ClassPackage_".rule.TransformRule"
	set sc = ..CreateRule(TransformRuleClass, "Rule", .Replacements)
	if 'sc quit ..BuildStatus("Error creating rule {}", sc, TransformRuleClass)
	
	set ServingRuleClass = ..Equipment.ClassPackage_".rule.ServingRule"
	set sc = ..CreateRule(ServingRuleClass, "Rule", .Replacements)
	if 'sc quit ..BuildStatus("Error creating rule {}", sc, ServingRuleClass)
	
	; Add routers, if not yet present
	
	set Name = "TransformRouter"
	set Settings($i(Settings)) = $lb("Host", "BusinessRuleName", TransformRuleClass)
	set sc = ..AddProductionItem(Name, "EnsLib.MsgRouter.RoutingEngine", .Settings)
	if 'sc return ..BuildStatus("Error adding {} to production:", sc, Name)
	
	set Name = "ServingRouter"
	set Settings($i(Settings)) = $lb("Host", "BusinessRuleName", ServingRuleClass)
	set sc = ..AddProductionItem(Name, "EnsLib.MsgRouter.RoutingEngine", .Settings)
	if 'sc return ..BuildStatus("Error adding {} to production:", sc, Name)
	
	; Add services for equipment, if not yet present
	
	set EquipmentName = ..Equipment.Name
	
	set Name = EquipmentName_"Data"
	set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	set sc = ..AddProductionItem(Name, "opc.ua.service.DataService", .Settings, 1)
	if 'sc return ..BuildStatus("Error adding {} to production:", sc, Name)
	
	set Name = EquipmentName_"ReplayService"
	set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	set sc = ..AddProductionItem(Name, "opc.ua.service.ReplayDataService", .Settings, 0)
	if 'sc return ..BuildStatus("Error adding {} to production:", sc, Name)
	
	set Name = EquipmentName_"Subscription"
	set Settings($i(Settings)) = $lb("Host", "TargetConfigNames", "TransformRouter")
	set sc = ..AddProductionItem(Name, "opc.ua.service.SubscriptionService", .Settings, 0)
	if 'sc return ..BuildStatus("Error adding {} to production:", sc, Name)
	
	; Add email alert operation, if not present
	
	set Name = "EmailAlertOperation"
	set sc = ..AddProductionItem(Name, "EnsLib.EMail.AlertOperation", .Settings, 0)
	if 'sc return ..BuildStatus("Error adding {} to production:", sc, Name)
	
	
	set sc = ..Production.SaveToClass()
	if 'sc return ..BuildStatus("Error saving configuration for production {}:", sc, ..Production.Name)
	
	
	return $$$OK
}

// ===== Production helpers

/// Retrieves the production configuration to be used to add
/// items to. Creates a new default production if one doesn't
/// exist yet.
Method GetProductionConfig(Output Production As Ens.Config.Production) As %Status
{
	; Did we create the production here?
	set IsNew = 0
	
	; Get name of latest running production. If none, use default.
	set ProdName = ##class(Ens.Director).GetActiveProductionName()
	if ProdName = "" set ProdName = ..Equipment.ClassPackage_".Production"
		
	; If the production class doesn't yet exist, create it
	if '##class(%Dictionary.ClassDefinition).%ExistsId(ProdName) {
		set sc = ..CreateProduction(ProdName)
		if 'sc return ..BuildStatus("Error creating new production {}:", sc, ProdName)
		set IsNew = 1
	}
	
	; Create configuration item to return
	set sc = ##class(Ens.Config.Production).LoadFromClass(ProdName)
	if 'sc return ..BuildStatus("Error loading production {} configuration:", sc, ProdName)
	set Production = ##class(Ens.Config.Production).%OpenId(ProdName, , .sc)
	if 'sc return ..BuildStatus("Error opening production {} configuration:", sc, ProdName)
	
	return $$$OK
}

/// Creates a new production with the given name.
ClassMethod CreateProduction(Name As %String) As %Status
{
	; Try to open template production
	set Tpl = ##class(%Dictionary.ClassDefinition).%OpenId("opc.ua.Production", , .sc)
	if sc {
		#dim Prod As %Dictionary.ClassDefinition
		Set Prod = Tpl.%ConstructClone(1)
		Set Prod.Name = Name
		
	} Else {
		; If the template isn't there, create a new production class
		set Prod = ##class(%Dictionary.ClassDefinition).%New(Name, 25)
		set Prod.Super = "Ens.Production"
		set XData = ..GetElement(Prod.XDatas, "ProductionDefinition")
		Do XData.Data.WriteLine("<Production></Production>")
		
	}
	
	set sc = Prod.%Save()
	if 'sc return ..BuildStatus("Error saving new production {}:", sc, Name)
	
	; Production class needs to be compiled for further configuration
	set sc = $System.OBJ.Compile(Name, "cku-d")
	if 'sc return ..BuildStatus("Error compiling new production {}:", sc, Name)
	
	; Create configuration object with a few default settings
	set ProdCfg = ##class(Ens.Config.Production).%New(Name)
	set ProdCfg.Description = "OPC UA Production"
	set ProdCfg.TestingEnabled = 1
	set ProdCfg.ActorPoolSize = 10
	
	; Save configuration
	set sc = ProdCfg.SaveToClass()
	if 'sc return ..BuildStatus("Error saving production configuration:", sc)
	
	return $$$OK
}

/// Adds a new item to the production, but only if it doesn't exist yet.
Method AddProductionItem(Name As %String, ClassName As %String, ByRef Settings As %String, Enabled As %Boolean = 1) As %Status
{
	; Add the item, unless it already exists
	#dim Item As Ens.Config.Item
	set Item = ..AddElement(..Production.Items, Name)
	if Item = "" return $$$OK
	set Item.Enabled = Enabled
	
	set Item.ClassName = ClassName
	if $Get(Settings) do Item.UpdateSettings(.Settings)
	
	if $$$comClassKeyGet(ClassName, $$$cCLASSprimarysuper) [ "~Ens.BusinessProcess~" {
		; set the pool size of business processes to 1, which mimicks what
		; the management portal does when adding one there.
		set Item.PoolSize = 1
	}
	
	kill Settings
	
	return $$$OK
}

// ===== Helpers

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

/// Template data for the automatic generation of a transforming business process
XData TransformProcess [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='{RequestClass}' response='{ResponseClass}' >
<context>
<property name='Staging' type='{DataClassIn}' instantiate='0' />
<property name='Transforming' type='{DataClassOut}' instantiate='1' />
</context>
<sequence  >
<assign name="Data to context" property="context.Staging" value="request.Staging" action="set"  />
<rule name='Process' rule='{RuleClass}' />
<transform name='Transform' class='{TransformClass}' source='context.Staging' target='context.Transforming' />
<call name='Send to ServingRouter' target='ServingRouter' async='1' xpos='200' ypos='1950' >
<request type='{ServingReqClass}' >
<assign property="callrequest.Staging" value="context.Staging" action="set" />
<assign property="callrequest.{TransformingProperty}" value="context.Transforming" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

/// Template data for the automatic generation of a serving business process
XData ServingProcess [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='{RequestClass}' response='{ResponseClass}' >
<context>
<property name='Serving' type='{DataClassOut}' instantiate='1' />
</context>
<sequence  >
<rule name='Process' rule='{RuleClass}' />
<transform name='Transform' class='{TransformClass}' source='request' target='context.Serving' />
</sequence>
</process>
}

/// Template data for the automatic generation of business rules
XData Rule [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="{RuleContext}" production="{ProductionName}">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
</ruleSet>
</ruleDefinition>
}

/// Template data for the automatic generation of dtata transformations
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
