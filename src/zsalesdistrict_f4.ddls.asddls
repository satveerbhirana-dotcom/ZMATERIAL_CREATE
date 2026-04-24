@AbapCatalog.sqlViewName: 'YSALF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZSalesDistrict_F4 as select from I_SalesDistrictText
{
    key SalesDistrict,
    SalesDistrictName
} 
where Language = 'E'
