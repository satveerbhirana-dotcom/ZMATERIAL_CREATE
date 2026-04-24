@AbapCatalog.sqlViewName: 'YCDSDELTMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Material Task Id Deletion'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_DELET as select from zmat_basicdata_m   as a 
left outer join zmat_deltask as b on ( b.taskid = a.taskid )
{
    key a.taskid as                       TaskIDNo  ,                                                
    a.matnr as                            MaterialNumber  ,                                          
    a.maktx as                            MaterialDescription  ,                                     
    b.flag as TaskIdDelet
}             
where   a.apstatus = ''                       
