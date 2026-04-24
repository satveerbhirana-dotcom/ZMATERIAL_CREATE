@AbapCatalog.sqlViewName: 'YZMAT_WMDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Warehouse Management Data'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_WMDATA_CDS as select from zmat_wmdata
{
    key taskid   as      TaskIDNo,
    matnr        as      MaterialNumber,
    maktx        as      MaterialDescription,
    werks        as      Plant,
    meins        as  BaseUnitofMeasure,
    stoff        as  Hazardousmaterialnumber,
    stoff2        as  Hazardousmaterialnumber2,
    lvsme        as  WarehouseManageUnitoMeasure,
    brgew        as  Grossweight,
    gewei        as  WeightUnit,
    ausme        as  Unitofissue,
    volum        as  Volume,
    voleh        as  Volumeunit,
    vomem        as  Defaultfunofmeasfromatemasrec,
    mkapv        as  Capacityusage,
    plkpt        as  Pickistortypfroughcuanddetapla,
    xchpf1       as  BatchManagementRequirIndicator,
    xchpf        as  BatchManagemRequiremIndicator,
    ltkza        as  Stortypindicatorforstoremoval,
    ltkze        as  Storagtypindicafstocplaceme,
    lgbkz        as  StorageSectionIndicators,
    block        as  BulkStorageIndicators,
    bsskz        as  Specimovemeindicafowarehmanage,
    l2skr        as  Materiarelevancfr2steppickin,
    kzmbf        as  IndicatorMessagetoinvemanage,
    kzzul        as  IndicaAlladdittoexistingstock,
    lhmg1        as  Loadingequipmentquantity1,
    lhmg2        as  Loadingequipmentquantity2,
    lhmg3        as  Loadingequipmenquantity3,
    lhme1        as  Unitofmeasuoloadequipquant1,
    lety1        as  ststorageunittype1,
    created_by   as  CreatedBy,
    created_date as  CreatedDate,
    created_time as  Createdtime,
    login_id     as  CreatedLoginid,
    change_by    as  ChangeBy,
    change_date  as  ChangeDate,
    change_time  as  ChangeTime,
    change_login_id as  Changeloginid,
    apstatus        as  ApproverStatus,
    appid           as  ApprovedBy,
    app_date        as  ChangeDate1,
    app_time        as  ChangeTime1,
    stgetype      
}
