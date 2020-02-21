/// Business process transforming procedure for the GIP03 machine
Class opc.ua.bp.GIP03Tranform Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.rest.impl.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Status' type='%Status' instantiate='0' >
<annotation><![CDATA[Status]]></annotation>
</property>
<property name='NewTransformingRecord' type='opc.ua.data.GIP03.transforming.GIP03CONFIG' instantiate='1' >
<annotation><![CDATA[New transforming record]]></annotation>
</property>
<property name='Readings' type='opc.ua.data.GIP03.staging.GIP03CONFIG' instantiate='0' />
<property name='Equipment' type='opc.ua.config.Equipment' instantiate='0' >
<annotation><![CDATA[Equiment object]]></annotation>
</property>
</context>
<sequence xend='200' yend='1100' >
<scope xpos='200' ypos='250' xend='200' yend='1000' >
<assign name="Set Context" property="context.Readings" value="request.Readings" action="set" xpos='200' ypos='350' >
<annotation><![CDATA[Request to Context]]></annotation>
</assign>
<assign name="Get Equipment" property="context.Equipment" value="##class(opc.ua.config.Equipment).SearchByName(&quot;GIP03&quot;)" action="set" xpos='200' ypos='450' />
<rule name='Process Events' rule='opc.ua.rule.GIP03Rule'  xpos='200' ypos='550' >
</rule>
<transform name='Transformation' class='opc.ua.dtl.GIP03Transform' source='request.Readings' target='context.NewTransformingRecord' xpos='200' ypos='650' />
<assign name="Save Transforming Record" property="context.Status" value="context.NewTransformingRecord.%Save()" action="set" xpos='200' ypos='750' />
<faulthandlers>
<catchall xpos='200' ypos='850' xend='200' yend='350' >
<alert value='"Error ["_context.Status_"]"' xpos='200' ypos='250' />
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
