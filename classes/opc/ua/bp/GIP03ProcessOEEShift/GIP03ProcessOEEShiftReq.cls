Class opc.ua.bp.GIP03ProcessOEEShift.GIP03ProcessOEEShiftReq Extends Ens.Request
{

/// Data from the transforming layer
Property TransformData As opc.ua.data.GIP03.transforming.GIP03CONFIG;

/// Data input
Property Data As opc.ua.data.GIP03.serving.GIP03OEESHIFTWORKORDER;

Storage Default
{
<Data name="GIP03ProcessOEEShiftReqDefaultData">
<Subscript>"GIP03ProcessOEEShiftReq"</Subscript>
<Value name="1">
<Value>DataIn</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
<Value name="3">
<Value>TransformData</Value>
</Value>
</Data>
<DefaultData>GIP03ProcessOEEShiftReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
