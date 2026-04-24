@AbapCatalog.sqlViewName: 'YTRACKID'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Material Task Id Track'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_TRACK_TASK as select from zmat_basicdata_m   as a 
left outer join zmat_deltask as b on (b.taskid = a.taskid )
left outer join zuser_id as c on (c.userid = a.login_id )
left outer join ZAPPROVAL_ID as d on ( a.appid = '' )
left outer join zuser_id as e on ( e.userid = d.appr_id or e.userid = a.appid )

{
    key a.taskid as                       TaskIDNo  ,                                                
    a.matnr as                            MaterialNumber  ,                                          
    a.maktx as                            MaterialDescription  ,   
    a.meins as                            BaseUnitofMeasure  ,                                                   
    a.login_id as                       CreatedBy   ,
    a.created_date as                     CreatedDate      ,
    a.created_time as                     Createdtime    ,
    c.username as                         CreatedLoginidName    ,
    a.change_by as                        ChangeBy    ,
    a.change_date as                      ChangeDate    ,
    a.change_time as                      ChangeTime    ,
    a.change_login_id as                  Changeloginid    ,
    e.userid as                           ApprovedByAppid,  
    e.username as                         ApprovedByAppidName,  
    a.app_date as                         ChangeDateAppDate,  
    a.app_time as                         ChangeTimeAppTime ,
    
    case when a.reject = 'X' then 'Rejected'
    when a.apstatus = 'X' then 'Approved' 
    when b.flag = 'X' then 'Deleted' 
    else 'Pending For Approval' 
    end as ApproveStatus,
    a.mtart    as MatTYpe
}                                     
