/// Workorder and routing data from JD Edwards.<br/>
/// Business logic class defined by OpenAPI in JDE.rest.spec<br/>
/// Updated Mar 10, 2020 14:43:08
Class JDE.rest.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Insert a list of workorders<br/>
/// The method arguments hold values for:<br/>
///     workorders, List of workorders<br/>
ClassMethod addWorkorders(workorders As %Stream.Object) As %DynamicObject
{
	// The classname and the method name are mandatory arguments, but they are not visible in the event log.
	do ##class(Ens.Util.Log).LogInfo($classname(),"addWorkorders","REST service called from "_%request.CgiEnvs("REMOTE_ADDR"))

	set st = $$$OK
	
	// Forward the incoming stream to the Business Service.
	set st = ##class(Ens.Director).CreateBusinessService("JDE.Service",.tService)  $$$ThrowOnError(st)
	set st = tService.ProcessInput(workorders,.result)
	
	if +result = result {
		set tReturnObject = {}.%Set("status","OK").%Set("workorderCount", result)
		do ..%SetStatusCode(201)
	} else {
		set tReturnObject = {}.%Set("status","ERROR").%Set("message",result)
		do ..%SetStatusCode(500)
	}
	do ..%SetHeader("Content-Type","application/json")
	quit tReturnObject
}

}
