@AbapCatalog.sqlViewName: 'YPRODUC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Production Scheduling F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZProductionSchedulgProfi_F4 as select from I_ProductionSchedgProfileText
{
    key ProductionSchedulingProfile,
    key Plant,
        ProductionSchedgProfileName
} 
where Language = 'E'
group by 
      ProductionSchedulingProfile,
      Plant,
      ProductionSchedgProfileName
