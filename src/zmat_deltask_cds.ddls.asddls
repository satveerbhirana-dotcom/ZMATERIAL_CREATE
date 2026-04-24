@AbapCatalog.sqlViewName: 'YZMAT_DELTASK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table for Material Deletion Task ID'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_DELTASK_CDS as select from zmat_deltask
{
    key taskid                as TaskIDNo,
    matnr                     as MaterialNumber,
    maktx                     as MaterialDescription,
    flag                      as GeneralFlag
}
