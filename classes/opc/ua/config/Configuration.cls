/// Machine configuration
Class opc.ua.config.Configuration Extends %Persistent
{

/// Name of the configuration
Property Name As %String [ Required ];

/// Description of the configuration
Property Description As %String(MAXLEN = 1000);

/// Version of the configuration
Property Version As %String;

/// Current version of the configuration
Property IsCurrentVersion As %Boolean [ InitialExpression = 0 ];

/// Begin time of this configuration
Property EffectiveBegin As %TimeStamp;

/// End time of this configuration
Property EffectiveEnd As %TimeStamp;

/// Bridge property for many-to-many relationship to configuration
Relationship ConfigurationMachine As opc.ua.config.EquipmentConfiguration [ Cardinality = many, Inverse = Configuration ];

/// Bridge property for many-to-many relationship to tag
Relationship ConfigurationNode As opc.ua.config.ConfigurationNode [ Cardinality = many, Inverse = Configuration ];

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>version</Value>
</Value>
<Value name="4">
<Value>isCurrent</Value>
</Value>
<Value name="5">
<Value>isCurrentVersion</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Version</Value>
</Value>
<Value name="8">
<Value>IsCurrentVersion</Value>
</Value>
<Value name="9">
<Value>EffectiveBegin</Value>
</Value>
<Value name="10">
<Value>EffectiveEnd</Value>
</Value>
<Value name="11">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^opc.ua.config.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<IdLocation>^opc.ua.config.ConfigurationD</IdLocation>
<IndexLocation>^opc.ua.config.ConfigurationI</IndexLocation>
<StreamLocation>^opc.ua.config.ConfigurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
