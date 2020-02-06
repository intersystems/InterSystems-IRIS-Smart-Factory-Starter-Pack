/// Machine type 
Class opc.ua.config.EquipmentType Extends %Persistent
{

/// Name of the equipment type
Property Name As %String [ Required ];

/// Description of the machine type
Property Description As %String(MAXLEN = 1000);

Storage Default
{
<Data name="EquipmentTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.EquipmentTypeD</DataLocation>
<DefaultData>EquipmentTypeDefaultData</DefaultData>
<IdLocation>^opc.ua.config.EquipmentTypeD</IdLocation>
<IndexLocation>^opc.ua.config.EquipmentTypeI</IndexLocation>
<StreamLocation>^opc.ua.config.EquipmentTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
