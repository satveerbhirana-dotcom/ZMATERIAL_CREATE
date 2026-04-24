@AbapCatalog.sqlViewName: 'YMDMPR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PriceListType_F4 as select from I_PriceListTypeText
{
    key PriceListType,
    PriceListTypeName
} 
where Language = 'E'
