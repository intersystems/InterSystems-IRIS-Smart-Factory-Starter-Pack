Class opc.ua.bp.GIP03ProcessOEEShift.GIP03ProcessOEEShiftResp Extends Ens.Response
{

/// Data output
Property Data As opc.ua.data.GIP03.serving.GIP03OEESHIFT;

Storage Default
{
<Data name="GIP03ProcessOEEShiftRespDefaultData">
<Subscript>"GIP03ProcessOEEShiftResp"</Subscript>
<Value name="1">
<Value>DataOut</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>GIP03ProcessOEEShiftRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
