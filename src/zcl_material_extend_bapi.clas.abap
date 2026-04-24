CLASS zcl_material_extend_bapi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
    CLASS-METHODS :
      plantlocextd
      IMPORTING VALUE(TaxkID)  TYPE STring OPTIONAL
       VALUE(MAT)  TYPE STring OPTIONAL
        VALUE(PLANT)  TYPE STring OPTIONAL
         VALUE(SLOC)  TYPE STring OPTIONAL
      RETURNING VALUE(StatusRetun) TYPE string,

      saleorfdiST
      IMPORTING VALUE(TaxkID)  TYPE STring OPTIONAL
       VALUE(MAT)  TYPE STring OPTIONAL
        VALUE(SALESORG)  TYPE STring OPTIONAL
         VALUE(DISTURBCHL)  TYPE STring OPTIONAL
      RETURNING VALUE(StatusRetun) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MATERIAL_EXTEND_BAPI IMPLEMENTATION.


 METHOD saleorfdiST.


***************************************************************************** MAT START********************************************

DATA create_product TYPE TABLE FOR UPDATE I_ProductTP_2.

DATA PATYCODE TYPE C LENGTH 10 .
DATA PROFITCENTER TYPE C LENGTH 10 .
DATA product TYPE I_Product-Product .
*SELECT SINGLE * FROM ZMAT_BASICDATA_M_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(WA_BASICDATA) .
*
SELECT SINGLE * FROM ZMAT_SALESDATA_CDS WITH PRIVILEGED ACCESS
WHERE TaskIDNo = @taxkid INTO @DATA(WA_SALES) .
*
*SELECT SINGLE * FROM ZMAT_GENPLANT_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(WA_GeneralPlant) .
*
*SELECT SINGLE * FROM ZMAT_MRPDATA_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(WA_MRPDATA) .
*
*SELECT SINGLE * FROM ZMAT_PURDATA_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(WA_Purchase) .
*
*SELECT SINGLE * FROM ZMAT_COSTINGDATA_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(WA_Costingdata) .
*
*SELECT SINGLE * FROM zmat_wmdata_cds WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(WA_wmdata) .
*
*SELECT SINGLE * FROM ZMAT_ACCOUNTDATA_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(ACCOUNTDATA) .
*
*SELECT SINGLE * FROM ZMAT_QMDATA_CDS WITH PRIVILEGED ACCESS
*WHERE TaskIDNo = @taxkid INTO @DATA(QMDATA) .
*
*SELECT * FROM zmat_qm_insp_se_CDS WITH PRIVILEGED ACCESS
*WHERE Taskid = @taxkid INTO TABLE  @DATA(QMDATAINSP) .

product = MAT.
create_product = VALUE #( (
%key-Product = product

 ) ).

MODIFY ENTITIES OF I_ProductTP_2
 ENTITY Product
 CREATE BY \_ProductSalesDelivery FROM VALUE #( (
                                            %key-Product = product
                                            %target = VALUE #(
                                                (
                                            %cid = 'salesDel'
                                            %key-Product                        = product
                                            ProductSalesOrg                = salesorg
                                            ProductDistributionChnl        = disturbchl
                                            ItemCategoryGroup              = WA_SALES-Generalitemcategorygroup
                                            AccountDetnProductGroup        = WA_SALES-AccountAssignmentGroupforMater
*                                           CashDiscountIsDeductible,
                                           StoreSaleStartDate             = '20240319'
                                           StoreSaleEndDate               = '99990101'
                                           DistrCenterSaleStartDate       = '20240319'
                                           DistributionCenterSaleEndDate  = '99990101'
                                           ProductUnitGroup                = wa_sales-Salesunit
                                           StoreOrderMaxDelivQty          = '5'
                                           PriceFixingCategory            = '1'
                                           CompetitionPressureCategory    = 'A'
                                                )
                                                )
                                            ) )

  Entity ProductSalesDelivery
  CREATE BY \_ProdSalesDeliverySalesTax FROM VALUE #( (
                                            %cid_ref = 'salesDel'
                                            Product = product
                                            ProductSalesOrg = salesorg
                                            ProductDistributionChnl = disturbchl
                                            %target = VALUE #( (
                                                %cid = 'salestax1'
                                                Product = product
                                                ProductSalesOrg = salesorg
                                                ProductDistributionChnl = disturbchl
                                                Country = 'IN'
                                                ProductSalesTaxCategory = 'JOIG'
                                                ProductTaxClassification = '0'
                                            )
                                            (
                                                %cid = 'salestax2'
                                                Product = 'TEST_PRODUCT'
                                                ProductSalesOrg = salesorg
                                                ProductDistributionChnl = disturbchl
                                                Country = 'IN'
                                                ProductSalesTaxCategory = 'JOSG'
                                                ProductTaxClassification = '0'
                                            )
                                            (
                                                %cid = 'salestax3'
                                                Product = 'TEST_PRODUCT'
                                                ProductSalesOrg = salesorg
                                                ProductDistributionChnl = disturbchl
                                                Country = 'IN'
                                                ProductSalesTaxCategory = 'JOCG'
                                                ProductTaxClassification = '0'
                                            )
                                            (
                                                %cid = 'salestax4'
                                                Product = 'TEST_PRODUCT'
                                                ProductSalesOrg = salesorg
                                                ProductDistributionChnl = disturbchl
                                                Country = 'IN'
                                                ProductSalesTaxCategory = 'JOUG'
                                                ProductTaxClassification = '0'
                                            )
                                            (
                                                %cid = 'salestax5'
                                                Product = 'TEST_PRODUCT'
                                                ProductSalesOrg = salesorg
                                                ProductDistributionChnl = disturbchl
                                                Country = 'IN'
                                                ProductSalesTaxCategory = 'JCOS'
                                                ProductTaxClassification = '0'
                                            )
                                            (
                                                %cid = 'salestax6'
                                                Product = 'TEST_PRODUCT'
                                                ProductSalesOrg = salesorg
                                                ProductDistributionChnl = disturbchl
                                                Country = 'IN'
                                                ProductSalesTaxCategory = 'JTC1'
                                                ProductTaxClassification = '0'
                                            )
                                            )
                                          ) )
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
 product_t   = <fs1>-Product   ..
 endloop .

IF product_t IS INITIAL .

IF reported-product IS NOT INITIAL .
  ERROR = 'E'.
  product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.

IF reported_commit-product IS NOT INITIAL .
   ERROR = 'E'.
   product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.

ENDIF.

 ELSE.

IF reported-product IS NOT INITIAL .
ERROR = 'E'.
product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.

IF reported_commit-product IS NOT INITIAL .
ERROR = 'E'.
product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.

endif .

StatusRetun = ERROR && product_t.

 ENDMETHOD.


METHOD if_oo_adt_classrun~main.

DATA(REU) =  plantlocextd( taxkid = '1000024' ).


ENDMETHOD.


 METHOD plantlocextd.

***************************************************************************** MAT START********************************************

DATA create_product TYPE TABLE FOR UPDATE I_ProductTP_2.

DATA PATYCODE TYPE C LENGTH 10 .
DATA PROFITCENTER TYPE C LENGTH 10 .
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

SELECT * FROM zmat_qm_insp_se_CDS WITH PRIVILEGED ACCESS
WHERE Taskid = @taxkid INTO TABLE  @DATA(QMDATAINSP) .

product = MAT.
PROFITCENTER = |{ plant ALPHA = IN }| .
create_product = VALUE #( (
%key-Product = product

 ) ).

MODIFY ENTITIES OF I_ProductTP_2
 ENTITY Product
 CREATE BY \_ProductPlant AUTO FILL CID WITH VALUE #( (
                                                %key-Product = product
                                                %target = VALUE #( (
                                                %cid    = 'product2'
                                                %key-Product = product
                                                Plant   = plant
                                                ProfitCenter = PROFITCENTER
                                                ) )
                                            ) )

 ENTITY ProductPlant
  CREATE BY \_ProductPlantStorageLocation FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant =  plant
                                            %target = VALUE #(
                                                (
                                                %cid = 'ProdStorLoc'
                                                Product = product
                                                Plant = plant
                                                StorageLocation = sloc
                                                )
                                                )
                                            ) )

   CREATE BY \_ProductPlantWorkScheduling FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantWorkSch'
                                                 Product = product
                                                 Plant = Plant
      ProductComponentBackflushCode = '1'
      BaseUnit   =  wa_generalplant-BaseUnitofMeasure
                                                )
                                                )
                                            ) )
       CREATE BY \_ProductPlantCosting FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantCosting'
                                                 Product = product
                                                 Plant = Plant
                                                 TaskListGroup = '0'
                                                )
                                                )
                                            ) )
          CREATE BY \_ProductPlantSupplyPlanning FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantSupPlan'
                                                 Product = product
                                                 Plant = Plant
      LotSizingProcedure                     = WA_MRPDATA-LotSizingProcedwithinMatePlan
      MRPType                                = wa_mrpdata-MRPType
      MRPResponsible                         = wa_mrpdata-MRPController
     PlanningStrategyGroup    =  wa_mrpdata-PlanningStrategyGroup
      ProcurementType                    = wa_mrpdata-ProcurementType
      AvailabilityCheckType     = wa_mrpdata-CheckingGroupforAvailabiCheck
      DependentRequirementsType   = wa_mrpdata-IndicaforRequirementsGrouping
      ProductRequirementsGrouping  = wa_mrpdata-IndicaforRequirementsGrouping
      ProductComponentBackflushCode = wa_mrpdata-IndicatorBackflush
      Currency              = wa_mrpdata-Curry
      BaseUnit              = wa_mrpdata-BaseUnitofMeasure
                                                )
                                                )
                                            ) )
  CREATE BY \_ProductPlantPurchaseTax FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantPutax'
                                                 Product = product
                                                 Plant = Plant
                                                 DepartureCountry = 'IN'
                                                )
                                                )
                                            ) )
   CREATE BY \_ProductPlantQualityManagement FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantQuM'
                                                 Product = product
                                                 Plant = Plant
                                                )
                                                )
                                            ) )

      CREATE BY \_ProductPlantInspTypeSetting FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                             %target = VALUE #( FOR any IN QMDATAINSP  INDEX INTO i  (  %cid   = |bp1_BANK_{ i }_001|
                                                Product = product
                                                Plant = Plant
                                                InspectionLotType = ANY-Insptype
                                                InspLotIsTaskListRequired = SWITCH #( ANY-Active WHEN 'true' THEN 'X' ELSE '' )
                                                ProdInspTypeSettingIsActive = SWITCH #( ANY-Active WHEN 'true' THEN 'X' ELSE '' )
                                                InspQualityScoreProcedure = '06'
                                                )
                                                )
                                            ) )
    CREATE BY \_ProductPlantSales FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantSales1'
                                                 Product = product
                                                 Plant = Plant
                                                 LoadingGroup = WA_SALES-LoadingGroup

      AvailabilityCheckType  = WA_SALES-CheckingGroupforAvailabilCheck
      BaseUnit         = WA_SALES-BaseUnitofMeasure
                                                )
                                                )
                                            ) )
   CREATE BY \_ProductPlantForecast FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantIntlForecast'
                                                 Product = product
                                                 Plant = Plant

                                                )
                                                )
                                            ) )
  CREATE BY \_ProdPlantInternationalTrade FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                 %cid  = 'PlantIntlTrade'
                                                 Product = product
                                                 Plant = Plant
                                                 ConsumptionTaxCtrlCode = WA_Purchase-Cntrlcdfrcnsumptntaxsnfrigntrd
                                                )
                                                )
                                            ) )

   CREATE BY \_ProductPlantStorage FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant =  Plant
                                            %target = VALUE #(
                                                (
                                                %cid = 'ProdStorage'
                                                Product = product
                                                Plant = Plant
                                                )
                                                )
                                            ) )
   CREATE BY \_ProductPlantMRP FROM VALUE #( (
                                            %cid_ref = 'product2'
                                            Product = product
                                            Plant = Plant
                                            %target = VALUE #(
                                                (
                                                %cid = 'ProdMRPPLANT'
                                                Product = product
                                                Plant = Plant
                                                 MRPType = wa_mrpdata-MRPType
                                                 MRPResponsible   = wa_mrpdata-MRPController
                                                 MRPGroup   = wa_mrpdata-MRPGroup
                                                )
                                                )
                                            ) )

**************************************Product Valuation*****************************
ENTITY Product
CREATE BY \_ProductValuation
FIELDS ( ValuationArea ValuationType )
       WITH VALUE #( (
*                                            %cid_ref = 'product1'
                                            %key-Product = product
                                            %target = VALUE #(
                                                (
                                            %cid = 'Valuation'
                                            %key-Product = product
                                            ValuationArea  =  Plant
                                            ValuationClass = ACCOUNTDATA-ValuationClass
                                            PriceDeterminationControl = '2'
                                            StandardPrice = ACCOUNTDATA-StandardPricewithPlusMinusSign
                                            ProductPriceUnitQuantity = ACCOUNTDATA-Priceunit
                                            InventoryValuationProcedure = ACCOUNTDATA-Pricecontrolindicator
                                            MovingAveragePrice =  ACCOUNTDATA-MvgAvgPricePeriodicUnitPrice
                                            ValuationCategory =  ACCOUNTDATA-ValuationCategory
                                            Currency =  ACCOUNTDATA-CURRY

                                                )
                                                )
                                            ) )
   ENTITY ProductValuation
  create by \_ProductValuationAccounting FROM VALUE #( (
                                            %cid_ref = 'Valuation'
                                            Product = product
                                            ValuationArea =  Plant
                                            %target = VALUE #( (
                                                %cid = 'ValAcct'
                                                Product = product
                                                ValuationArea =  Plant
                                            ) )
                                          ) )
  CREATE BY \_productvaluationledgeraccount
  FIELDS ( ledger currencyrole )
  WITH VALUE #( (
                   %cid_ref = 'Valuation'
                   product = product
                   valuationarea = Plant
                   valuationtype = ''
                   %target = VALUE #(
                                      (
                                        %cid = 'Valuationled'
                                        product = product
                                        valuationarea = Plant
                                        valuationtype = ''
                                        ledger = '0L'
                                        productpriceunitquantity = '1'
                                        currency = 'INR'
                                        StandardPrice =  ACCOUNTDATA-StandardPricewithPlusMinusSign

                                      )

                                                )
                              )
                            )
  CREATE BY \_productvaluationledgerprices
  FIELDS ( ledger currencyrole )
  WITH VALUE #( (
                   %cid_ref = 'Valuation'
                   product = product
                   valuationarea = Plant
                   valuationtype = ''
                   %target = VALUE #(
                                      (
                                        %cid = 'Valuationledpric'
                                        product = product
                                        valuationarea = Plant
                                        valuationtype = ''
                                        ledger = '0L'
                                        productpriceunitquantity = '1'
                                        currency = 'INR'
                                      )

                                                )
                              )
                            )
  CREATE BY \_productvaluationcosting FROM VALUE #( (
                                            %cid_ref = 'Valuation'
                                            product = product
                                            valuationarea = Plant
                                            %target = VALUE #( (
                                                    %cid = 'ValCost'
                                                    product = product
                                                    valuationarea = Plant
                                                    productiscostedwithqtystruc = 'X'
                                                    Currency = 'INR'
                                                ) )
                                          ) )


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
 product_t   = <fs1>-Product   ..
 endloop .
IF product_t IS INITIAL .

IF reported-product IS NOT INITIAL .
 ERROR = 'E'.
  product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.
IF reported_commit-product IS NOT INITIAL .
 ERROR = 'E'.
   product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
 ENDIF.
ENDIF.

 ELSE.

IF reported-product IS NOT INITIAL .
  ERROR = 'E'.
  product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.

IF reported_commit-product IS NOT INITIAL .
  ERROR = 'E'.
   product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
 ENDIF.

 endif .
StatusRetun = ERROR && product_t.
******************************************************************************GREY MAT END********************************************
 ENDMETHOD.
ENDCLASS.
