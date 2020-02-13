Include Ensemble

Class opc.ua.data.Base Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor) [ Abstract ]
{

/// Date/time of measurement
Property TimeStamp As %TimeStamp [ SqlColumnNumber = 2 ];

ClassMethod Insert(Input As opc.ua.rest.Data, Output Id As %String) As %Status
{
	Set Id = ""
	
	; Get data from previous record as default values for this one
	set sc = ..GetLastRecord(.Data)
	if 'sc Quit sc
	
	; Get current readings
	for i = 1:1:Input.Nodes.Count() {
		#dim Node As opc.ua.rest.Node
		set Node = Input.Nodes.GetAt(i)
		set Data(Node.NodeId) = Node.NodeValue
	}
	
	; Save updated readings; this returns the id of the row that was inserted
	set sc = ..SaveData(Input.TimeStamp, .Data, .Id)
	if 'sc Quit sc
	
	quit $$$OK
}

Storage Default
{
<Data name="BaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimeStamp</Value>
</Value>
</Data>
<DataLocation>^opc.ua.data.BaseD</DataLocation>
<DefaultData>BaseDefaultData</DefaultData>
<IdLocation>^opc.ua.data.BaseD</IdLocation>
<IndexLocation>^opc.ua.data.BaseI</IndexLocation>
<StreamLocation>^opc.ua.data.BaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
