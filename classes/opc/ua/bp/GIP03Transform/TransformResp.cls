/// Transformation Response class with the TransformRecord that has been saved in during the transformation layer.
Class opc.ua.bp.GIP03Transform.TransformResp Extends Ens.Response
{

/// Transforming Data property of the Data Base class
Property Data As opc.ua.data.Base;

Storage Default
{
<Data name="TransformRespDefaultData">
<Subscript>"TransformResp"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>TransformRespDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
