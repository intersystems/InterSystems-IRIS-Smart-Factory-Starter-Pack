/// Yield configuration for the machine
Class opc.ua.config.Yield Extends %Persistent
{

/// Name of the Yield
Property Name As %String [ Required ];

/// Value of the Yield.
/// Value is stored as a String be aware that this field needs to be converted to the correct data type
Property Value As %String;

Storage Default
{
<Data name="YieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.YieldD</DataLocation>
<DefaultData>YieldDefaultData</DefaultData>
<IdLocation>^opc.ua.config.YieldD</IdLocation>
<IndexLocation>^opc.ua.config.YieldI</IndexLocation>
<StreamLocation>^opc.ua.config.YieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
