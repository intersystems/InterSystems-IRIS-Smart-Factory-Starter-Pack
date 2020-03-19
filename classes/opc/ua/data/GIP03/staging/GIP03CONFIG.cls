Class opc.ua.data.GIP03.staging.GIP03CONFIG Extends opc.ua.data.Base
{

Parameter XMLTYPE = "GIP03.staging.GIP03CONFIG";

Parameter XMLNAME = "GIP03.staging.GIP03CONFIG";

Property PreviousReading As opc.ua.data.GIP03.staging.GIP03CONFIG [ Transient ];

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

Property RECEPTNAAM1 As %Integer;

Property RECEPTNAAM2 As %Integer;

Property RECEPTNAAM3 As %Integer;

Property RECEPTNAAM4 As %Integer;

Property RECEPTNAAM5 As %Integer;

Property VDoek As %Double;

Property VRecept As %Double;

Property WerkOrder As %Double;

Property Yards As %Double;

/// Generated code, do not change.
ClassMethod GetLastRecord(Output Data As %String) As %Status
{
	&sql(SELECT MachineStatus,VRecept,VDoek,WerkOrder,Yards,MT1_1,MT1_2,MT1_3,MT1_4,MT1_5,MT1_6,MT1_7,MT4_1,MT4_2,MT4_3,MT4_4,MT4_5,MT4_6,MT4_7,RECEPTNAAM1,RECEPTNAAM2,RECEPTNAAM3,RECEPTNAAM4,RECEPTNAAM5
	  INTO :d(1),:d(2),:d(3),:d(4),:d(5),:d(6),:d(7),:d(8),:d(9),:d(10),:d(11),:d(12),:d(13),:d(14),:d(15),:d(16),:d(17),:d(18),:d(19),:d(20),:d(21),:d(22),:d(23),:d(24)
	  FROM opc_ua_data_GIP03_staging.GIP03CONFIG
	  ORDER BY ID DESC)
	If SQLCODE {
	  If SQLCODE '= 100 Quit $$$ERROR($$$SQLError,SQLCODE,$g(%msg))
	  Do ..InitData(.Data)
	  Quit $$$OK
	}
	Set Data("ns=4;s=GIP03PLC0050-SV.MACHINE_STATUS")=d(1)
	Set Data("ns=4;s=GIP03PLC0050-SV.VRECEPT")=d(2)
	Set Data("ns=4;s=GIP03PLC0050-SV.VDOEK")=d(3)
	Set Data("ns=4;s=GIP03PLC0050-SV.WERKORDER")=d(4)
	Set Data("ns=4;s=GIP03PLC0050-SV.YARDS")=d(5)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_1")=d(6)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_2")=d(7)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_3")=d(8)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_4")=d(9)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_5")=d(10)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_6")=d(11)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT1_7")=d(12)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_1")=d(13)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_2")=d(14)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_3")=d(15)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_4")=d(16)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_5")=d(17)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_6")=d(18)
	Set Data("ns=4;s=GIP03PLC0050-SV.MT4_7")=d(19)
	Set Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM1")=d(20)
	Set Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM2")=d(21)
	Set Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM3")=d(22)
	Set Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM4")=d(23)
	Set Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM5")=d(24)
	Quit $$$OK
}

/// Generated code, do not change.
ClassMethod InitData(Output Data As %String)
{
	Set Names = $lb("ns=4;s=GIP03PLC0050-SV.MACHINE_STATUS","ns=4;s=GIP03PLC0050-SV.VRECEPT","ns=4;s=GIP03PLC0050-SV.VDOEK","ns=4;s=GIP03PLC0050-SV.WERKORDER","ns=4;s=GIP03PLC0050-SV.YARDS","ns=4;s=GIP03PLC0050-SV.MT1_1","ns=4;s=GIP03PLC0050-SV.MT1_2","ns=4;s=GIP03PLC0050-SV.MT1_3","ns=4;s=GIP03PLC0050-SV.MT1_4","ns=4;s=GIP03PLC0050-SV.MT1_5","ns=4;s=GIP03PLC0050-SV.MT1_6","ns=4;s=GIP03PLC0050-SV.MT1_7","ns=4;s=GIP03PLC0050-SV.MT4_1","ns=4;s=GIP03PLC0050-SV.MT4_2","ns=4;s=GIP03PLC0050-SV.MT4_3","ns=4;s=GIP03PLC0050-SV.MT4_4","ns=4;s=GIP03PLC0050-SV.MT4_5","ns=4;s=GIP03PLC0050-SV.MT4_6","ns=4;s=GIP03PLC0050-SV.MT4_7","ns=4;s=GIP03PLC0050-SV.RECEPTNAAM1","ns=4;s=GIP03PLC0050-SV.RECEPTNAAM2","ns=4;s=GIP03PLC0050-SV.RECEPTNAAM3","ns=4;s=GIP03PLC0050-SV.RECEPTNAAM4","ns=4;s=GIP03PLC0050-SV.RECEPTNAAM5")
	For i = 1:1:$ll(Names) Set Data($li(Names,i))=""
	Quit
}

/// Generated code, do not change.
ClassMethod SaveData(TimeStamp As %TimeStamp, ByRef Data As %String, Output RowId As %BigInt) As %Status
{
	Set d(1)=Data("ns=4;s=GIP03PLC0050-SV.MACHINE_STATUS")
	Set d(2)=Data("ns=4;s=GIP03PLC0050-SV.VRECEPT")
	Set d(3)=Data("ns=4;s=GIP03PLC0050-SV.VDOEK")
	Set d(4)=Data("ns=4;s=GIP03PLC0050-SV.WERKORDER")
	Set d(5)=Data("ns=4;s=GIP03PLC0050-SV.YARDS")
	Set d(6)=Data("ns=4;s=GIP03PLC0050-SV.MT1_1")
	Set d(7)=Data("ns=4;s=GIP03PLC0050-SV.MT1_2")
	Set d(8)=Data("ns=4;s=GIP03PLC0050-SV.MT1_3")
	Set d(9)=Data("ns=4;s=GIP03PLC0050-SV.MT1_4")
	Set d(10)=Data("ns=4;s=GIP03PLC0050-SV.MT1_5")
	Set d(11)=Data("ns=4;s=GIP03PLC0050-SV.MT1_6")
	Set d(12)=Data("ns=4;s=GIP03PLC0050-SV.MT1_7")
	Set d(13)=Data("ns=4;s=GIP03PLC0050-SV.MT4_1")
	Set d(14)=Data("ns=4;s=GIP03PLC0050-SV.MT4_2")
	Set d(15)=Data("ns=4;s=GIP03PLC0050-SV.MT4_3")
	Set d(16)=Data("ns=4;s=GIP03PLC0050-SV.MT4_4")
	Set d(17)=Data("ns=4;s=GIP03PLC0050-SV.MT4_5")
	Set d(18)=Data("ns=4;s=GIP03PLC0050-SV.MT4_6")
	Set d(19)=Data("ns=4;s=GIP03PLC0050-SV.MT4_7")
	Set d(20)=Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM1")
	Set d(21)=Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM2")
	Set d(22)=Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM3")
	Set d(23)=Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM4")
	Set d(24)=Data("ns=4;s=GIP03PLC0050-SV.RECEPTNAAM5")	
	&sql(INSERT INTO opc_ua_data_GIP03_staging.GIP03CONFIG
	  (TimeStamp,MachineStatus,VRecept,VDoek,WerkOrder,Yards,MT1_1,MT1_2,MT1_3,MT1_4,MT1_5,MT1_6,MT1_7,MT4_1,MT4_2,MT4_3,MT4_4,MT4_5,MT4_6,MT4_7,RECEPTNAAM1,RECEPTNAAM2,RECEPTNAAM3,RECEPTNAAM4,RECEPTNAAM5)
	  VALUES
	  (:TimeStamp,:d(1),:d(2),:d(3),:d(4),:d(5),:d(6),:d(7),:d(8),:d(9),:d(10),:d(11),:d(12),:d(13),:d(14),:d(15),:d(16),:d(17),:d(18),:d(19),:d(20),:d(21),:d(22),:d(23),:d(24)))
	Set RowId = %ROWID
	If SQLCODE Quit $$$ERROR($$$SQLError,SQLCODE,$g(%msg))
	Quit $$$OK
}

Storage Default
{
<Data name="GIP03CONFIGDefaultData">
<Subscript>"GIP03CONFIG"</Subscript>
<Value name="1">
<Value>MT1_1</Value>
</Value>
<Value name="2">
<Value>MT1_2</Value>
</Value>
<Value name="3">
<Value>MT1_3</Value>
</Value>
<Value name="4">
<Value>MT1_4</Value>
</Value>
<Value name="5">
<Value>MT1_5</Value>
</Value>
<Value name="6">
<Value>MT1_6</Value>
</Value>
<Value name="7">
<Value>MT1_7</Value>
</Value>
<Value name="8">
<Value>MT4_1</Value>
</Value>
<Value name="9">
<Value>MT4_2</Value>
</Value>
<Value name="10">
<Value>MT4_3</Value>
</Value>
<Value name="11">
<Value>MT4_4</Value>
</Value>
<Value name="12">
<Value>MT4_5</Value>
</Value>
<Value name="13">
<Value>MT4_6</Value>
</Value>
<Value name="14">
<Value>MT4_7</Value>
</Value>
<Value name="15">
<Value>MachineStatus</Value>
</Value>
<Value name="16">
<Value>RECEPTNAAM1</Value>
</Value>
<Value name="17">
<Value>RECEPTNAAM2</Value>
</Value>
<Value name="18">
<Value>RECEPTNAAM3</Value>
</Value>
<Value name="19">
<Value>RECEPTNAAM4</Value>
</Value>
<Value name="20">
<Value>RECEPTNAAM5</Value>
</Value>
<Value name="21">
<Value>VDoek</Value>
</Value>
<Value name="22">
<Value>VRecept</Value>
</Value>
<Value name="23">
<Value>WerkOrder</Value>
</Value>
<Value name="24">
<Value>Yards</Value>
</Value>
</Data>
<DefaultData>GIP03CONFIGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
