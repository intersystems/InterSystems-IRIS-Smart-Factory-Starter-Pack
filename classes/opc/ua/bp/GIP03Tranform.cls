/// Business process transforming procedure for the GIP03 machine
Class opc.ua.bp.GIP03Tranform Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.rest.impl.Request' response='opc.ua.bp.GIP03Transform.TransformResp' height='2650' width='2000' >
<context>
<property name='Status' type='%Status' instantiate='0' >
<annotation><![CDATA[Status]]></annotation>
</property>
<property name='TransformingRecord' type='opc.ua.data.GIP03.transforming.GIP03CONFIG' instantiate='1' >
<annotation><![CDATA[New transforming record]]></annotation>
</property>
<property name='Readings' type='opc.ua.data.GIP03.staging.GIP03CONFIG' instantiate='0' />
<property name='Equipment' type='opc.ua.config.Equipment' instantiate='0' >
<annotation><![CDATA[Equiment object]]></annotation>
</property>
<property name='MisPassYield' type='%Double' initialexpression='0' instantiate='0' />
<property name='MT41' type='%Integer' instantiate='0' >
<annotation><![CDATA[Needed because Rule Editor don't like MT4_1]]></annotation>
</property>
<property name='MT42' type='%Integer' instantiate='0' />
<property name='MT43' type='%Integer' instantiate='0' />
<property name='MT44' type='%Integer' instantiate='0' />
<property name='MT45' type='%Integer' instantiate='0' />
<property name='MT46' type='%Integer' instantiate='0' />
<property name='MT47' type='%Integer' instantiate='0' />
</context>
<sequence xend='200' yend='2400' >
<scope xpos='200' ypos='250' xend='200' yend='2300' >
<assign name="Set Context" property="context.Readings" value="request.Readings" action="set" xpos='200' ypos='350' >
<annotation><![CDATA[Request to Context]]></annotation>
</assign>
<assign name="Get Equipment" property="context.Equipment" value="##class(opc.ua.config.Equipment).SearchByName(&quot;GIP03&quot;)" action="set" xpos='200' ypos='450' />
<assign name="Get Mispass Yield" property="context.MisPassYield" value="context.Equipment.GetYield(&quot;MISPASS_MT_4&quot;)" action="set" xpos='200' ypos='550' />
<rule name='Process Events' rule='opc.ua.rule.GIP03Rule'  xpos='200' ypos='650' >
</rule>
<transform name='Transformation' class='opc.ua.dtl.GIP03Transform' source='request.Readings' target='context.TransformingRecord' xpos='200' ypos='750' />
<call name='Determine yards' target='YardsDetermination' async='0' xpos='200' ypos='850' >
<request type='opc.ua.bp.YardsDetermination.YardsDeterminationRequest' >
<assign property="callrequest.Readings" value="context.Readings" action="set" />
<assign property="callrequest.TransformingRecord" value="context.TransformingRecord" action="set" />
</request>
<response type='opc.ua.bp.YardsDetermination.YardsDeterminationResponse' >
<assign property="status" value="context.TransformingRecord.%Reload()" action="set" />
</response>
</call>
<assign name="MT41" property="context.MT41" value="context.Readings.&quot;MT4_1&quot;" action="set" xpos='200' ypos='950' />
<assign name="MT42" property="context.MT42" value="context.Readings.&quot;MT4_2&quot;" action="set" xpos='200' ypos='1050' />
<assign name="MT43" property="context.MT43" value="context.Readings.&quot;MT4_3&quot;" action="set" xpos='200' ypos='1150' />
<assign name="MT44" property="context.MT44" value="context.Readings.&quot;MT4_4&quot;" action="set" xpos='200' ypos='1250' />
<assign name="MT45" property="context.MT45" value="context.Readings.&quot;MT4_5&quot;" action="set" xpos='200' ypos='1350' />
<assign name="MT46" property="context.MT46" value="context.Readings.&quot;MT4_6&quot;" action="set" xpos='200' ypos='1450' />
<assign name="MT47" property="context.MT47" value="context.Readings.&quot;MT4_7&quot;" action="set" xpos='200' ypos='1550' />
<rule name='Post Processing Events' rule='opc.ua.rule.GIP03PostProcessRule'  xpos='200' ypos='1650' >
</rule>
<assign name="Save Transforming Record" property="context.Status" value="context.TransformingRecord.%Save()" action="set" xpos='200' ypos='1750' />
<assign name="Set Response" property="response.Data" value="context.TransformingRecord" action="set" xpos='200' ypos='1850' />
<call name='Send to ServingRouter' target='ServingRouter' async='1' xpos='200' ypos='1950' >
<request type='opc.ua.bp.GIP03Serving.GIP03ServingReq' >
<assign property="callrequest.Data" value="response.Data" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait' calls='Send to ServingRouter' type='all' xpos='200' ypos='2050' >
<annotation><![CDATA[Wait until serving router is finished]]></annotation>
</sync>
<faulthandlers>
<catchall xpos='200' ypos='2150' xend='200' yend='350' >
<alert value='"Error ["_context.Status_"] with last error ["_$ZERROR_"]"' xpos='200' ypos='250' />
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
