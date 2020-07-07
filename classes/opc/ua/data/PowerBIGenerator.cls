/// PowerBi generator
Class opc.ua.data.PowerBIGenerator Extends %RegisteredObject
{

/// The equipment and configuration we're generating the class for
Property Config As opc.ua.config.EquipmentConfiguration;

/// The class to generate/update
Property ClassDef As %Dictionary.ClassDefinition;

/// Generates the class for the given equipment/configuration
ClassMethod Generate(EquipmentConfiguration As opc.ua.config.EquipmentConfiguration, Output Status As %Status) As powerbi.data.Table
{
	set Me = ..%New()
	set Me.Config = EquipmentConfiguration
	
	; Actual implementation in method
	return Me.GenerateImpl(.Status)
}

/// Returns the PowerBI type for the input (node) datatype
ClassMethod GetPowerBIType(DataType As %String) As %String [ CodeMode = expression ]
{
$Case(DataType,"date":"datetime","timestamp":"datetime","time":"datetime","boolean":"bool","integer":"int64","double":"double","float":"double","string":"string","decimal":"double",:"string")
}

/// Implementation of powerbi table definition generation
Method GenerateImpl(ConfigType As %String, Output Status As %Status) As powerbi.data.Table
{
	 

	set Status = $$$OK
	
    /// Create Table
	set Table = ##class(powerbi.data.Table).%New()
	set Table.name = ..Config.Configuration.Name	
	
	/// Get list of opc.ua.config.Node objects
	set Nodes = ..Config.Configuration.ConfigurationNode
	set NodeList = ##class(%ListOfDataTypes).%New()
	set key = ""
	for  {
		set NodeCfg = Nodes.GetNext(.key)
		if key = "" quit
		do NodeList.Insert(NodeCfg.Node)
	}	
	
	///  TimeStamp from the base class
	set Column = ##class(powerbi.data.Column).%New()
	set Column.name = "TimeStamp"
	set Column.dataType = ..GetPowerBIType("timestamp")
	
	/// Append column to Table
	do Table.columns.Insert(Column)
	
	/// Loop through the nodes and create for every node a column definition
	for i = 1:1:NodeList.Count() {
		
		/// Get node 
		#dim Node As opc.ua.config.Node	
		set Node = NodeList.GetAt(i)
		
		/// Check if this node can be processed, if not skip it
		if (Node.DatabaseAttribute = "") || (Node.DatabaseType = "") Continue
		
		/// Create Column
		set Column = ##class(powerbi.data.Column).%New()
		set Column.name = Node.DatabaseAttribute
		set Column.dataType = ..GetPowerBIType(Node.DatabaseType)
		
		/// Append column to Table
		do Table.columns.Insert(Column)
		
	}
	
	return Table
}

}
