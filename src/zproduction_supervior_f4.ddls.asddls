@AbapCatalog.sqlViewName: 'YPRODCUF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Production Supervior F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZPRODUCTION_SUPERVIOR_F4 as select from I_ProductionSupervisor as a 
{
    key a.Plant,
    key a.ProductionSupervisor,
       a.ProductionSupervisorName
}
group by 
       a.Plant,
       a.ProductionSupervisor,
       a.ProductionSupervisorName
