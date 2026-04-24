@AbapCatalog.sqlViewName: 'YZMAT_SALESTXVAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Tax Condition Values'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_SALESTXVALE_CDS as select from zmat_salestxvale
{
    key country            as        DepartCounRegifrwhithgooarsent,
    key tax_type           as        TaxType,
    key tax_category       as        Taxcategsalestfedesalestax,
    value                  as        Taxclassificationmaterial
}
