/// Post rows in the tablename
Class powerbi.bp.PostRows Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='powerbi.bo.Api.PostRowsRequest' response='powerbi.bo.Api.PostRowsResponse' height='2000' width='2000' >
<sequence xend='200' yend='700' >
<scope xpos='200' ypos='250' xend='200' yend='600' >
<call name='Post Rows' target='PowerBI.API' async='0' xpos='200' ypos='350' >
<request type='powerbi.bo.Api.PostRowsRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='powerbi.bo.Api.PostRowsResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<faulthandlers>
<catchall xpos='200' ypos='450' xend='200' yend='450' >
<assign name="Set ErrorCode" property="response.error.ErrorCode" value="$System.Status.GetErrorCodes(context.%LastError)" action="set" xpos='200' ypos='250' />
<assign name="Set ErrorMessage" property="response.error.ErrorMessage" value="$System.Status.GetErrorText(context.%LastError)" action="set" xpos='200' ypos='350' />
</catchall>
</faulthandlers>
</scope>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
