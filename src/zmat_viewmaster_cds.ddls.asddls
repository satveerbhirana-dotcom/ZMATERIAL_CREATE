@AbapCatalog.sqlViewName: 'YZMAT_VIEWMASTER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Master View Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_VIEWMASTER_CDS as select from zmat_viewmaster
{
    key view_code            as       ViewCode,
    view_name                as       ViewName
}
