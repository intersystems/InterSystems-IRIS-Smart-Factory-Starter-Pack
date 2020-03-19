Class opc.ua.dtl.TransformRespToServingReq Extends Ens.DataTransformDTL [ DependsOn = (opc.ua.bp.GIP03Transform.TransformResp, opc.ua.bp.GIP03Serving.ServingReq) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='opc.ua.bp.GIP03Transform.TransformResp' targetClass='opc.ua.bp.GIP03Serving.ServingReq' create='new' language='objectscript' >
<assign value='source.Data' property='target.Data' action='set' />
</transform>
}

}
