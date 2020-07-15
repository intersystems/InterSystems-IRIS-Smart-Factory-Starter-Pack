/// The dataset column
Class powerbi.data.Column Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

/// Column name
Property name As %String(MAXLEN = "");

/// Column datatype
Property dataType As %String(DISPLAYLIST = ",string,int64,bool,datetime,double", MAXLEN = "", VALUELIST = ",string,int64,bool,datetime,double");

Storage Default
{
<Data name="ColumnState">
<Value name="1">
<Value>name</Value>
</Value>
<Value name="2">
<Value>dataType</Value>
</Value>
</Data>
<State>ColumnState</State>
<StreamLocation>^powerbi.data.ColumnS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
