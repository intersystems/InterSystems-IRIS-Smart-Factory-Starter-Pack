/// Bridge between the Configurations and the Node
Class opc.ua.config.ConfigurationNode Extends %Persistent
{

/// Configuration many-to-many relationship
Relationship Configuration As opc.ua.config.Configuration [ Cardinality = one, Inverse = ConfigurationNode ];

Index ConfigurationIndex On Configuration;

/// Node many-to-many relationship
Relationship Node As opc.ua.config.Node [ Cardinality = one, Inverse = NodeConfiguration ];

Index NodeIndex On Node;

Storage Default
{
<Data name="ConfigurationNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Configuration</Value>
</Value>
<Value name="3">
<Value>Node</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.Configurati77A2D</DataLocation>
<DefaultData>ConfigurationNodeDefaultData</DefaultData>
<IdLocation>^opc.ua.config.Configurati77A2D</IdLocation>
<IndexLocation>^opc.ua.config.Configurati77A2I</IndexLocation>
<StreamLocation>^opc.ua.config.Configurati77A2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
