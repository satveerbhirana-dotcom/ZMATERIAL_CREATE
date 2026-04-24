@AbapCatalog.sqlViewName: 'YMDMREJ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZMDM_MAT_REJECTION as select from zmat_rejection
{
    key taskid as Taskid,
    key userid as Userid,
    key rejdate as Rejdate,
    key rejecttime as Rejecttime,
    rejectionremark as Rejectionremark
}
