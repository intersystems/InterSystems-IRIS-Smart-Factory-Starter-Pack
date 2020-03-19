Class opc.ua.bp.GIP03Serving.GIP03ServingReq Extends Ens.Request
{

/// Serving Data property of the Data Base class
Property Data As opc.ua.data.Base;

Storage Default
{
<Data name="GIP03ServingReqDefaultData">
<Subscript>"GIP03ServingReq"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>GIP03ServingReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
