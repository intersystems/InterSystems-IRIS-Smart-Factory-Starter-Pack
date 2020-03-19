Class opc.ua.bp.GIP03ProcessOEEShiftTimeSlide.GIP03ProcessOEEShiftTimeSlideReq Extends Ens.Request
{

/// Data from the transforming layer
Property TransformData As opc.ua.data.GIP03.transforming.GIP03CONFIG;

/// Data input
Property Data As opc.ua.data.GIP03.transforming.GIP03CONFIG;

Storage Default
{
<Data name="GIP03ProcessOEEShiftTimeSlideReqDefaultData">
<Subscript>"GIP03ProcessOEEShiftTimeSlideReq"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
<Value name="2">
<Value>TransformData</Value>
</Value>
</Data>
<DefaultData>GIP03ProcessOEEShiftTimeSlideReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
