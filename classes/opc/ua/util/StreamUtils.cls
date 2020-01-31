include Ensemble 

/// Stream utility class 
Class opc.ua.util.StreamUtils Extends %RegisteredObject
{

/// Write Stream to LogInfo
ClassMethod writeStreamToLogInfo(pStream As %Stream) As %Status {
		
	$$$LOGINFO("====== Start stream output ======")	
	
	do pStream.Rewind()
	while (pStream.AtEnd = 0) {
		set len = 255
		$$$LOGINFO(pStream.Read(.len))
	}
	
	$$$LOGINFO("====== End stream output ======")
	
	return $$$OK
}

/// Write Stream to Trace
ClassMethod writeStreamToTrace(pStream As %Stream) As %Status {
		
	$$$TRACE("====== Start stream output ======")	
	
	do pStream.Rewind()
	while (pStream.AtEnd = 0) {
		set len = 255
		$$$TRACE(pStream.Read(.len))
	}
	
	$$$TRACE("====== End stream output ======")
	
	return $$$OK
}

}