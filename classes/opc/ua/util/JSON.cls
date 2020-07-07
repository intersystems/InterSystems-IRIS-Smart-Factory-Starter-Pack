Class opc.ua.util.JSON Extends %RegisteredObject
{

/// Creates JSON for a list of objects, assumed to be JSON-enabled
/// (by inheriting from %JSON.Adaptor). If Stream is not passed in,
/// it will be created automatically (as %Stream.TmpCharacter).
ClassMethod ListToJSONStream(List As %Collection.AbstractList, ByRef Stream As %Stream.Object = "") As %Status
{
	; Create stream object, if not passed in
	if Stream = "" set Stream = ##class(%Stream.TmpCharacter).%New()
	
	; Write the opening bracket
	set sc = Stream.Write("[")
	if 'sc Quit sc
	
	; Process the list
	for i = 1:1:List.Count() {
		#dim Item As %JSON.Adaptor
		set Item = List.GetAt(i)
		
		; Write comma separating list items
		if i > 1 do Stream.Write(",")
		
		; Write the JSON for the object
		set sc = Item.%JSONExportToStream(Stream)
		if 'sc return sc
	}
	
	; Close the (possibly empty) list
	set sc = Stream.Write("]")
	if 'sc Quit sc
	
	quit $$$OK
}

/// Iterates over a JSON array, converting each object in it to
/// the IRIS equivalent, specified by classname. If the collection
/// to place the objects in is passed in and of a %Collection type
/// (i.e., a "list of" type property), ClassName is optional.
ClassMethod LoadJSONList(Input As %DynamicArray, ClassName As %String, Output Objects As %ListOfObjects = "") As %Status
{
	; If output list not passed in, create one
	if '$IsObject(Objects) Set Objects = ##class(%ListOfObjects).%New()
	
	; If we output to a "list of" property, we can ask it the classname
	if Objects.%IsA("%Collection.AbstractListOfObj"), $Get(ClassName) = "" {
		set ClassName = Objects.ElementType
	}
	
	; Loopt through objects in JSON array
	#dim it As %Iterator.Array
	set it = Input.%GetIterator()
	while it.%GetNext(.idx, .JsonObj) {
		#dim IrisObj As %JSON.Adaptor
		set IrisObj = $ZObjClassMethod(ClassName, "%New")
		set sc = IrisObj.%JSONImport(JsonObj)
		if 'sc return sc
		set sc = Objects.Insert(IrisObj)
		if 'sc return sc
	}
	
	quit $$$OK
}

}
