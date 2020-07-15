Class opc.ua.msg.TransformingReq Extends Ens.Request
{

/// Initial, staged data
Property Staging As opc.ua.data.Base;

Storage Default
{
<Data name="TransformingReqDefaultData">
<Subscript>"TransformingReq"</Subscript>
<Value name="1">
<Value>Staging</Value>
</Value>
</Data>
<DefaultData>TransformingReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
