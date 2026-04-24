@AbapCatalog.sqlViewName: 'YACCOUNT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Accounting Data'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_ACCOUNTDATA_CDS as select from zmat_accountdata
{
     key taskid      as TaskIDNO                                           ,
     matnr           as MaterialNumber  ,
     maktx           as MaterialDescription  ,
     werks           as Plant  ,
     meins           as BaseUnitofMeasure  ,
     bklas           as ValuationClass  ,
     mlmaa           as ProductLedgerAccount  ,
     spart           as Division  ,
     bwtty           as ValuationCategory  ,
     qklas           as ValuationClassForProjectStock  ,
     mlast           as MatPriceDeterminationControl  ,
     xbewm           as ValbasedonthebatchspecificuOM ,
     eklas           as ValClasSforSalesOrderStock  ,
     curry           as CURRY,
     stprs_1         as StandardPricewithPlusMinusSign  ,   
     pvprs_1         as PerDUnTPrwhPlusMinusSign  ,
     waers_1         as CurrencyKey  ,
     peinh_1         as PriceUnit  ,
     verpr           as MvgAvgPricePeriodicUnitPrice  ,
     vprsv_1         as Pricecontrolindicator  ,
     bwprs           as Vlupricebasedontaxlawlevel1  ,
     bwps1           as Vlupricebasedontaxlawlevel2  ,
     vjbws           as Vlupricebasedontaxlawlevel3  ,
     bwprh           as Vlupricebasedoncommlawlevel1  ,
     bwph1           as Vlupricebasedoncommlawlevel2  ,
     vjbwh           as Vlupricebasedoncommlawlevel3  ,
     xlifo           as LIFOFIFORelevant  ,
     mypol           as PoolnumberforLIFOvaluation  ,
     created_by      as CreatedBy  ,
     created_date    as CreatedDate  ,  
     created_time    as  Createdtime  ,
     login_id        as  CreatedLoginid  ,
     change_by       as  ChangeBy  ,
     change_date     as  ChangeDate  ,
     change_time     as  ChangeTime  ,
     change_login_id as  Changeloginid  ,
     abwkz           as  Lowvaluedevaluationindicator  ,
     bwpei           as  Priuntforvlupribasedontacomlaw  ,
     apstatus        as  ApproverStatus  ,
     appid           as  ApprovedBy  ,
     app_date        as  APPChangeDate  ,
     app_time        as  APPChangeTime  
}                      
