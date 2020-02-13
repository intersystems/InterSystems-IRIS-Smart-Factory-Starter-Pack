/// Workorder and routing data from JD Edwards.<br/>
/// Business logic class defined by OpenAPI in JDE.spec<br/>
/// Created Feb 13, 2020 13:56:52
Class JDE.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Insert a list of workorders<br/>
/// The method arguments hold values for:<br/>
///     body, List of workorders<br/>
ClassMethod addWorkorders(body As %Stream.Object) As %DynamicObject
{
	do ..%SetStatusCode(200)
	do ..%SetHeader("Content-Type","application/json")
	
	set st = $$$OK
	try {
		set tWorkOrdersRouting = ##class(JDE.data.WorkOrdersRouting).%New()
		set st = tWorkOrdersRouting.%JSONImport(%request.Content)  $$$ThrowOnError(st)
		set st = tWorkOrdersRouting.%Save()  $$$ThrowOnError(st)
		set tReturnObject = {}.%Set("status","OK").%Set("workorderCount",tWorkOrdersRouting.WorkOrders.Count()).%Set("routingCounts",{})
		for i=1:1:tWorkOrdersRouting.WorkOrders.Count() {
			set st = tReturnObject.routingCounts.%Set("workorder "_i,tWorkOrdersRouting.WorkOrders.GetAt(i).Routing.Count())
		}
	} catch {
		set tReturnObject = {}.%Set("status","ERROR").%Set("message",$system.Status.GetOneStatusText(st))
	}
	quit tReturnObject
}

}
