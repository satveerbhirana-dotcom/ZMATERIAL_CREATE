CLASS zcl_material_bapi_mm02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS :
      UpdateMat
      IMPORTING VALUE(TaxkID)  TYPE STring OPTIONAL
      RETURNING VALUE(StatusRetun) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MATERIAL_BAPI_MM02 IMPLEMENTATION.


METHOD updatemat.

***************************************************************************** MAT START********************************************

DATA create_product TYPE TABLE FOR UPDATE I_ProductTP_2.

DATA PATYCODE TYPE C LENGTH 10 .
DATA product TYPE I_Product-Product .
SELECT SINGLE * FROM ZMAT_BASICDATA_M_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_BASICDATA) .

SELECT SINGLE * FROM ZMAT_SALESDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_SALES) .

SELECT SINGLE * FROM ZMAT_GENPLANT_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_GeneralPlant) .

SELECT SINGLE * FROM ZMAT_MRPDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_MRPDATA) .

SELECT SINGLE * FROM ZMAT_PURDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_Purchase) .

SELECT SINGLE * FROM ZMAT_COSTINGDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_Costingdata) .

SELECT SINGLE * FROM zmat_wmdata_cds WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_wmdata) .

SELECT SINGLE * FROM ZMAT_ACCOUNTDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(ACCOUNTDATA) .

SELECT SINGLE * FROM ZMAT_QMDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(QMDATA) .

**DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
**    DATA nrrangenr  TYPE char2.
**
**    TRY.
**        CALL METHOD cl_numberrange_runtime=>number_get
**          EXPORTING
**            nr_range_nr = '01'
**            object      = 'MAT'
**            quantity    = 0000000001
**          IMPORTING
**            number      = nr_number.
**
**      CATCH cx_nr_object_not_found.
**      CATCH cx_number_ranges.
**    ENDTRY.
**    SHIFT nr_number LEFT DELETING LEADING '0'.
**    DATA: lv_nr TYPE C LENGTH 6.
**    lv_nr = |{ nr_number ALPHA = OUT }|.

if WA_BASICDATA-BaseUnitofMeasure = 'PC'.
WA_BASICDATA-BaseUnitofMeasure = 'ST'.
ENDIF.

*SELECT SINGLE MAX( product )
*FROM I_product WITH PRIVILEGED ACCESS as a WHERE ProductType = 'ROH'
*AND Product LIKE 'R%' INTO @product.
*
*DATA PRFIRT TYPE C LENGTH 18.
*DATA PRFIRT1 TYPE C LENGTH 7.
*PRFIRT = product+1(18).
*
*DATA(MAT1) = |{ PRFIRT ALPHA = OUT }| .
*MAT1 = MAT1 + 1 .
*PRFIRT1  = |{ MAT1 ALPHA = IN }| .
*PRFIRT = product+0(1).
product = WA_BASICDATA-MaterialNumber.

DATA PROFIT TYPE C LENGTH 10.

PROFIT = |{ WA_GeneralPlant-ProfitCenter ALPHA = IN }| .
create_product = VALUE #( (

* %cid = 'product1'
* Product = product
* %control-Product = if_abap_behv=>mk-on
%key-Product = product
 ProductOldID = WA_BASICDATA-Oldmaterialnumber
 %control-ProductOldID = if_abap_behv=>mk-on

 ProductType = WA_BASICDATA-Materialtype
 %control-ProductType = if_abap_behv=>mk-on
 BaseUnit = WA_BASICDATA-BaseUnitofMeasure
 %control-BaseUnit = if_abap_behv=>mk-on
 IndustrySector = WA_BASICDATA-IndustrySector
 %control-IndustrySector = if_abap_behv=>mk-on
 ProductGroup = wa_basicdata-MaterialGroup
 %control-ProductGroup = if_abap_behv=>mk-on
 IsBatchManagementRequired = 'X'
 %control-IsBatchManagementRequired = if_abap_behv=>mk-on
 Division  = wa_basicdata-Division
 %control-Division = if_abap_behv=>mk-on
* IsMarkedForDeletion = wa_basicdata-    10000024
 CrossPlantStatus = wa_basicdata-CrossPlantMaterialStatus
* CrossPlantStatusValidityDate = wa_basicdata-
 ItemCategoryGroup  = wa_basicdata-Generalitemcategorygroup
 NetWeight   = wa_basicdata-Netweight
 GrossWeight  = wa_basicdata-Grossweight
 WeightUnit  = wa_basicdata-WeightUnit
 ProductVolume  = wa_basicdata-Volume
 AuthorizationGroup  = wa_basicdata-AuthorizationGroup
* ANPCode  = wa_basicdata-A
 SizeOrDimensionText  = wa_basicdata-Sizedimensions
 IndustryStandardName  = wa_basicdata-IndustryStandardDescrISO
 ProductStandardID = wa_basicdata-InternationalArticleNoEANUPC
 InternationalArticleNumberCat = wa_basicdata-CtgryInternationalArticlenoEAN
* ProductIsConfigurable = wa_basicdata-
 ExternalProductGroup = wa_basicdata-ExternalMaterialGroup
*      CrossPlantConfigurableProduct = wa_basicdata-CrossPlantMaterialStatus
*      SerialNoExplicitnessLevel = wa_basicdata-S
*      IsApprovedBatchRecordReqd,
*      HandlingIndicator,
*      WarehouseProductGroup,
*      WarehouseStorageCondition,
*      StandardHandlingUnitType,
*      SerialNumberProfile,
*      IsPilferable,
*      IsRelevantForHzdsSubstances,
*      QuarantinePeriod,
*      TimeUnitForQuarantinePeriod,
*      QualityInspectionGroup,
*      HandlingUnitType,
*      HasVariableTareWeight,
*      MaximumPackagingLength,
*      MaximumPackagingWidth,
*      MaximumPackagingHeight,
*      MaximumCapacity,
*      OvercapacityTolerance,
*      UnitForMaxPackagingDimensions,
*      BaseUnitSpecificProductLength,
*      BaseUnitSpecificProductWidth,
*      BaseUnitSpecificProductHeight,
*      ProductMeasurementUnit,
*      ArticleCategory,
*      IndustrySector,
*      LastChangeDateTime,
*      LastChangeTime,
*      DangerousGoodsIndProfile,
*      ProductDocumentChangeNumber,
*      ProductDocumentPageCount,
*      ProductDocumentPageNumber,
*      DocumentIsCreatedByCAD,
*      ProductionOrInspectionMemoTxt,
*      ProductionMemoPageFormat,
*      ProductIsHighlyViscous,
*      TransportIsInBulk,
       ProdEffctyParamValsAreAssigned = wa_basicdata-Asgecvtyprmtrvlusoveridechngno
*      ProdIsEnvironmentallyRelevant,
*      LaboratoryOrDesignOffice,
      PackagingProductGroup = wa_basicdata-MtrlGroupPackagingMaterials
*      PackingReferenceProduct,
      BasicProduct  = wa_basicdata-BasicMaterial
*      ProductDocumentNumber,
*      ProductDocumentVersion,
*      ProductDocumentType,
*      ProductDocumentPageFormat,
*      ProdChmlCmplncRelevanceCode,
*      DiscountInKindEligibility,
*      ProdCompetitorCustomerNumber,
*      ProductHierarchy,
      ProdAllocDetnProcedure = wa_basicdata-Productallocadeterminanproced
*      CountryOfOrigin,
*      RetailArticleBrand,
*      ProductValidStartDate
*      ContentUnit,
*      ProductNetContentQuantity,
*      ProductGrossContentQuantity,
*      ProductValidEndDate,
*      AssortmentListType,
*      TextilePartsIsWithAnimalOrigin,
*      ProductSeasonUsageCategory,
*      BillOfMaterialIsForEmpties,
*      ServiceAgreement,
*      ConsumptionValueCategory,
*      GoodsIssueUnit,
*      RegionOfOrigin,
*      ValuationClass,
*      SalesUnit,
*      ProductManufacturerNumber,
*      ManufacturerNumber,
*      ManufacturerPartProfile,
*      OwnInventoryManagedProduct,
 ) ).

MODIFY ENTITIES OF I_ProductTP_2
 ENTITY Product
  UPDATE FROM create_product

ENTITY ProductDescription
    UPDATE FIELDS ( ProductDescription )
    WITH VALUE #( ( %key-Product = product
                    %key-Language = 'E'
                    ProductDescription = WA_BASICDATA-MaterialDescription ) )

*************************************sales data *****************************
ENTITY ProductSales
    UPDATE FIELDS ( TransportationGroup )
    WITH VALUE #( ( %key-Product = product
                   TransportationGroup   =   WA_SALES-TransportationGroup ) )
**************************************Product Procurement*****************************
*ENTITY ProductProcurement
*    UPDATE FIELDS ( AssortmentGrade )
*    WITH VALUE #( ( %key-Product = product
*                   ) )
**************************************_ProductQuality Management*****************************
* CREATE BY \_ProductQualityManagement FROM VALUE #( (
*                                            %cid_ref = 'product1'
*                                            Product = product
*                                            %target = VALUE #(
*                                                (
*                                            %cid = 'ProductQualityManagement'
*                                            Product                        = product
*                                            QltyMgmtInProcmtIsActive       = 'X'
*                                            )
*                                            )
*                                            )
*                                            )

ENTITY ProductSalesDelivery
    UPDATE FIELDS ( StoreSaleStartDate StoreSaleEndDate DistrCenterSaleStartDate DistributionCenterSaleEndDate ProductUnitGroup
    StoreOrderMaxDelivQty PriceFixingCategory CompetitionPressureCategory ItemCategoryGroup AccountDetnProductGroup )
    WITH VALUE #( ( %key-Product = product
                    %key-ProductSalesOrg                = WA_SALES-SalesOrganization
                    %key-ProductDistributionChnl        = WA_SALES-DistributionChannel
                         ItemCategoryGroup              = WA_SALES-Generalitemcategorygroup
                         AccountDetnProductGroup        = WA_SALES-AccountAssignmentGroupforMater
                         StoreSaleStartDate             = '20240319'
                         StoreSaleEndDate               = '99990101'
                         DistrCenterSaleStartDate       = '20240319'
                         DistributionCenterSaleEndDate  = '99990101'
                         ProductUnitGroup                = wa_sales-Salesunit
                         StoreOrderMaxDelivQty          = '5'
                         PriceFixingCategory            = '1'
                         CompetitionPressureCategory    = 'A'                 ) )

***************************Plant Data *********************************************************
ENTITY ProductPlant
  UPDATE FIELDS ( ProfitCenter IsBatchManagementRequired )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                    ProfitCenter   =   PROFIT
                   IsBatchManagementRequired = WA_GeneralPlant-BatchMgmtRequirementIndicator ) )

ENTITY ProductPlantWorkScheduling
  UPDATE FIELDS ( BaseUnit ProductComponentBackflushCode )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                    BaseUnit   =   WA_GeneralPlant-BaseUnitofMeasure
                   ProductComponentBackflushCode = '1' ) )

ENTITY ProductPlantCosting
  UPDATE FIELDS ( TaskListGroup )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                   TaskListGroup = '0' ) )

ENTITY ProductPlantSupplyPlanning
  UPDATE FIELDS ( LotSizingProcedure MRPType MRPResponsible PlanningStrategyGroup ProcurementType AvailabilityCheckType DependentRequirementsType
       ProductRequirementsGrouping ProductComponentBackflushCode Currency BaseUnit )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                         LotSizingProcedure                     = WA_MRPDATA-LotSizingProcedwithinMatePlan
                         MRPType                                = wa_mrpdata-MRPType
                         MRPResponsible                         = wa_mrpdata-MRPController
                         PlanningStrategyGroup                  = wa_mrpdata-PlanningStrategyGroup
                         ProcurementType                        = wa_mrpdata-ProcurementType
                         AvailabilityCheckType                  = wa_mrpdata-CheckingGroupforAvailabiCheck
                         DependentRequirementsType              = wa_mrpdata-IndicaforRequirementsGrouping
                         ProductRequirementsGrouping            = wa_mrpdata-IndicaforRequirementsGrouping
                         ProductComponentBackflushCode          = wa_mrpdata-IndicatorBackflush
                         Currency                               = wa_mrpdata-Curry
                         BaseUnit                               = wa_mrpdata-BaseUnitofMeasure  ) )

*ENTITY ProductPlantPurchaseTax
*  UPDATE FIELDS ( DepartureCountry )
*    WITH VALUE #( ( %key-Product = product
*                    %key-Plant   = WA_GeneralPlant-Plant
*                   DepartureCountry = 'IN' ) )



*   CREATE BY \_ProductPlantQualityManagement FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantQuM'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
**                                                 ProdQltyManagementControlKey,
**      HasPostToInspectionStock,
**      InspLotDocumentationIsRequired,
**      QualityMgmtSystemForSupplier,
**      RecrrgInspIntervalTimeInDays,
**      ProductQualityCertificateType,
**      ProdQualityAuthorizationGroup,
*                                                )
*                                                )
*                                            ) )

ENTITY ProductPlantProcurement
  UPDATE FIELDS ( PurchasingGroup )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                   PurchasingGroup = WA_Purchase-PurchasingGroup ) )

ENTITY ProductPlantSales
  UPDATE FIELDS ( LoadingGroup AvailabilityCheckType BaseUnit )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                   LoadingGroup = WA_SALES-LoadingGroup
                   AvailabilityCheckType  = WA_SALES-CheckingGroupforAvailabilCheck
                   BaseUnit         = WA_SALES-BaseUnitofMeasure ) )

ENTITY ProductPlantInternationalTrade
  UPDATE FIELDS ( ConsumptionTaxCtrlCode  )
    WITH VALUE #( ( %key-Product = product
                    %key-Plant   = WA_GeneralPlant-Plant
                   ConsumptionTaxCtrlCode = WA_Purchase-Cntrlcdfrcnsumptntaxsnfrigntrd ) )

ENTITY ProductValuation
  UPDATE FIELDS (  PriceDeterminationControl ValuationClass StandardPrice ProductPriceUnitQuantity InventoryValuationProcedure MovingAveragePrice ValuationCategory )
    WITH VALUE #( ( %key-Product          = product
                    %key-ValuationArea    = WA_GeneralPlant-Plant
                    ValuationClass = ACCOUNTDATA-ValuationClass
                    PriceDeterminationControl = '1'
                    StandardPrice = ACCOUNTDATA-StandardPricewithPlusMinusSign
                    ProductPriceUnitQuantity = ACCOUNTDATA-Priceunit
                    InventoryValuationProcedure = ACCOUNTDATA-Pricecontrolindicator
                    MovingAveragePrice =  ACCOUNTDATA-MvgAvgPricePeriodicUnitPrice
                    ValuationCategory =  ACCOUNTDATA-ValuationCategory
                    ) )

ENTITY productvaluationledgeraccount
  UPDATE FIELDS ( StandardPrice  productpriceunitquantity )
    WITH VALUE #( ( %key-Product = product
    %key-ValuationType  = ''
    %key-CurrencyRole    = '10'
    %key-Ledger  = '0L'
    %key-ValuationArea = WA_GeneralPlant-Plant
    productpriceunitquantity = '1'
                   StandardPrice = ACCOUNTDATA-StandardPricewithPlusMinusSign ) )

 MAPPED DATA(mapped)
 REPORTED DATA(reported)
 FAILED DATA(failed).

 COMMIT ENTITIES BEGIN
 RESPONSE OF I_ProductTP_2
 FAILED DATA(failed_commit)
 REPORTED DATA(reported_commit).

 COMMIT ENTITIES END .
DATA product_t TYPE STRING.
DATA ERROR TYPE STRING.
 If failed_commit  is INITIAL  .

 loop at  mapped-product ASSIGNING FIELD-SYMBOL(<fs1>)    .
 product_t   = <fs1>-Product   .
* response->set_text( |{ product_t }| )  .
 endloop .

 ELSE.
  ERROR = 'E'.
IF reported-product IS NOT INITIAL .
  product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.
IF reported_commit-product IS NOT INITIAL .
   product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
 ENDIF.
 endif .

*  product_t = reported-productplantworkscheduling[ 1 ]-%msg->if_message~get_text( ).
*  product_t = reported-productplantcosting[ 1 ]-%msg->if_message~get_text( ).
*  product_t = reported-productplantmrp[ 1 ]-%msg->if_message~get_text( ).
*  product_t = reported-productvaluationledgeraccount[ 1 ]-%msg->if_message~get_text( ).
StatusRetun = ERROR && product_t.
******************************************************************************GREY MAT END********************************************
 ENDMETHOD.
ENDCLASS.
