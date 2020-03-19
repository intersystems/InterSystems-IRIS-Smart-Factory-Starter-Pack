/// 
Class JDE.dtl.FilterWorkorder Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='JDE.msg.incoming.WorkorderRequest' height='2000' width='2000' >
<context>
<property name='FilteredData' type='JDE.data.filtered.Workorder' instantiate='0' />
</context>
<sequence xend='200' yend='550' >
<trace name='Document info' value='"BPL says: Document number is " _ request.Workorder.DocumentNumber_"; # routings in document is "_request.Workorder.Routing.Count()' xpos='200' ypos='250' />
<transform name='Filter workorder' class='JDE.dtl.WorkorderDTL' source='request' target='context.FilteredData' xpos='200' ypos='350' >
<annotation><![CDATA[Retain only the properties we really need (as defined by customer).]]></annotation>
</transform>
<code name='Save filtered data' xpos='200' ypos='450' >
<![CDATA[ do context.FilteredData.%Save()]]>
</code>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
