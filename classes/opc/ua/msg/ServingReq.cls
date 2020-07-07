Class opc.ua.msg.ServingReq Extends Ens.Request
{

/// Initial, staged data
Property StagingData As opc.ua.data.Base;

/// Data as transformed in the transforming layer
Property TransformingData As opc.ua.data.Base;

Storage Default
{
<Data name="ServingReqDefaultData">
<Subscript>"ServingReq"</Subscript>
<Value name="1">
<Value>StagingData</Value>
</Value>
<Value name="2">
<Value>TransformingData</Value>
</Value>
</Data>
<DefaultData>ServingReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
