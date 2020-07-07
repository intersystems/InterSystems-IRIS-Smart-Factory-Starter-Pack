/// Machine type 
Class opc.ua.config.EquipmentType Extends (%Persistent, %JSON.Adaptor)
{

/// Name of the equipment type
Property Name As %String(%JSONFIELDNAME = "name") [ Required ];

/// Description of the machine type
Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 1000);

Index EquipmentTypeNameIndex On Name [ Unique ];

/// Get all equipmenttypes
ClassMethod GetAllEquipmentTypes() As %ListOfObjects
{
	set tEquipmentTypeList = ##class(%ListOfObjects).%New()
	
	&sql(DECLARE C1 CURSOR FOR
        SELECT ID INTO :tEquipmentTypeId FROM opc_ua_config.EquipmentType)	       
    &sql(OPEN C1)
    If SQLCODE '= 0 Quit tEquipmentTypeList
    &sql(FETCH C1)
    while (SQLCODE = 0) {
    	set tEquipmentType = ##class(opc.ua.config.EquipmentType).%OpenId(tEquipmentTypeId,,.tSc)    	
    	if ('$$$ISERR(tSc)) {
    		Do tEquipmentTypeList.Insert(tEquipmentType)    		
    	}
    &sql(FETCH C1)
    }
	&sql(CLOSE C1)
		
	return tEquipmentTypeList
}

/// Get the equipmenttype by specifying the name
ClassMethod SearchByName(pName As %String, Output Status As %Status) As opc.ua.config.EquipmentType
{
	set tEquipmentType = ""
	&sql(SELECT ID INTO :tId FROM opc_ua_config.EquipmentType WHERE name=:pName)
	if (SQLCODE = 0) {
		set tEquipmentType =  ##class(opc.ua.config.EquipmentType).%OpenId(tId, , .Status)
		if $$$ISERR(Status) return ""		
	}
	
	return tEquipmentType
}

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
