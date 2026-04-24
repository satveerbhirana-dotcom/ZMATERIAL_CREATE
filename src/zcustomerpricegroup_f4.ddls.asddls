@AbapCatalog.sqlViewName: 'YCUSPRIGRP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZCustomerPriceGroup_F4 as select from I_CustomerPriceGroupText
{
    key CustomerPriceGroup,
    CustomerPriceGroupName
} where Language = 'E'
