/// String data 
Class opc.ua.rest.data.Data Extends (%SerialObject, %JSON.Adaptor)
{

/// Timestamp in ODBC UTC format
Property TimeStamp As %TimeStamp(%JSONFIELDNAME = "timestamp");

/// Nodes list
Property Nodes As list Of opc.ua.rest.data.Node(%JSONFIELDNAME = "nodes");

/// Method overridden to pre-process the data before loading in this object
Method %JSONImport(input, %mappingName As %String = "") As %Status [ ServerOnly = 1 ]
{
	; Make sure nodes[].nodevalue is of type string, or import will fail
	if input.%GetTypeOf("nodes") = "array" {
		set it = input.nodes.%GetIterator()
		while it.%GetNext(.k, .v) {
			if v.%GetTypeOf("nodevalue") = "string" continue
			do v.%Set("nodevalue", v.nodevalue, "string")
		}
	}
	Quit ##super(input, %mappingName)
}

/// Test method to discover the JSON will be written
ClassMethod TestJSONOutput() As %String
{

	#dim tData As opc.ua.rest.data.Data
	set tData = ##class(opc.ua.rest.data.Data).%New()
	
	set tData.TimeStamp = $ZDATETIME($ZTIMESTAMP,3,1)
	
	#dim tNode1 As opc.ua.rest.data.Node
	set tNode1 = ##class(opc.ua.rest.data.Node).%New()
	set tNode1.NodeId = "ns=2;s=Dynamic/RandomInt64"
	set tNode1.NodeValue = -8814383624847064391
	
	#dim tNode2 As opc.ua.rest.data.Node
	set tNode2 = ##class(opc.ua.rest.data.Node).%New()
	set tNode2.NodeId = "ns=2;s=Dynamic/RandomDouble"
	set tNode2.NodeValue = 0.6347237427646675
	
	do tData.Nodes.Insert(tNode1)
	do tData.Nodes.Insert(tNode2)
	
	do tData.%JSONExportToString(.output)
	return output
}

/// Test JSON input and give one of the nodevalues back
ClassMethod TestJSONInput(pJSON As %String)
{
		
	write "JSON ["_pJSON_"] "
		
	#dim tData As opc.ua.rest.data.Data
	set tData = ##class(opc.ua.rest.data.Data).%New()
	do tData.%JSONImport(pJSON)
		
	write "Timestamp ["_tData.TimeStamp_"] "
	write "Number of nodes ["_tData.Nodes.Count()_"] "
	
	for i=1:1:tData.Nodes.Count() {
		
		#dim tNode As opc.ua.rest.data.Node
		Set tNode = tData.Nodes.GetAt(i)
		write "Node ["_tNode.NodeValue_"] "
	}
}

Storage Default
{
<Data name="DataState">
<Value name="1">
<Value>TimeStamp</Value>
</Value>
<Value name="2">
<Value>Nodes</Value>
</Value>
</Data>
<State>DataState</State>
<StreamLocation>^opc.ua.rest.data.DataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
