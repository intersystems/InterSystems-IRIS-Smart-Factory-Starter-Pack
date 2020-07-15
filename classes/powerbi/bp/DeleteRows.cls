/// Delete all rows in the table
Class powerbi.bp.DeleteRows Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='powerbi.bo.Api.DeleteRowsRequest' response='powerbi.bo.Api.DeleteRowsResponse' height='2000' width='2000' >
<sequence xend='200' yend='700' >
<scope xpos='200' ypos='250' xend='200' yend='600' >
<call name='Delete rows in table' target='PowerBI.API' async='0' xpos='200' ypos='350' >
<request type='powerbi.bo.Api.DeleteRowsRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='powerbi.bo.Api.DeleteRowsResponse' />
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
