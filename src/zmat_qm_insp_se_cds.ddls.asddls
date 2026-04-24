@AbapCatalog.sqlViewName: 'YQTYINSPCDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM QM Inspection Setup Cds'
@Metadata.ignorePropagatedAnnotations: true
define view zmat_qm_insp_se_CDS as select from zmat_qm_insp_se
{
    key taskid as Taskid,
    insptype as Insptype,
    shorttext as Shorttext,
    active as Active
}
