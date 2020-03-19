/// ISO Unit of Measurement
Class opc.ua.config.UoM Extends %Persistent
{

/// Format of the unit
Property Format As %String(MAXLEN = 4);

/// Description of the unit
Property Description As %String(MAXLEN = "");

Storage Default
{
<Data name="UoMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Format</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.UoMD</DataLocation>
<DefaultData>UoMDefaultData</DefaultData>
<IdLocation>^opc.ua.config.UoMD</IdLocation>
<IndexLocation>^opc.ua.config.UoMI</IndexLocation>
<StreamLocation>^opc.ua.config.UoMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
