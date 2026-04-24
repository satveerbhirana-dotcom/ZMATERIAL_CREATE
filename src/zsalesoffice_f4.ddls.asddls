@AbapCatalog.sqlViewName: 'YSALESOFCF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZSalesOffice_F4 as select from I_SalesOffice
{
    key SalesOffice
}
