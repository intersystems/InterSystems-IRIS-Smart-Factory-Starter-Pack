/// Brigde class between Machine and Configuration
Class opc.ua.config.EquipmentConfiguration Extends %Persistent
{

/// Machine many-to-many relationship
Relationship Equipment As opc.ua.config.Equipment [ Cardinality = one, Inverse = EquipmentConfiguration ];

Index EquipmentIndex On Equipment;

/// Configuration many-to-many relationship	
Relationship Configuration As opc.ua.config.Configuration [ Cardinality = one, Inverse = ConfigurationEquipment ];

Index ConfigurationIndex On Configuration;


Storage Default
{
<Data name="EquipmentConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Equipment</Value>
</Value>
<Value name="3">
<Value>Configuration</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.EquipmentConD9CD</DataLocation>
<DefaultData>EquipmentConfigurationDefaultData</DefaultData>
<IdLocation>^opc.ua.config.EquipmentConD9CD</IdLocation>
<IndexLocation>^opc.ua.config.EquipmentConD9CI</IndexLocation>
<StreamLocation>^opc.ua.config.EquipmentConD9CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
