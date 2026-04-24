@AbapCatalog.sqlViewName: 'YZMAT_MATTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master Views control by Material Type'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_MATTYP_CDS as select from zmat_mattype
{
    key view_code as ViewCode,
    key view_name as ViewName,
    key mtart     as Materialtype
}
