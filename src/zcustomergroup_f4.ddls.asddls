@AbapCatalog.sqlViewName: 'ZCUSTOMERGROUP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZCustomerGroup_F4 as select from I_CustomerGroupText
{
    key CustomerGroup,
    CustomerGroupName
} 
where Language = 'E'
