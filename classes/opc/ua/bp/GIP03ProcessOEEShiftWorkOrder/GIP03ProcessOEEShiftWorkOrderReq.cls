Class opc.ua.bp.GIP03ProcessOEEShiftWorkOrder.GIP03ProcessOEEShiftWorkOrderReq Extends Ens.Request
{

/// Data from the transforming layer
Property TransformData As opc.ua.data.GIP03.transforming.GIP03CONFIG;

/// Data input
Property Data As opc.ua.data.GIP03.serving.GIP03OEESHIFTTIMESLIDE;

Storage Default
{
<Data name="GIP03ProcessOEEShiftWorkOrderReqDefaultData">
<Subscript>"GIP03ProcessOEEShiftWorkOrderReq"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
<Value name="2">
<Value>TransformData</Value>
</Value>
</Data>
<DefaultData>GIP03ProcessOEEShiftWorkOrderReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
