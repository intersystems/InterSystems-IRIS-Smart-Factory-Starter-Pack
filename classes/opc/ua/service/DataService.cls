Class opc.ua.service.DataService Extends Ens.BusinessService
{

Parameter ADAPTER;

Parameter SETTINGS = "TargetConfigNames:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// The target for the trigger.
Property TargetConfigNames As %String;

// =====

/// Called from the REST service
/// TODO: create a proper REST Business Service for this!
Method SendData(DataObj As opc.ua.data.Base) As %Status
{
	set Req = ##class(opc.ua.rest.impl.Request).%New()
	set Req.Readings = DataObj
	
	set sc = ..SendRequestAsync(..TargetConfigNames, Req)
	if 'sc return sc
	
	return $$$OK
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
