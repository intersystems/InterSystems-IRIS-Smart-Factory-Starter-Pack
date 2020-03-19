/// JDE helper methods.
Class JDE.util.api
{

/// Reads a file with JDE sample data and sends it to the server.
ClassMethod Workorder(filename As %String = "C:\Users\Admin_IA\Desktop\InterSystems\JDE\Voorbeeld JSON WorkOrders_Routing.json") As %Status
{
	set stream = ##class(%Stream.FileCharacter).%New()
	set st = stream.LinkToFile(filename)  if 'st quit st
	
	set req = ##class(%Net.HttpRequest).%New()
	set req.Server = "10.24.255.121"
	set req.Port = 52773
	set req.ContentType = "application/json"
	set req.EntityBody = stream
	set st = req.Post("/jde/workorders")  if 'st quit st
	do req.HttpResponse.OutputToDevice()
	if 'st do $system.OBJ.DisplayError(st)
	quit st
}

/// Creates or updates a REST service class from a Swagger file.
ClassMethod CreateREST(filename As %String = "C:\Users\Admin_IA\Desktop\InterSystems\JDE\swagger.json", namespace As %String = "VLISCO", package As %String = "JDE.rest") As %Status
{
	set stream = ##class(%Stream.FileCharacter).%New()
	set st = stream.LinkToFile(filename)  if 'st quit st
	
	set req = ##class(%Net.HttpRequest).%New()
	set req.Server = "10.24.255.121"
	set req.Port = 52773
	set req.Username = "SuperUser"
	set req.Password = "SuperUser"
	set req.ContentType = "application/json"
	set req.EntityBody = stream
	set st = req.Post("/api/mgmnt/v2/"_namespace_"/"_package)  if 'st quit st
	do req.HttpResponse.OutputToDevice()
	if 'st do $system.OBJ.DisplayError(st)
	quit st
	
	quit $$$OK
}

}
