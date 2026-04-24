@AbapCatalog.sqlViewName: 'YZMAT_QMDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material QM Data'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_QMDATA_CDS as select from zmat_qmdata
{
    key taskid         as   TaskIDNo                            ,                 
    matnr              as   MaterialNumber                      ,                     
    maktx              as   MaterialDescription                 ,                     
    werks              as   Plant                               ,                      
    meins              as   BaseUnitofMeasure                  ,                    
    ausme              as   Unitofissue                        ,                     
    qmata              as   MatAuthorizationGrpforActvinQM     ,    
    kzdkz              as   Documentationrequiredindicator     ,                     
    webaz              as   Goodsrecprocessingtimeindays       ,              
    rbnrm              as   CatalogProfile                     ,                      
    prfrq              as   IntervalUntilNextRecurringInsp     ,            
    mmsta              as   PlantSpecificMaterialStatus        ,                    
    mmstd              as   DatfrmWhicthPlantSpcMatStIsVad,
    qssys              as   RequiredQMSystemforSupplier        ,                   
    qmpur              as   QMinProcurementIsActive,
    ssqss              as   QAControlKey,
    qzgtp              as   CertificateType,
    created_by         as   CreatedBy,
    created_date       as   CreatedDate,
    created_time       as   Createdtime,
    login_id           as   CreatedLoginid,
    change_by          as   ChangeBy,
    change_date        as   ChangeDate,
    change_time        as   ChangeTime,
    change_login_id    as   Changeloginid,
    apstatus           as   ApproveStatus,
    appid              as   ApprovedBy,
    app_date           as   ChangeDate1,
    app_time           as   ChangeTime1
}
