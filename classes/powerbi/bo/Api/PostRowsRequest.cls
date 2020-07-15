/// Adds new data rows to the specified table
Class powerbi.bo.Api.PostRowsRequest Extends Ens.Request
{

/// DataSet identifier
Property dataSetId As %String(MAXLEN = "");

/// Table name 
Property tableName As %String(MAXLEN = "") [ Required ];

/// Rows to add, as JSON
Property rows As list Of %String(MAXLEN = "", XMLITEMNAME = "row") [ Required ];

/// Whether to replace the currently existing rows with the ones
/// in this request, i.e., to do a delete all before insert.
Property Replace As %Boolean;

/// Whether to send the rows in this request immediately, regardless
/// of the RowsPerPost (cache) setting of the Business Operation.
/// Any cached rows will be sent as well.
Property FlushCache As %Boolean;

// =====

Storage Default
{
<Data name="PostRowsRequestDefaultData">
<Subscript>"PostRowsRequest"</Subscript>
<Value name="1">
<Value>dataSetId</Value>
</Value>
<Value name="2">
<Value>tableName</Value>
</Value>
<Value name="3">
<Value>rows</Value>
</Value>
<Value name="4">
<Value>Replace</Value>
</Value>
<Value name="5">
<Value>FlushCache</Value>
</Value>
</Data>
<DefaultData>PostRowsRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
