/// GIP03 clear content for the serving layer
Class opc.ua.bp.GIP03ServingClearContent Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='650' >
<trace name='Clear content of the serving tables' value='"Clear content of the serving tables"' xpos='200' ypos='250' >
<annotation><![CDATA[TODO: Remove old order entries needs only that number]]></annotation>
</trace>
<sql name='Delete OEE Shift TimeSlide' xpos='200' ypos='350' >
<![CDATA[delete from opc_ua_data_GIP03_serving.GIP03OEESHIFTTIMESLIDE ]]>
</sql>
<sql name='OEE Shift WorkOrder' xpos='200' ypos='450' >
<![CDATA[DELETE FROM opc_ua_data_GIP03_serving.GIP03OEESHIFTWORKORDER]]>
</sql>
<sql name='OEE Shift' xpos='200' ypos='550' >
<![CDATA[DELETE FROM opc_ua_data_GIP03_serving.GIP03OEESHIFT]]>
</sql>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
