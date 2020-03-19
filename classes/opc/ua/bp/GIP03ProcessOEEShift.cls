/// 
Class opc.ua.bp.GIP03ProcessOEEShift Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='opc.ua.bp.GIP03ProcessOEEShift.GIP03ProcessOEEShiftReq' response='opc.ua.bp.GIP03ProcessOEEShift.GIP03ProcessOEEShiftResp' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<trace name='Start OEE Shift' value='"Start processing OEE shift"' xpos='200' ypos='250' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
