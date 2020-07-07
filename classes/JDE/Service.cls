Class JDE.Service Extends Ens.BusinessService
{

Parameter ADAPTER;

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	try {
		set obj = {}.%FromJSON(pInput).WorkOrders

		// pOutput holds the number of processed workorders.
		// If something goes wrong, we use it to return an error text.
		set pOutput = 0
		
		// Send each separate workordersItem to the BPL.
		set it = obj.%GetIterator()
		while it.%GetNext(.key,.workorder) {
			set tWO = ##class(JDE.data.incoming.Workorder).%New()
			set st = tWO.%JSONImport(workorder)  $$$ThrowOnError(st)
			
			// Save the incoming data.
			set st = tWO.%Save()  $$$ThrowOnError(st)
			
			// Forward the request to the BPL.
			set req = ##class(JDE.msg.incoming.WorkorderRequest).%New()
			set req.Workorder = tWO
			do ..SendRequestAsync("JDE.dtl.FilterWorkorder",req)
		}
		// Return the number of workorders.
		set pOutput = key
		$$$LOGINFO("JDE Business Service received "_pOutput_" workorders")
	} catch ex {
 //		set msg = $system.Status.GetOneStatusText(st)
 		set msg = ex.DisplayString()
		$$$LOGERROR(msg)
		set pOutput = msg
	}

	quit $$$OK
}

}
