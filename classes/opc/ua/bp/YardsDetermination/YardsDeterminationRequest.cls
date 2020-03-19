Class opc.ua.bp.YardsDetermination.YardsDeterminationRequest Extends Ens.Request
{

Property Readings As opc.ua.data.GIP03.staging.GIP03CONFIG;

Property TransformingRecord As opc.ua.data.GIP03.transforming.GIP03CONFIG;

Storage Default
{
<Data name="YardsDeterminationRequestDefaultData">
<Subscript>"YardsDeterminationRequest"</Subscript>
<Value name="1">
<Value>Readings</Value>
</Value>
<Value name="2">
<Value>TransformingRecord</Value>
</Value>
</Data>
<DefaultData>YardsDeterminationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
