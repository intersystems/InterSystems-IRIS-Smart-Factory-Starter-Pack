Class opc.ua.bp.GIP03Serving.GIP03ServingResp Extends Ens.Response
{

/// Serving Data property of the Data Base class
Property Data As opc.ua.data.Base;

Storage Default
{
<Data name="GIP03ServingRespDefaultData">
<Subscript>"GIP03ServingResp"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>GIP03ServingRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
