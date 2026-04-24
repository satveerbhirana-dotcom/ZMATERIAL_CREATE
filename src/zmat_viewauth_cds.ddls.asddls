@AbapCatalog.sqlViewName: 'YZMAT_VIEWAUTH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Deletion Authorization'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_VIEWAUTH_CDS as select from zmat_viewauth
{
    key view_code         as     ViewCode,
    key uname             as     UserID,
    view_name             as     ViewName,
    create1               as     Create1,
    change                as     Change,
    display               as     Display,
    tasklist              as     Tasklist,
    appr_id               as     ApproverId,
    appr_task             as     ApTasklist
}
