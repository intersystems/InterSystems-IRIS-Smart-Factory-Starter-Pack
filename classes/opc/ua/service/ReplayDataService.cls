/// ReplayDataService
Class opc.ua.service.ReplayDataService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "Equipment:Replay:,Configuration:Replay:,FromTimeStamp:Replay:,UseOriginalTimeStamp:Replay:,TargetConfigNames:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// Equipment
Property Equipment As %String [ Required ];

/// Property configuration name
Property Configuration As %String [ Required ];

/// The target for the trigger.
Property TargetConfigNames As %String;

/// Don't use the original timestamp but use the current to fake 
/// that the machines are running
Property UseOriginalTimeStamp As %Boolean(DISPLAYLIST = ",False,True", VALUELIST = ",0,1") [ InitialExpression = 0 ];

/// Replay from a particular timestamp 
Property FromTimeStamp As %TimeStamp;

/// OnInit
Method OnInit() As %Status
{
	/// Reset the global
	do ..Reset()
	
	set tLogMsg = "Start Replay data service for equipment ["_..Equipment_"]"
	if ..FromTimeStamp '= "" set tLogMsg = tLogMsg_" from ["_..FromTimeStamp_"]"
	$$$LOGINFO(tLogMsg)
	
	return $$$OK
}

/// OnProcessInput
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	/// Get next Record
	#dim Record As opc.ua.data.Base
	set Record = ..QueryNextRecord(.tSC)
	if $$$ISERR(tSC) Quit tSC
	
	if Record = "" {
		$$$LOGINFO("No record returned, resetting.")
		do ..Reset() /// Reset and start over
		
	} else {
		$$$LOGINFO("Resending record '"_Record.%Id()_"' ("_Record.TimeStamp_").")
		
		#dim tReq As opc.ua.rest.impl.Request
		set tReq = ##class(opc.ua.rest.impl.Request).%New()
		
		; Create new copy of record
		Set Record = Record.%ConstructClone()
		
		/// Temporary to simulate the machine is running without deleting previous 
		///transforming data for now
		if '..UseOriginalTimeStamp {
			set Record.TimeStamp = $ZDATETIME($ZTIMESTAMP,3)
		}	
		
		set tReq.Readings = Record
		set tSC = ..SendRequestAsync(..TargetConfigNames, tReq)
	}
					
	Quit tSC
}

/// Reset the last replayed record and start over again
Method Reset()
{
	Kill $$$EnsRuntimeAppData(..%ConfigName)
}

/// Retrieve next record
Method QueryNextRecord(Output pSC As %Status) As opc.ua.data.Base
{
	set Parms = 0
	set tQuery = "SELECT TOP 1 ID, TimeStamp FROM opc_ua_data_"_..Equipment_"_staging."_..Configuration_" WHERE"
	if ..FromTimeStamp '= ""
	{
		set tQuery = tQuery_" TimeStamp >= ? AND "
		Set Parms($Increment(Parms)) = ..FromTimeStamp
	}	
	set tQuery = tQuery_" ID > ? ORDER BY TimeStamp ASC"
	Set Parms($Increment(Parms)) = $Get($$$EnsRuntimeAppData(..%ConfigName), 0)
	
	Set p = "" For i = 1:1:Parms { Set:i>1 p=p_", " Set p = p_Parms(i) }
	$$$TRACE("Query next record ["_tQuery_"] / "_p)
	
	#dim rs As %SQL.StatementResult
	set rs = ##class(%SQL.Statement).%ExecDirect(, tQuery, Parms...)
	
	if 'rs.%Next(.pSC) Quit ""
	
	/// Update last replayed processed
	set $$$EnsRuntimeAppData(..%ConfigName) = rs.ID
	$$$TRACE("Last record ["_rs.ID_"]")
	
	set Record = ##class(opc.ua.data.Base).%OpenId(rs.ID,,.pSC)
	return Record
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
