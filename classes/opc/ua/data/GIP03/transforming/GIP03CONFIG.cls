Class opc.ua.data.GIP03.transforming.GIP03CONFIG Extends opc.ua.data.Base
{

Parameter XMLNAME = "GIP03.transforming.GIP03CONFIG";

Parameter XMLTYPE = "GIP03.transforming.GIP03CONFIG";

/// Previous reading 
/// TODO: Add to generator
Property PreviousReading As opc.ua.data.GIP03.transforming.GIP03CONFIG [ Calculated ];

Property ActualSpeedTotalProduction As %Double;

Property DayLocal As %Integer;

Property DurationIncrement As %Integer;

Property EquipmentID As %Integer;

Property "MT1_1" As %Integer;

Property "MT1_2" As %Integer;

Property "MT1_3" As %Integer;

Property "MT1_4" As %Integer;

Property "MT1_5" As %Integer;

Property "MT1_6" As %Integer;

Property "MT1_7" As %Integer;

Property "MT4_1" As %Integer;

Property "MT4_2" As %Integer;

Property "MT4_3" As %Integer;

Property "MT4_4" As %Integer;

Property "MT4_5" As %Integer;

Property "MT4_6" As %Integer;

Property "MT4_7" As %Integer;

Property MachineStatus As %Integer;

Property MachineStatusPreviousSample As %Integer;

Property MachineStatusPreviousStatus As %Integer;

Property MisPasQtyIncrement As %Integer;

Property MonthLocal As %Integer;

Property NewOrder As %Boolean;

Property ProducedQtyEquipment As %Double;

Property ProducedQtyIncrement As %Double;

Property ProducedQtyOrder As %Double;

Property Recipe As %String(MAXLEN = 50);

Property RecipeSpeed As %Double;

Property ShiftOperationID As %Integer;

Property TimeLocal As %Time;

Property TimeStampLocal As %TimeStamp;

Property WorkOrder As %Integer;

Property YearLocal As %Integer;

Property UoM As %String;

Storage Default
{
<Data name="GIP03CONFIGDefaultData">
<Subscript>"GIP03CONFIG"</Subscript>
<Value name="1">
<Value>ActualSpeedTotalProduction</Value>
</Value>
<Value name="2">
<Value>DayLocal</Value>
</Value>
<Value name="3">
<Value>DurationIncrement</Value>
</Value>
<Value name="4">
<Value>EquipmentID</Value>
</Value>
<Value name="5">
<Value>MT1_1</Value>
</Value>
<Value name="6">
<Value>MT1_2</Value>
</Value>
<Value name="7">
<Value>MT1_3</Value>
</Value>
<Value name="8">
<Value>MT1_4</Value>
</Value>
<Value name="9">
<Value>MT1_5</Value>
</Value>
<Value name="10">
<Value>MT1_6</Value>
</Value>
<Value name="11">
<Value>MT1_7</Value>
</Value>
<Value name="12">
<Value>MT4_1</Value>
</Value>
<Value name="13">
<Value>MT4_2</Value>
</Value>
<Value name="14">
<Value>MT4_3</Value>
</Value>
<Value name="15">
<Value>MT4_4</Value>
</Value>
<Value name="16">
<Value>MT4_5</Value>
</Value>
<Value name="17">
<Value>MT4_6</Value>
</Value>
<Value name="18">
<Value>MT4_7</Value>
</Value>
<Value name="19">
<Value>MachineStatus</Value>
</Value>
<Value name="20">
<Value>MachineStatusPreviousSample</Value>
</Value>
<Value name="21">
<Value>MachineStatusPreviousStatus</Value>
</Value>
<Value name="22">
<Value>MisPasQtyIncrement</Value>
</Value>
<Value name="23">
<Value>MonthLocal</Value>
</Value>
<Value name="24">
<Value>NewOrder</Value>
</Value>
<Value name="25">
<Value>ProducedQtyEquipment</Value>
</Value>
<Value name="26">
<Value>ProducedQtyIncrement</Value>
</Value>
<Value name="27">
<Value>ProducedQtyOrder</Value>
</Value>
<Value name="28">
<Value>Recipe</Value>
</Value>
<Value name="29">
<Value>RecipeSpeed</Value>
</Value>
<Value name="30">
<Value>ShiftOperationID</Value>
</Value>
<Value name="31">
<Value>TimeLocal</Value>
</Value>
<Value name="32">
<Value>TimeStampLocal</Value>
</Value>
<Value name="33">
<Value>WorkOrder</Value>
</Value>
<Value name="34">
<Value>YearLocal</Value>
</Value>
<Value name="35">
<Value>UoM</Value>
</Value>
</Data>
<DefaultData>GIP03CONFIGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
