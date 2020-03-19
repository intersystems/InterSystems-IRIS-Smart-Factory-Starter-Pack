/// Generated for:
/// - Equipment GIP03 machine (id 1)
/// - Configuration GIP03 OEE shift timeslide (id 5)
Class opc.ua.data.GIP03.serving.GIP03OEESHIFTTIMESLIDE Extends opc.ua.data.Base
{

Parameter XMLNAME = "GIP03.serving.GIP03OEESHIFTTIMESLIDE";

Parameter XMLTYPE = "GIP03.serving.GIP03OEESHIFTTIMESLIDE";

Property ActualSpeedTotalProduction As %Integer;

Property DayLocal As %Integer;

Property EquipmentID As %Integer;

Property MachineStatus As %Integer;

Property MonthLocal As %Integer;

Property PreviousReading As opc.ua.data.GIP03.serving.GIP03OEESHIFTTIMESLIDE [ Transient ];

Property ProducedQtyOrder As %Integer;

Property Recipe As %String;

Property RecipeSpeed As %Integer;

Property ShiftOperationID As %Integer;

Property TimeLocal As %Integer;

Property TimeStampLocal As %TimeStamp;

Property UoM As %String;

Property WorkOrder As %Integer;

Property YearLocal As %Integer;

Storage Default
{
<Data name="GIP03OEESHIFTTIMESLIDEDefaultData">
<Subscript>"GIP03OEESHIFTTIMESLIDE"</Subscript>
<Value name="1">
<Value>ActualSpeedTotalProduction</Value>
</Value>
<Value name="2">
<Value>DayLocal</Value>
</Value>
<Value name="3">
<Value>EquipmentID</Value>
</Value>
<Value name="4">
<Value>MachineStatus</Value>
</Value>
<Value name="5">
<Value>MonthLocal</Value>
</Value>
<Value name="6">
<Value>ProducedQtyOrder</Value>
</Value>
<Value name="7">
<Value>Recipe</Value>
</Value>
<Value name="8">
<Value>RecipeSpeed</Value>
</Value>
<Value name="9">
<Value>ShiftOperationID</Value>
</Value>
<Value name="10">
<Value>TimeLocal</Value>
</Value>
<Value name="11">
<Value>TimeStampLocal</Value>
</Value>
<Value name="12">
<Value>UoM</Value>
</Value>
<Value name="13">
<Value>WorkOrder</Value>
</Value>
<Value name="14">
<Value>YearLocal</Value>
</Value>
</Data>
<DefaultData>GIP03OEESHIFTTIMESLIDEDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
