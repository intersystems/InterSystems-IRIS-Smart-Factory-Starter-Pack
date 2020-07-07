/// Brigde class between Machine and Configuration
Class opc.ua.config.EquipmentConfiguration Extends %Persistent
{

/// Machine many-to-many relationship
Relationship Equipment As opc.ua.config.Equipment [ Cardinality = one, Inverse = EquipmentConfiguration ];

Index EquipmentIndex On Equipment;

/// Configuration many-to-many relationship	
Relationship Configuration As opc.ua.config.Configuration [ Cardinality = one, Inverse = EquipmentConfiguration ];

Index ConfigurationIndex On Configuration;

// =====

/// Returns the equipment configuration for the given combination of
/// equipment name and (currently valid) configuration name.
ClassMethod Get(EquipmentName As %String, ConfigType As %String, ConfigName As %String, Output Status As %Status) As opc.ua.config.EquipmentConfiguration
{
	&sql(SELECT ID INTO :Id FROM EquipmentConfiguration
	      WHERE Equipment->Name = :EquipmentName
	        AND Configuration->Name = :ConfigName
	        AND Configuration->ConfigType = :ConfigType
	        AND Configuration->IsCurrentVersion = 1)
	
	; Not found: done
	if SQLCODE {
		set Status = $$$ERROR($$$SQLError, SQLCODE, $Get(%msg))
		return ""
	}
	
	; Open; return error if this fails
	set EquipmentConfig = ..%OpenId(Id, , .Status)
	
	return EquipmentConfig
}

/// Returns all equipment configurations (i.e., staging, transforming,
/// serving) for a given combination of equipment and configuration names.
Query ByEquipmentCfg(EquipmentName As %String, ConfigName As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID
  FROM EquipmentConfiguration
 WHERE Equipment->Name = :EquipmentName
   AND Configuration->Name = :ConfigName
   AND Configuration->IsCurrentVersion = 1
}

// =====

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
