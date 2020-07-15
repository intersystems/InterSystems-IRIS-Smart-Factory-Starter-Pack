Class powerbi.bo.Api Extends Ens.BusinessOperation
{

Parameter SETTINGS = "TenantId:PowerBI,ClientId:PowerBI,GroupId:PowerBI,DatasetId:PowerBI,Credentials:PowerBI:credentialsSelector,RowsPerPost:PowerBI";

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// The tenant (application owner) id
Property TenantId As %String;

/// The client (application) id
Property ClientId As %String;

/// The group id (containing the datasets)
Property GroupId As %String;

/// The default dataset id to use in PostRows and DeleteRows, if
/// no dataset id is passed in the request.
Property DatasetId As %String;

/// The credentials object containing the client secret to use
Property Credentials As %String [ InitialExpression = "None" ];

/// The number of rows to send in a POST request to PowerBI. If this
/// is one or less, each row is sent immediately. Otherwise, rows
/// are cached until at least this number of rows is present.
Property RowsPerPost As %Integer [ InitialExpression = 1 ];

// -----

/// Cached access token
Property AccessToken As %String(MAXLEN = 4096);

/// Cached rows, if collecting rows is enabled
Property Rows As array Of %ListOfObjects;

// =====

/// Creates a dataset in the configured tenant/client/group
Method CreateDataset(Request As powerbi.bo.Api.CreateDatasetRequest, Output Response As powerbi.bo.Api.CreateDatasetResponse) As %Status
{
	Set Response = ##class(powerbi.bo.Api.CreateDatasetResponse).%New()
	
	Set Req = ##class(%Net.HttpRequest).%New()
	Set Req.ContentType = "application/json"
	
	Set sc = Request.%JSONExportToStream(Req.EntityBody)
	If 'sc Quit ..BuildStatus("Error exporting to JSON:", sc)
	
	Set Url = "/v1.0/myorg/groups/"_..GroupId_"/datasets"
	
	#dim Resp As %Net.HttpResponse
	Set sc = ..SendWithToken(.Resp, "Post", Req, , , Url)
	If 'sc Quit sc
	
	Set sc = Response.%JSONImport(Resp.Data)
	If 'sc Quit ..BuildStatus("Error loading JSON:", sc)
	
	Quit $$$OK
}

/// Updates a table in an existing dataset
Method UpdateTable(Request As powerbi.bo.Api.UpdateTableRequest, Output Response As powerbi.bo.Api.UpdateTableResponse) As %Status
{
	Set Response = ##class(powerbi.bo.Api.UpdateTableResponse).%New()
	
	; Dataset id may be passed in or configured here
	Set DatasetId = Request.dataSetId
	If DatasetId = "" Set DatasetId = ..DatasetId
	
	Set Req = ##class(%Net.HttpRequest).%New()
	Set Req.ContentType = "application/json"
	
	Set sc = Request.Table.%JSONExportToStream(Req.EntityBody)
	If 'sc Quit ..BuildStatus("Error exporting to JSON:", sc)
	
	Set Url = "/v1.0/myorg/groups/"_..GroupId_"/datasets/"_DatasetId_"/tables/"_Request.Table.name
	
	#dim Resp As %Net.HttpResponse
	Set sc = ..SendWithToken(.Resp, "Put", Req, , , Url)
	If 'sc Quit sc
	
	Quit $$$OK
}

/// Adds rows to a specific table in a dataset
Method PostRows(Request As powerbi.bo.Api.PostRowsRequest, Output Response As powerbi.bo.Api.PostRowsResponse) As %Status
{
	Set Response = ##class(powerbi.bo.Api.PostRowsResponse).%New()
	
	; Dataset id may be passed in or configured here
	Set DatasetId = Request.dataSetId
	If DatasetId = "" Set DatasetId = ..DatasetId
	
	If Request.Replace {
		; We are requested to do a delete before insert
		Set CallReq = ##class(powerbi.bo.Api.DeleteRowsRequest).%New()
		Set CallReq.datasetId = DatasetId
		Set CallReq.tableName = Request.tableName
		Set sc = ..DeleteRows(CallReq, .CallResp)
		If 'sc Quit ..BuildStatus("Error deleting existing rows:", sc)
	}
	
	If ..RowsPerPost > 1 {
		; Minimum number of rows per POST request configured. Collect the
		; rows per dataset/table
		Set Key = $lb(DatasetId, Request.tableName)
		
		Set Cached = ..Rows.GetAt(Key)
    If '$IsObject(Cached) Set Cached = ##class(%ListOfDataTypes).%New()
		
		; Add rows from request to cache. Always doing this ensures proper order of rows.
		For i = 1:1:Request.rows.Size Do Cached.Insert(Request.rows.GetAt(i))
		
		If Cached.Size < ..RowsPerPost, 'Request.FlushCache {
			; Not enough rows to post yet; store in cache and exit
			$$$TRACE("Caching row.")
			Do ..Rows.SetAt(Cached, Key)
			Return $$$OK
		}
		
		; Enough rows: place all in request and clear cache
		$$$TRACE("About to send "_Cached.Size_" rows.")
		Set Request.rows = Cached
		Do ..Rows.RemoveAt(Key)
	}
	
	Set Req = ##class(%Net.HttpRequest).%New()
	Set Req.ContentType = "application/json"
	
	; Top-level object should contain one property "rows". Create the
	; JSON list manually, as the input consists of JSON strings as well.
	Do Req.EntityBody.Write("{""rows"":")
	Set sc = ..ListToJSON(Request.rows, Req.EntityBody)
	If 'sc Quit ..BuildStatus("Error creating JSON request", sc)
	Do Req.EntityBody.Write("}")
	
	Set Url = "/v1.0/myorg/groups/"_..GroupId_"/datasets/"_DatasetId_"/tables/"_Request.tableName_"/rows"
	
	#dim Resp As %Net.HttpResponse
	Set sc = ..SendWithToken(.Resp, "Post", Req, , , Url)
	If 'sc Quit sc
	
	Quit $$$OK
}

/// Deletes all rows for a specific table in a dataset
Method DeleteRows(Request As powerbi.bo.Api.DeleteRowsRequest, Output Response As powerbi.bo.Api.DeleteRowsResponse) As %Status
{
	Set Response = ##class(powerbi.bo.Api.PostRowsResponse).%New()
	
	Set Req = ##class(%Net.HttpRequest).%New()
	Set Req.ContentType = "application/json"
	
	Set DatasetId = Request.datasetId
	If DatasetId = "" Set DatasetId = ..DatasetId
	
	Set Url = "/v1.0/myorg/groups/"_..GroupId_"/datasets/"_DatasetId_"/tables/"_Request.tableName_"/rows"
	
	#dim Resp As %Net.HttpResponse
	Set sc = ..SendWithToken(.Resp, "Delete", Req, , , Url)
	If 'sc Quit sc
	
	; Clear cache for this table
	Set CacheKey = $lb(DatasetId, Request.tableName)
	Do ..Rows.RemoveAt(CacheKey)
	
	Quit $$$OK
}

// -----

/// Sends an HTTP request with a Bearer access token; refreshes the
/// token automatically if it has expired.
Method SendWithToken(Output HttpResponse As %Net.HttpResponse, Op As %String, HttpRequest As %Net.HttpRequest, FormVarNames As %String, ByRef Data, Url As %String) As %Status
{
	; Make sure we have an access token
	If ..AccessToken = "" {
		Set ..AccessToken = ..GetAccessToken(.sc)
		If 'sc Quit sc
		Set IsFresh = 1
	} Else {
		Set IsFresh = 0
	}
	
	Do HttpRequest.SetHeader("Authorization", "Bearer "_..AccessToken)
	Set sc = ..Adapter.SendFormDataArray(.HttpResponse, .Op, .HttpRequest, .FormVarNames, .Data, .Url)
	If 'sc, 'IsFresh, $System.Status.GetErrorCodes(sc) = "<Ens>ErrHTTPStatus", HttpResponse.StatusCode = "403" {
		; Check for token expiration
		Set Json = {}.%FromJSON(HttpResponse.Data)
		If Json.error.code '= "TokenExpired" Quit sc
		
		; Get a fresh access token...
		Set ..AccessToken = ..GetAccessToken(.sc)
		If 'sc Quit sc
		
		; ... and try call again
		Do HttpRequest.SetHeader("Authorization", "Bearer "_..AccessToken)
		Set sc = ..Adapter.SendFormDataArray(.HttpResponse, .Op, .HttpRequest, .FormVarNames, .Data, .Url)
		If 'sc Quit sc
		
	} ElseIf 'sc {
		Quit ..BuildStatus("Error posting to {}", sc, Url)
	}
	
	Quit $$$OK
}

/// Helper method to retrieve a valid access token. Does not use the
/// settings of this BO (other than the SSL configuration).
Method GetAccessToken(Output Status As %Status) As %String
{
	; Open credentials object
	Set Credentials = ##class(Ens.Config.Credentials).%OpenId(..Credentials, , .Status)
	If 'Status Set Status = ..BuildStatus("Error opening credentials:", Status) Return ""
	Set ClientSecret = Credentials.Password
	
	Set Req = ##class(%Net.HttpRequest).%New()
	Set Req.SSLConfiguration = ..Adapter.SSLConfig
	Set Req.Server = "login.microsoftonline.com"
	Set Req.Https = 1
	
	do Req.InsertFormData("grant_type", "client_credentials")
	do Req.InsertFormData("client_id", ..ClientId)
	do Req.InsertFormData("scope", "https://analysis.windows.net/powerbi/api/.default")
	do Req.InsertFormData("client_secret", ClientSecret)
	
	; Url to use contains tenant id
	Set Url = "/"_..TenantId_"/oauth2/v2.0/token"
	
	#dim Resp As %Net.HttpResponse
	Set Status = Req.Get(Url)
	If 'Status Set Status = ..BuildStatus("Error getting access token:", Status) Return ""
	
	Set Json = {}.%FromJSON(Req.HttpResponse.Data)
	Set Token = Json."access_token"
	
	Quit Token
}

/// OnInit is used to make sure required settings are present.
Method OnInit() As %Status
{
	If ..TenantId = "" Quit $$$ERROR($$$GeneralError, "TenantId not specified.")
	If ..ClientId = "" Quit $$$ERROR($$$GeneralError, "ClientId not specified.")
	If ..GroupId = "" Quit $$$ERROR($$$GeneralError, "GroupId not specified.")
	If ..Credentials = "" Quit $$$ERROR($$$GeneralError, "Credentials not specified.")
	
	Quit $$$OK
}

/// Prefixes an existing error status with additional information.
ClassMethod BuildStatus(Message As %String, Status As %Status, Args... As %String) As %Status
{
	; Replace parameter references ("{}") in message, if any, with
	; the appropriate parameters
	For i = 1:1:$Get(Args) {
		Set Message = $Replace(Message, "{}", $Get(Args(i)),, 1)
	}
	Set MsgStatus = $$$ERROR($$$GeneralError, Message)
	
	; Use EmbedStatus instead of AppendStatus, because Ensemble doesn't
	; display the latter properly.
	
	Return $System.Status.EmbedStatus(MsgStatus, Status)
}

/// Writes a JSON string for a list of JSON-enabled objects
/// to a stream. Also accepts a list of strings, presumed to
/// be valid JSON strings.
ClassMethod ListToJSON(Data As %Collection.AbstractList, ByRef Stream As %Stream.Object) As %Status
{
	Set sc = Stream.Write("[")
	If 'sc Quit sc
	
	For i = 1:1:Data.Count() {
		If i > 1 Do Stream.Write(",")
		
		Set Item = Data.GetAt(i)
		If $IsObject(Item) {
			#dim Item As %JSON.Adaptor
			Set sc = Item.%JSONExportToString(.Json)
			If 'sc Return sc
			Set sc = Stream.Write(Json)
			
		} Else {
			Set sc = Stream.Write(Item)
			
		}
		If 'sc Return sc
	}
	
	Set sc = Stream.Write("]")
	If 'sc Quit sc
	
	Quit $$$OK
}

// =====

XData MessageMap
{
<MapItems>
	<MapItem MessageType="powerbi.bo.Api.CreateDatasetRequest"> 
		<Method>CreateDataset</Method>
	</MapItem>
	
	<MapItem MessageType="powerbi.bo.Api.UpdateTableRequest"> 
		<Method>UpdateTable</Method>
	</MapItem>
	
	<MapItem MessageType="powerbi.bo.Api.PostRowsRequest"> 
		<Method>PostRows</Method>
	</MapItem>
	
	<MapItem MessageType="powerbi.bo.Api.DeleteRowsRequest"> 
		<Method>DeleteRows</Method>
	</MapItem>
	
</MapItems>
}

}
