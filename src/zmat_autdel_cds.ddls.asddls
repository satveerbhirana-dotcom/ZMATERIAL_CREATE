@AbapCatalog.sqlViewName: 'YZMAT_AUTDEL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Deletion Authorization'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_AUTDEL_CDS as select from zmat_autdel
{
    key uname as UserID,
    delete1   as Deletion
}               
                
                
