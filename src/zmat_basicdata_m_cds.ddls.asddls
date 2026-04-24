@AbapCatalog.sqlViewName: 'YBASICDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Basic data View'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_BASICDATA_M_CDS as select from zmat_basicdata_m   as a 
left outer join zmat_deltask as b on (b.taskid = a.taskid )
{
    key a.taskid as                       TaskIDNo  ,                                                
    a.matnr as                            MaterialNumber  ,                                          
    a.maktx as                            MaterialDescription  ,                                     
    a.meins as                            BaseUnitofMeasure  ,                                       
    a.matkl as                            MaterialGroup  ,                                           
    a.mtart as                            Materialtype  ,                                            
    a.mbrsh as                            IndustrySector  ,                                          
    a.bismt as                            Oldmaterialnumber  ,                                       
    a.extwg as                            ExternalMaterialGroup  ,                                   
    a.spart as                            Division  ,                                                
    a.labor as                            Laboratorydesignoffice  ,                                  
    a.mstae as                            CrossPlantMaterialStatus  ,                                
    a.mstde as                            Dtfromwhichcrspltmatrstatisvld  ,         
    a.begru as                            AuthorizationGroup  ,                                      
    a.brgew as                            Grossweight,                                               
    a.gewei as                            WeightUnit,                                                
    a.ntgew as                            Netweight  ,                                               
    a.volum as                            Volume  ,                                                  
    a.voleh as                            Volumeunit  ,                                              
    a.groes as                            Sizedimensions  ,                                          
    a.ean11 as                            InternationalArticleNoEANUPC  ,                        
    a.numtp as                            CtgryInternationalArticlenoEAN  ,                 
    a.magrv as                            MtrlGroupPackagingMaterials  ,                         
    a.mtpos_mara as                       Generalitemcategorygroup  ,                                
    a.kzeff as                            Asgecvtyprmtrvlusoveridechngno  ,   
    a.normt as                            IndustryStandardDescrISO  ,              
    a.wrkst as                            BasicMaterial  ,                                           
    a.msbookpartno as                     ManufacturerBookPartNumber  ,                              
    a.medium as                           TransportmediumforIndata  ,                         
    a.kosch as                            Productallocadeterminanproced  ,                 
    a.created_by as                       CreatedBy   ,
    a.created_date as                     CreatedDate      ,
    a.created_time as                     Createdtime    ,
    a.login_id as                         CreatedLoginid    ,
    a.change_by as                        ChangeBy    ,
    a.change_date as                      ChangeDate    ,
    a.change_time as                      ChangeTime    ,
    a.change_login_id as                  Changeloginid    ,
    a.apstatus as                         ApproveStatus    ,
    a.appid as                            ApprovedByAppid,  
    a.app_date as                         ChangeDateAppDate,  
    a.app_time as                         ChangeTimeAppTime ,
    case when a.apstatus = 'X' then 'Approved' 
    when b.flag = 'X' then 'Deleted' 
    else 'Pending For Approval' 
    end as apstatus1,
    a.unapp_date,
    a.unapp_time,
    a.unappid,
    a.reject
}                                     
