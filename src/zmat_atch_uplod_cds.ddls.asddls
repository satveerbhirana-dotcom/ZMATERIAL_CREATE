@AbapCatalog.sqlViewName: 'YATCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For MDM Material'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_ATCH_UPLOD_CDS as select from zmat_atch_uplod
{
    key contentname as Contentname,
    key taskid as Taskid,
    key srno as Srno,
    attachment as Attachment,
    mimetype as Mimetype,
    filename as Filename
}
