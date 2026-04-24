CLASS zcl_material_bapi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
    CLASS-METHODS :
      CreateMat
      IMPORTING VALUE(TaxkID)  TYPE STring OPTIONAL
      RETURNING VALUE(StatusRetun) TYPE string,

        gET_ERROR
        IMPORTING VALUE(json)       TYPE string OPTIONAL
        RETURNING VALUE(error_desc) TYPE string,
        CreateDOCUMENT
        IMPORTING VALUE(json)             TYPE string OPTIONAL
        RETURNING VALUE(MAterialdocument) TYPE string,
        POSTMAT
        IMPORTING VALUE(json)             TYPE string OPTIONAL
        RETURNING VALUE(RESPOSE) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MATERIAL_BAPI IMPLEMENTATION.


  METHOD get_error.

    DATA lv TYPE string.
    FIELD-SYMBOLS <data>  TYPE data.
    FIELD-SYMBOLS <field> TYPE any.
    DATA(lr_d1) = /ui2/cl_json=>generate( json = json ).

    IF lr_d1 IS  BOUND .
      ASSIGN lr_d1->* TO <data>.
      ASSIGN COMPONENT `ERROR` OF STRUCTURE <data> TO <field>.
      IF sy-subrc = 0.
        ASSIGN <field>->* TO <data>.
        ASSIGN COMPONENT `INNERERROR` OF STRUCTURE <data> TO <field>.
        IF sy-subrc = 0.
          ASSIGN <field>->* TO <data>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT `ERRORDETAILS` OF STRUCTURE <data> TO <field>.
            IF sy-subrc = 0.
              ASSIGN <field>->* TO <data>.
              LOOP AT <data> ASSIGNING FIELD-SYMBOL(<fs>).
                ASSIGN <fs>->* TO FIELD-SYMBOL(<fs1>) .
                ASSIGN COMPONENT `MESSAGE` OF STRUCTURE <fs1> TO <field>    .
                IF sy-subrc = 0.
                  ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
                  ASSIGN <field>->* TO <data>.
                  DATA errormsj TYPE string.
                  errormsj = errormsj && cl_abap_char_utilities=>cr_lf && <data> .
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF errormsj IS INITIAL .
        IF lr_d1 IS  BOUND .
          ASSIGN lr_d1->* TO <data>.
          ASSIGN COMPONENT `ERROR` OF STRUCTURE <data> TO <field>.
          IF sy-subrc = 0.
            ASSIGN <field>->* TO <data>.
            ASSIGN COMPONENT `MESSAGE` OF STRUCTURE <data> TO <field>.
            IF sy-subrc = 0.
              ASSIGN <field>->* TO <data>.
              IF sy-subrc = 0.
                ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
                ASSIGN <field>->* TO <data>.
                errormsj  =  <data>.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      error_desc  =   errormsj .
    ENDIF .

  ENDMETHOD.

  METHOD createdocument.

    DATA lv TYPE string.
    FIELD-SYMBOLS <data>  TYPE data.
    FIELD-SYMBOLS <field> TYPE any.
    DATA(lr_d1) = /ui2/cl_json=>generate( json = json ).
    IF lr_d1 IS  BOUND .
      ASSIGN lr_d1->* TO <data>.
      ASSIGN COMPONENT `D` OF STRUCTURE <data> TO <field>.
      IF sy-subrc = 0.
        ASSIGN <field>->* TO <data>.
        ASSIGN COMPONENT `PURCHASEORDER` OF STRUCTURE <data> TO <field>.
        IF sy-subrc = 0.
          ASSIGN <field>->* TO <data>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
            ASSIGN <field>->* TO <data>.
          ENDIF.
        ENDIF.
      ENDIF.
      MAterialdocument  =   <data> .
    ENDIF .

  ENDMETHOD.

METHOD POSTMAT .

  TRY.
          DATA(lv_url) = |https://{ cl_abap_context_info=>get_system_url(  ) }:443/sap/opu/odata/sap/API_PRODUCT_SRV/A_Product|.
          DATA(lo_http_destination) =
               cl_http_destination_provider=>create_by_url( lv_url ).
          DATA(lo_web_http_client1) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
          DATA(lo_web_http_request1) = lo_web_http_client1->get_http_request( ).
          lo_web_http_request1->set_authorization_basic( i_username = 'MIG0311'
                                                         i_password = 'TnsaKwxsYGoVMb+WTAznkK5bLbBcUbwynDnmDTNU' ).
          lo_web_http_request1->set_header_field( i_name  = 'X-CSRF-Token'
                                                  i_value = 'fetch'  ).
          DATA(lo_web_http_response1) = lo_web_http_client1->execute( if_web_http_client=>get ).
          DATA(lv_response1) = lo_web_http_response1->get_header_fields( ).
          DATA(lv_COOKIE) = lo_web_http_response1->get_cookies( ).
          DATA(token) = VALUE #( lv_response1[ name = 'x-csrf-token' ]-value OPTIONAL ).

          " Create Http destination by url; API Endpoint for API Sandbox
          DATA(lo_http_destination1) =
               cl_http_destination_provider=>create_by_url( lv_url ).
          " create HTTP client by destination
          DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination1 ).
          " Adding headers
          DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
          lo_web_http_request->set_authorization_basic( i_username = 'MIG0311'
                                                        i_password = 'TnsaKwxsYGoVMb+WTAznkK5bLbBcUbwynDnmDTNU' ).
          lo_web_http_request->set_header_fields( VALUE #( (  name = 'x-csrf-token' value = token )
                                                           (  name = 'DataServiceVersion' value = '2.0' )
                                                           (  name = 'Accept' value = 'application/json' )
                                                           (  name = 'Content-Type' value = 'application/json' ) ) ).
          DATA(cookie11) = lv_COOKIE[ 1 ].
          lo_web_http_request->set_cookie( i_domain  = cookie11-domain
                                           i_expires = cookie11-expires
                                           i_name    = cookie11-name
                                           i_path    = cookie11-path
                                           i_secure  = cookie11-secure
                                           i_value   = cookie11-value  ).
          CONDENSE json.
          lo_web_http_request->set_text( json ).
          " set request method and execute request
          DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>post ).
          DATA(status)   =  lo_web_http_response->get_status( ) .
          DATA(Error1)   =  lo_web_http_response->get_text( ) .

          IF status-code = '201'.

            RESPOSE =  |{ 'Document Generated' } { CreateDOCUMENT( json =  lo_web_http_response->get_text( ) )  } |.

          ELSE.
            RESPOSE =  |{ status-code }{ 'Error' } { gET_ERROR( json =  lo_web_http_response->get_text( ) ) }|.

          ENDIF.

        CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
          " error handling
      ENDTRY.

ENDMETHOD.

 METHOD CreateMat.

***************************************************************************** MAT START********************************************

DATA create_product TYPE TABLE FOR CREATE I_ProductTP_2.

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

SELECT * FROM zmat_qm_insp_se_CDS WITH PRIVILEGED ACCESS
WHERE Taskid = @taxkid INTO TABLE  @DATA(QMDATAINSP) .

if WA_BASICDATA-BaseUnitofMeasure = 'PC'.
WA_BASICDATA-BaseUnitofMeasure = 'ST'.
ENDIF.


*SELECT SINGLE MAX( product )
*FROM I_product WITH PRIVILEGED ACCESS as a WHERE ProductType = @WA_BASICDATA-Materialtype
*AND Product LIKE '000000%'
*INTO @product.
*
*DATA PRFIRT TYPE C LENGTH 18.
*DATA PRFIRT1 TYPE C LENGTH 18.
*
*DATA(MAT1) = |{ product ALPHA = OUT }| .
*MAT1 = MAT1 + 1 .
*PRFIRT1  =  |{ MAT1 ALPHA = IN }|  .

data(json) =
 | { '{' } |   &&
 |  "Product": "string", |   &&
 |  "ProductType": "string", |   &&
 |  "CrossPlantStatus": "string", |   &&
 |  "CrossPlantStatusValidityDate": "/Date(1492041600000)/",|   &&
 |  "IsMarkedForDeletion": true,|   &&
 |  "ProductOldID": "string",|   &&
 |  "GrossWeight": "0",|   &&
 |  "PurchaseOrderQuantityUnit": "string",|   &&
 |  "SourceOfSupply": "string",|   &&
 |  "WeightUnit": "string",|   &&
 |  "NetWeight": "0",|   &&
 |  "CountryOfOrigin": "string",|   &&
 |  "CompetitorID": "string",|   &&
 |  "ProductGroup": "string",|   &&
 |  "BaseUnit": "string",|   &&
 |  "ItemCategoryGroup": "string",|   &&
 |  "ProductHierarchy": "string",|   &&
 |  "Division": "string",|   &&
 |  "VarblPurOrdUnitIsActive": "string",|   &&
 |  "VolumeUnit": "string",|   &&
 |  "MaterialVolume": "0",|   &&
 |  "ANPCode": "string",|   &&
 |  "Brand": "string",|   &&
 |  "ProcurementRule": "string",|   &&
 |  "ValidityStartDate": "/Date(1492041600000)/",|   &&
 |  "LowLevelCode": "string",|   &&
 |  "ProdNoInGenProdInPrepackProd": "string",|   &&
 |  "SerialIdentifierAssgmtProfile": "string",|   &&
 |  "SizeOrDimensionText": "string",|   &&
 |  "IndustryStandardName": "string",|   &&
 |  "ProductStandardID": "string",|   &&
 |  "InternationalArticleNumberCat": "string",|   &&
 |  "ProductIsConfigurable": true,|   &&
 |  "IsBatchManagementRequired": true,|   &&
 |  "ExternalProductGroup": "string",|   &&
 |  "CrossPlantConfigurableProduct": "string",|   &&
 |  "SerialNoExplicitnessLevel": "string",|   &&
 |  "ProductManufacturerNumber": "string",|   &&
 |  "ManufacturerNumber": "string",|   &&
 |  "ManufacturerPartProfile": "string",|   &&
 |  "QltyMgmtInProcmtIsActive": true,|   &&
 |  "IndustrySector": "string",|   &&
 |  "ChangeNumber": "string",|   &&
 |  "MaterialRevisionLevel": "string",|   &&
 |  "HandlingIndicator": "string",|   &&
 |  "WarehouseProductGroup": "string",|   &&
 |  "WarehouseStorageCondition": "string",|   &&
 |  "StandardHandlingUnitType": "string",|   &&
 |  "SerialNumberProfile": "string",|   &&
 |  "AdjustmentProfile": "string",|   &&
 |  "PreferredUnitOfMeasure": "string",|   &&
 |  "IsPilferable": true,|   &&
 |  "IsRelevantForHzdsSubstances": true,|   &&
 |  "QuarantinePeriod": "0",|   &&
 |  "TimeUnitForQuarantinePeriod": "string",|   &&
 |  "QualityInspectionGroup": "string",|   &&
 |  "AuthorizationGroup": "string",|   &&
 |  "DocumentIsCreatedByCAD": true,|   &&
 |  "HandlingUnitType": "string",|   &&
 |  "HasVariableTareWeight": true,|   &&
 |  "MaximumPackagingLength": "0",|   &&
 |  "MaximumPackagingWidth": "0",|   &&
 |  "MaximumPackagingHeight": "0",|   &&
 |  "UnitForMaxPackagingDimensions": "string",|   &&
 |  "to_Description": { '{' } | &&
 |     "results": { '[' }| &&
 |       { '{' }  |   &&
 |           "Product": "string",|   &&
 |           "Language": "string",|   &&
 |           "ProductDescription": "string"|   &&
 |        { '}' }|   &&
 |     { ']' }|   &&
 |  { '},' }|   &&
 |  "to_Plant": { '{' } |   &&
 |     "results": { '[' }|   &&
 |        { '{' }|   &&
  |          "Product": "string",|   &&
 |           "Plant": "string",|   &&
  |          "PurchasingGroup": "string",|   &&
   |         "CountryOfOrigin": "string",|   &&
   |         "RegionOfOrigin": "string",|   &&
   |         "ProductionInvtryManagedLoc": "string",|   &&
   |         "ProfileCode": "string",|   &&
   |         "ProfileValidityStartDate": "/Date(1492041600000)/",|   &&
   |         "AvailabilityCheckType": "string",|   &&
   |         "FiscalYearVariant": "string",|   &&
   |         "PeriodType": "string",|   &&
   |         "ProfitCenter": "string",|   &&
   |         "Commodity": "string",|   &&
   |         "GoodsReceiptDuration": "0",|   &&
   |         "MaintenanceStatusName": "string",|   &&
   |         "IsMarkedForDeletion": true,|   &&
   |         "MRPType": "string",|   &&
   |         "MRPResponsible": "string",|   &&
   |         "ABCIndicator": "string",|   &&
   |         "MinimumLotSizeQuantity": "0",|   &&
   |         "MaximumLotSizeQuantity": "0",|   &&
   |         "FixedLotSizeQuantity": "0",|   &&
   |         "ConsumptionTaxCtrlCode": "string",|   &&
   |         "IsCoProduct": true,|   &&
   |         "ProductIsConfigurable": "string",|   &&
   |         "StockDeterminationGroup": "string",|   &&
   |         "StockInTransferQuantity": "0",|   &&
   |         "StockInTransitQuantity": "0",|   &&
   |         "HasPostToInspectionStock": true,|   &&
   |         "IsBatchManagementRequired": true,|   &&
   |         "SerialNumberProfile": "string",|   &&
   |         "IsNegativeStockAllowed": true,|   &&
   |         "GoodsReceiptBlockedStockQty": "0",|   &&
   |         "HasConsignmentCtrl": "string",|   &&
   |         "FiscalYearCurrentPeriod": "string",|   &&
   |         "FiscalMonthCurrentPeriod": "string",|   &&
   |         "ProcurementType": "string",|   &&
   |         "IsInternalBatchManaged": true,|   &&
   |         "ProductCFOPCategory": "string",|   &&
   |         "ProductIsExciseTaxRelevant": true,|   &&
   |         "BaseUnit": "string",|   &&
   |         "ConfigurableProduct": "string",|   &&
   |         "GoodsIssueUnit": "string",|   &&
   |         "MaterialFreightGroup": "string",|   &&
   |         "OriginalBatchReferenceMaterial": "string",|   &&
   |         "OriglBatchManagementIsRequired": "string",|   &&
   |         "ProductIsCriticalPrt": true,|   &&
   |         "ProductLogisticsHandlingGroup": "string",|   &&
   |         "to_PlantMRPArea": { '{' } |   &&
   |            "results": { '[' } |   &&
   |               { '{' } |   &&
   |                  "Product": "string",|   &&
   |                  "Plant": "string",|   &&
   |                  "MRPArea": "string",|   &&
   |                  "MRPType": "string",|   &&
   |                  "MRPResponsible": "string",|   &&
   |                  "MRPGroup": "string",|   &&
   |                  "ReorderThresholdQuantity": "0",|   &&
   |                  "PlanningTimeFence": "string",|   &&
   |                  "LotSizingProcedure": "string",|   &&
   |                  "LotSizeRoundingQuantity": "0",|   &&
   |                  "MinimumLotSizeQuantity": "0",|   &&
   |                  "MaximumLotSizeQuantity": "0",|   &&
   |                  "MaximumStockQuantity": "0",|   &&
   |                  "AssemblyScrapPercent": "0",|   &&
   |                  "ProcurementSubType": "string",|   &&
   |                  "DfltStorageLocationExtProcmt": "string",|   &&
   |                  "MRPPlanningCalendar": "string",|   &&
   |                  "SafetyStockQuantity": "0",|   &&
   |                  "RangeOfCvrgPrflCode": "string",|   &&
   |                  "SafetyDuration": "string",|   &&
   |                  "FixedLotSizeQuantity": "0",|   &&
   |                  "LotSizeIndependentCosts": "0",|   &&
   |                  "IsStorageCosts": "string",|   &&
   |                  "RqmtQtyRcptTaktTmeInWrkgDays": "0",|   &&
   |                  "SrvcLvl": "0",|   &&
   |                  "IsMarkedForDeletion": true,|   &&
   |                  "PerdPrflForSftyTme": "string",|   &&
   |                  "IsMRPDependentRqmt": "string",|   &&
   |                  "IsSafetyTime": "string",|   &&
   |                  "PlannedDeliveryDurationInDays": "0",|   &&
   |                  "IsPlannedDeliveryTime": true,|   &&
   |                  "Currency": "string",|   &&
   |                  "BaseUnit": "string",|   &&
   |                  "PlanAndOrderDayDetermination": "string",|   &&
   |                  "RoundingProfile": "string",|   &&
   |                  "StorageLocation": "string"|   &&
   |               { '}' }|   &&
   |            { ']' }|   &&
   |         { '},' }|   &&
   |         "to_PlantQualityMgmt": "",|   &&
   |         "to_PlantSales": "",|   &&
   |         "to_PlantStorage": "",|   &&
   |         "to_PlantText": "",|   &&
   |         "to_ProdPlantInternationalTrade": "",|   &&
   |         "to_ProductPlantCosting": "",|   &&
   |         "to_ProductPlantForecast": "",|   &&
   |         "to_ProductPlantProcurement": "",|   &&
   |         "to_ProductSupplyPlanning": "",|   &&
   |         "to_ProductWorkScheduling": "",|   &&
   |         "to_StorageLocation": { '{' } |   &&
   |            "results": { ']' }|   &&
   |               { '{' }|   &&
   |                  "Product": "string",|   &&
   |                  "Plant": "string",|   &&
   |                  "StorageLocation": "string",|   &&
   |                  "WarehouseStorageBin": "string",|   &&
   |                  "PhysicalInventoryBlockInd": "string",|   &&
   |                  "IsMarkedForDeletion": true,|   &&
   |                  "DateOfLastPostedCntUnRstrcdStk": "/Date(1492041600000)/",|   &&
   |                  "InventoryCorrectionFactor": 3.14,|   &&
   |                  "InvtryRestrictedUseStockInd": "string",|   &&
   |                  "InvtryCurrentYearStockInd": "string",|   &&
   |                  "InvtryQualInspCurrentYrStkInd": "string",|   &&
   |                  "InventoryBlockStockInd": "string",|   &&
   |                  "InvtryRestStockPrevPeriodInd": "string",|   &&
   |                  "InventoryStockPrevPeriod": "string",|   &&
   |                  "InvtryStockQltyInspPrevPeriod": "string",|   &&
   |                  "HasInvtryBlockStockPrevPeriod": "string",|   &&
   |                  "FiscalYearCurrentPeriod": "string",|   &&
   |                  "FiscalMonthCurrentPeriod": "string",|   &&
   |                  "FiscalYearCurrentInvtryPeriod": "string",|   &&
   |                  "LeanWrhsManagementPickingArea": "string"|   &&
   |               { '}' }|   &&
   |            { ']' }|   &&
   |         { '}' }|   &&
   |      { '}' }|   &&
   |   { ']' }|   &&
  | { '},' }|   &&
  | "to_ProductBasicText": { '{' } |   &&
  |    "results": { '[' } |   &&
  |       { '{' } | &&
  |          "Product": "string",|   &&
  |          "Language": "string",|   &&
  |          "LongText": "string"|   &&
  |       { '}' }|   &&
  |    { ']' }|   &&
 |  { '},' }|   &&
 |  "to_ProductInspectionText": { '{' } |   &&
 |     "results": { '[  ]' } |   &&
 |        { '{' } |   &&
 |            "Product": "string",|   &&
 |           "Language": "string",|   &&
 |           "LongText": "string"|   &&
 |        { '}' }|   &&
 |     { ']' }|   &&
 |  { '},' }|   &&
 |  "to_ProductProcurement": "",|   &&
 |  "to_ProductPurchaseText": { '{' } |   &&
 |     "results": { '[]' } |   &&
 |        { '{' }|   &&
 |           "Product": "string",|   &&
 |           "Language": "string",|   &&
 |           "LongText": "string"|   &&
 |        { '}' }|   &&
 |     { ']' }|   &&
 |  { '},' }|   &&
 |  "to_ProductQualityMgmt": "",|   &&
 |  "to_ProductSales": "",|   &&
 |  "to_ProductSalesTax": { '{' }|   &&
 |     "results": { '[' }|   &&
 |        { '{' }|   &&
 |           "Product": "string",|   &&
 |           "Country": "string",|   &&
 |           "TaxCategory": "string",|   &&
 |           "TaxClassification": "string"|   &&
 |        { '}' }|   &&
 |     { '[' }|   &&
 |  { '},' }|   &&
 |  "to_ProductStorage": "",|   &&
 |  "to_ProductUnitsOfMeasure": { '{' } |   &&
 |     "results": { '[' } |   &&
 |        { '{' }|   &&
 |           "Product": "string",|   &&
 |           "AlternativeUnit": "string",|   &&
 |           "QuantityNumerator": "0",|   &&
 |           "QuantityDenominator": "0",|   &&
 |           "MaterialVolume": "0",|   &&
 |           "VolumeUnit": "string",|   &&
 |           "GrossWeight": "0",|   &&
 |           "WeightUnit": "string",|   &&
 |           "GlobalTradeItemNumber": "string",|   &&
 |           "GlobalTradeItemNumberCategory": "string",|   &&
 |           "UnitSpecificProductLength": "0",|   &&
 |           "UnitSpecificProductWidth": "0",|   &&
 |           "UnitSpecificProductHeight": "0",|   &&
 |           "ProductMeasurementUnit": "string",|   &&
 |           "LowerLevelPackagingUnit": "string",|   &&
 |           "RemainingVolumeAfterNesting": "0",|   &&
 |           "MaximumStackingFactor": 0,|   &&
 |           "CapacityUsage": "0",|   &&
 |           "BaseUnit": "string",|   &&
 |           "to_InternationalArticleNumber": { '{' }|   &&
 |              "results": { '[' }|   &&
 |                 { '{' }|   &&
 |                    "Product": "string",|   &&
 |                    "AlternativeUnit": "string",|   &&
 |                    "ConsecutiveNumber": "string",|   &&
 |                    "ProductStandardID": "string",|   &&
 |                    "InternationalArticleNumberCat": "string",|   &&
 |                    "IsMainGlobalTradeItemNumber": true|   &&
 |                 {  '}' }|   &&
 |              {  ']' }|   &&
 |           {  '}' }|   &&
 |        {  '}' }|   &&
 |     {  ']' }|   &&
 |  {  '},' }|   &&
 |  "to_SalesDelivery": { '{' } |   &&
 |     "results": { '[' }|   &&
 |        { '{' }|   &&
 |           "Product": "string",|   &&
 |           "ProductSalesOrg": "string",|   &&
 |           "ProductDistributionChnl": "string",|   &&
 |           "MinimumOrderQuantity": "0",|   &&
 |           "SupplyingPlant": "string",|   &&
 |           "PriceSpecificationProductGroup": "string",|   &&
 |           "AccountDetnProductGroup": "string",|   &&
 |           "DeliveryNoteProcMinDelivQty": "0",|   &&
 |           "ItemCategoryGroup": "string",|   &&
 |           "DeliveryQuantityUnit": "string",|   &&
 |           "DeliveryQuantity": "0",|   &&
 |           "ProductSalesStatus": "string",|   &&
 |           "ProductSalesStatusValidityDate": "/Date(1492041600000)/",|   &&
 |           "SalesMeasureUnit": "string",|   &&
 |           "IsMarkedForDeletion": true,|   &&
 |           "ProductHierarchy": "string",|   &&
 |           "FirstSalesSpecProductGroup": "string",|   &&
 |           "SecondSalesSpecProductGroup": "string",|   &&
 |           "ThirdSalesSpecProductGroup": "string",|   &&
 |           "FourthSalesSpecProductGroup": "string",|   &&
 |           "FifthSalesSpecProductGroup": "string",|   &&
 |           "MinimumMakeToOrderOrderQty": "0",|   &&
 |           "BaseUnit": "string",|   &&
 |          "LogisticsStatisticsGroup": "string",|   &&
 |          "VolumeRebateGroup": "string",|   &&
 |           "ProductCommissionGroup": "string",|   &&
 |           "CashDiscountIsDeductible": true,|   &&
 |           "PricingReferenceProduct": "string",|   &&
 |           "RoundingProfile": "string",|   &&
 |           "ProductUnitGroup": "string",|   &&
 |           "VariableSalesUnitIsNotAllowed": true,|   &&
 |           "ProductHasAttributeID01": true,|   &&
 |           "ProductHasAttributeID02": true,|   &&
 |           "ProductHasAttributeID03": true,|   &&
 |           "ProductHasAttributeID04": true,|   &&
 |           "ProductHasAttributeID05": true,|   &&
 |           "ProductHasAttributeID06": true,|   &&
 |           "ProductHasAttributeID07": true,|   &&
 |           "ProductHasAttributeID08": true,|   &&
 |           "ProductHasAttributeID09": true,|   &&
 |           "ProductHasAttributeID10": true,|   &&
 |           "to_SalesTax": { '{' } |   &&
 |              "results": { '[' }|   &&
 |                 { '{' }|   &&
 |                    "Product": "string",|   &&
 |                    "Country": "string",|   &&
 |                    "TaxCategory": "string",|   &&
 |                    "TaxClassification": "string"|   &&
 |                 { '}' }|   &&
 |              { ']' }|   &&
 |           { '},' }|   &&
 |           "to_SalesText": { '{' } |   &&
 |              "results": { '[' }|   &&
 |                 { '{' }|   &&
 |                    "Product": "string",|   &&
 |                    "ProductSalesOrg": "string",|   &&
 |                    "ProductDistributionChnl": "string",|   &&
 |                    "Language": "string",|   &&
 |                    "LongText": "string"|   &&
 |                 {  '}' }|   &&
 |              ]|   &&
 |           {  '}' }|   &&
 |        {  '}' }|   &&
 |     ]|   &&
 |  {  '},' }|   &&
 |  "to_Valuation": { '{' } |   &&
 |     "results": { '[' } |   &&
 |        { '{' }|   &&
 |           "Product": "string",|   &&
 |           "ValuationArea": "string",|   &&
 |           "ValuationType": "string",|   &&
 |           "ValuationClass": "string",|   &&
 |           "PriceDeterminationControl": "string",|   &&
 |           "StandardPrice": "0",|   &&
 |           "PriceUnitQty": "0",|   &&
 |           "InventoryValuationProcedure": "string",|   &&
 |           "IsMarkedForDeletion": true,|   &&
 |           "MovingAveragePrice": "0",|   &&
 |           "ValuationCategory": "string",|   &&
 |           "ProductUsageType": "string",|   &&
 |           "ProductOriginType": "string",|   &&
 |           "IsProducedInhouse": true,|   &&
 |           "ProdCostEstNumber": "string",|   &&
 |          "ProjectStockValuationClass": "string",|   &&
 |           "ValuationClassSalesOrderStock": "string",|   &&
 |           "PlannedPrice1InCoCodeCrcy": "0",|   &&
 |           "PlannedPrice2InCoCodeCrcy": "0",|   &&
 |           "PlannedPrice3InCoCodeCrcy": "0",|   &&
 |           "FuturePlndPrice1ValdtyDate": "/Date(1492041600000)/",|   &&
 |           "FuturePlndPrice2ValdtyDate": "/Date(1492041600000)/",|   &&
 |           "FuturePlndPrice3ValdtyDate": "/Date(1492041600000)/",|   &&
 |           "TaxBasedPricesPriceUnitQty": "0",|   &&
 |           "PriceLastChangeDate": "/Date(1492041600000)/",|   &&
 |           "PlannedPrice": "0",|   &&
 |           "PrevInvtryPriceInCoCodeCrcy": "0",|   &&
 |           "Currency": "string",|   &&
 |           "BaseUnit": "string",|   &&
 |           "to_MLAccount": { '{' }|   &&
 |              "results": { '[' }|   &&
 |                 { '{' }|   &&
 |                    "Product": "string",|   &&
 |                    "ValuationArea": "string",|   &&
 |                    "ValuationType": "string",|   &&
 |                    "CurrencyRole": "string",|   &&
 |                    "Currency": "string",|   &&
 |                    "ProductPriceControl": "string",|   &&
 |                    "PriceUnitQty": "0",|   &&
 |                    "MovingAveragePrice": "0",|   &&
 |                    "StandardPrice": "0"|   &&
 |                 {  '}' }|   &&
 |              { ']' }|   &&
 |           {  '}c,' }|   &&
 |           "to_MLPrices": { '{' }|   &&
 |              "results": { '[' }|   &&
 |                 { '{' }|   &&
 |                    "Product": "string",|   &&
 |                    "ValuationArea": "string",|   &&
 |                    "ValuationType": "string",|   &&
 |                    "CurrencyRole": "string",|   &&
 |                    "Currency": "string",|   &&
 |                    "FuturePrice": "0",|   &&
 |                    "FuturePriceValidityStartDate": "/Date(1492041600000)/",|   &&
 |                    "PlannedPrice": "0"|   &&
 |                 {  '}' }|   &&
 |              { '[' }|   &&
 |           {  '},' }|   &&
 |           "to_ValuationAccount": "",|   &&
 |           "to_ValuationCosting": ""|   &&
 |        {  '}' }|   &&
 |     { ']' }|   &&
 |  {  '}' }|   &&
| {  '}' }|   .



*| { '{' }                                                 |   &&
*|   "Product": "",     |   &&
*|   "ProductOldID": "string",     |   &&
*|   "ProductType": "ROH",     |   &&
*|   "ProductGroup": "Z001",     |   &&
*|   "BaseUnit": "KG",     |   &&
*|   "IndustrySector": "string",     |   &&
*|   "ItemCategoryGroup": "NORM",     |   &&
*|   "IsBatchManagementRequired": true,     |   &&
*|   "Division": "00",     |   &&
*|   "CrossPlantStatus": "string",     |   &&
*|   "ItemCategoryGroup": "string",     |   &&
*|   "NetWeight": "0",     |   &&
*|   "GrossWeight": "0",     |   &&
*|   "WeightUnit": "string",     |   &&
*|   "MaterialVolume": "0",     |   &&
*|   "AuthorizationGroup": "string",     |   &&
*|   "SizeOrDimensionText": "string",     |   &&
*|   "IndustryStandardName": "string",     |   &&
*|   "ProductStandardID": "string",     |   &&
*|   "InternationalArticleNumberCat": "string",     |   &&
*|   "ExternalProductGroup": "string",     |   &&
*|    "to_Description": { '{' }        |   &&
*|       "results":  { ']' }      |   &&
*|         { '{' }        |   &&
*|             "Product": "",     |   &&
*|             "Language": "E",     |   &&
*|             "ProductDescription": "TESTING ROH"        |   &&
*|       { '}' }          |   &&
*|        { ']' }    |   &&
*|    { '}' }    |   &&
*| { '}' }    |   .




Product = ''. "PRFIRT1.

create_product = VALUE #( (
 %cid = 'product1'
 Product =  product
 %control-Product = if_abap_behv=>mk-on
 ProductOldID = WA_BASICDATA-Oldmaterialnumber
 %control-ProductOldID = if_abap_behv=>mk-on

 ProductType = WA_BASICDATA-Materialtype
 %control-ProductType = if_abap_behv=>mk-on
 BaseUnit = WA_BASICDATA-BaseUnitofMeasure
 %control-BaseUnit = if_abap_behv=>mk-on
 IndustrySector =   'M'
 %control-IndustrySector = if_abap_behv=>mk-on
 ProductGroup = wa_basicdata-MaterialGroup
 %control-ProductGroup = if_abap_behv=>mk-on
 IsBatchManagementRequired = 'X'
 %control-IsBatchManagementRequired = if_abap_behv=>mk-on
 Division  = wa_basicdata-Division
 %control-Division = if_abap_behv=>mk-on
 CrossPlantStatus = wa_basicdata-CrossPlantMaterialStatus
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
 ExternalProductGroup = wa_basicdata-ExternalMaterialGroup
       ProdEffctyParamValsAreAssigned = wa_basicdata-Asgecvtyprmtrvlusoveridechngno
      PackagingProductGroup = wa_basicdata-MtrlGroupPackagingMaterials
      BasicProduct  = wa_basicdata-BasicMaterial
      ProdAllocDetnProcedure = wa_basicdata-Productallocadeterminanproced
 ) ).

MODIFY ENTITIES OF I_ProductTP_2
 ENTITY Product
  CREATE FROM create_product

 CREATE BY \_ProductDescription
 FIELDS ( Language ProductDescription ) WITH VALUE #( (
 %cid_ref = 'product1'
 Product = product
 %target = VALUE #(
 (
 %cid = 'desc1'
 Product = product
 Language = 'E'
 ProductDescription = WA_BASICDATA-MaterialDescription
 )
 )
 ) )
**************************************sales data *****************************
* CREATE BY \_ProductSales
*        FIELDS ( TransportationGroup  ) WITH VALUE #( (
*                                            %cid_ref = 'product1'
*                                            Product = product
*                                            %target = VALUE #( (
*                                                %cid = 'sales'
*                                                Product = product
*                                                TransportationGroup   =   WA_SALES-TransportationGroup
*                                                ) )
*                                            ) )
**************************************Product Procurement*****************************
* CREATE BY \_ProductProcurement FROM VALUE #( (
*                                            Product = product
*                                            %cid_ref = 'product1'
*                                            %target = VALUE #(
*                                                (
*                                            %cid = 'productProqument'
*                                            Product                        = product
*                                            )
*                                            )
*                                            )
*                                            )
**************************************_ProductQuality Management*****************************
* CREATE BY \_ProductQualityManagement FROM VALUE #( (
*                                            %cid_ref = 'product1'
*                                            Product = product
*                                            %target = VALUE #(
*                                                (
*                                            %cid = 'ProductQualityManagement'
*                                            Product                        = product
**                                            QltyMgmtInProcmtIsActive       = 'X'
*                                            )
*                                            )
*                                            )
*                                            )
*
* CREATE BY \_ProductSalesDelivery FROM VALUE #( (
*                                            %cid_ref = 'product1'
*                                            Product = product
*                                            %target = VALUE #(
*                                                (
*                                            %cid = 'salesDel'
*                                            Product                        = product
*                                            ProductSalesOrg                = WA_SALES-SalesOrganization
*                                            ProductDistributionChnl        = WA_SALES-DistributionChannel
*                                            ItemCategoryGroup              = WA_SALES-Generalitemcategorygroup
*                                            AccountDetnProductGroup        = WA_SALES-AccountAssignmentGroupforMater
**                                           CashDiscountIsDeductible,
*                                           StoreSaleStartDate             = '20240319'
*                                           StoreSaleEndDate               = '99990101'
*                                           DistrCenterSaleStartDate       = '20240319'
*                                           DistributionCenterSaleEndDate  = '99990101'
*                                           ProductUnitGroup                = wa_sales-Salesunit
*                                           StoreOrderMaxDelivQty          = '5'
*                                           PriceFixingCategory            = '1'
*                                           CompetitionPressureCategory    = 'A'
*                                                )
*                                                )
*                                            ) )
*
*  Entity ProductSalesDelivery
*  CREATE BY \_ProdSalesDeliverySalesTax FROM VALUE #( (
*                                            %cid_ref = 'salesDel'
*                                            Product = product
*                                            ProductSalesOrg = WA_SALES-SalesOrganization
*                                            ProductDistributionChnl = WA_SALES-DistributionChannel
*                                            %target = VALUE #( (
*                                                %cid = 'salestax1'
*                                                Product = product
*                                                ProductSalesOrg = WA_SALES-SalesOrganization
*                                                ProductDistributionChnl = WA_SALES-DistributionChannel
*                                                Country = 'IN'
*                                                ProductSalesTaxCategory = 'JOIG'
*                                                ProductTaxClassification = '0'
*                                            )
*                                            (
*                                                %cid = 'salestax2'
*                                                Product = 'TEST_PRODUCT'
*                                                ProductSalesOrg = WA_SALES-SalesOrganization
*                                                ProductDistributionChnl = WA_SALES-DistributionChannel
*                                                Country = 'IN'
*                                                ProductSalesTaxCategory = 'JOSG'
*                                                ProductTaxClassification = '0'
*                                            )
*                                            (
*                                                %cid = 'salestax3'
*                                                Product = 'TEST_PRODUCT'
*                                                ProductSalesOrg = WA_SALES-SalesOrganization
*                                                ProductDistributionChnl = WA_SALES-DistributionChannel
*                                                Country = 'IN'
*                                                ProductSalesTaxCategory = 'JOCG'
*                                                ProductTaxClassification = '0'
*                                            )
*                                            (
*                                                %cid = 'salestax4'
*                                                Product = 'TEST_PRODUCT'
*                                                ProductSalesOrg = WA_SALES-SalesOrganization
*                                                ProductDistributionChnl = WA_SALES-DistributionChannel
*                                                Country = 'IN'
*                                                ProductSalesTaxCategory = 'JOUG'
*                                                ProductTaxClassification = '0'
*                                            )
*                                            (
*                                                %cid = 'salestax5'
*                                                Product = 'TEST_PRODUCT'
*                                                ProductSalesOrg = WA_SALES-SalesOrganization
*                                                ProductDistributionChnl = WA_SALES-DistributionChannel
*                                                Country = 'IN'
*                                                ProductSalesTaxCategory = 'JCOS'
*                                                ProductTaxClassification = '1'
*                                            )
*                                            (
*                                                %cid = 'salestax6'
*                                                Product = 'TEST_PRODUCT'
*                                                ProductSalesOrg = WA_SALES-SalesOrganization
*                                                ProductDistributionChnl = WA_SALES-DistributionChannel
*                                                Country = 'IN'
*                                                ProductSalesTaxCategory = 'JTC1'
*                                                ProductTaxClassification = '1'
*                                            )
*                                            )
*                                          ) )
*
***************************Plant Data *********************************************************
*ENTITY Product
* CREATE BY \_ProductPlant AUTO FILL CID WITH VALUE #( (
*                                                Product = product
*                                                %cid_ref = 'product1'
*                                                %target = VALUE #( (
*                                                %cid    = 'product2'
*                                                Product = product
*                                                Plant   = WA_GeneralPlant-Plant
*                                                ProfitCenter = |{ WA_GeneralPlant-Plant ALPHA = IN }|  " WA_GeneralPlant-ProfitCenter
*                                                IsBatchManagementRequired = WA_GeneralPlant-BatchMgmtRequirementIndicator
*                                                ) )
*                                            ) )
*
* ENTITY ProductPlant
*  CREATE BY \_ProductPlantWorkScheduling FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantWorkSch'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*      ProductComponentBackflushCode = '1'
*      BaseUnit   =  wa_generalplant-BaseUnitofMeasure
*                                                )
*                                                )
*                                            ) )
*       CREATE BY \_ProductPlantCosting FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantCosting'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*                                                 TaskListGroup = '0'
*                                                )
*                                                )
*                                            ) )
*          CREATE BY \_ProductPlantSupplyPlanning FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantSupPlan'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*      LotSizingProcedure                     = WA_MRPDATA-LotSizingProcedwithinMatePlan
*      MRPType                                = wa_mrpdata-MRPType
*      MRPResponsible                         = wa_mrpdata-MRPController
*     PlanningStrategyGroup    =  wa_mrpdata-PlanningStrategyGroup
**      TotalReplenishmentLeadTime,
*      ProcurementType                    = wa_mrpdata-ProcurementType
*      AvailabilityCheckType     = wa_mrpdata-CheckingGroupforAvailabiCheck
*      DependentRequirementsType   = wa_mrpdata-IndicaforRequirementsGrouping
*      ProductRequirementsGrouping  = wa_mrpdata-IndicaforRequirementsGrouping
**      ProductionInvtryManagedLoc,
*      ProductComponentBackflushCode = wa_mrpdata-IndicatorBackflush
*      Currency              = wa_mrpdata-Curry
*      BaseUnit              = wa_mrpdata-BaseUnitofMeasure
*                                                )
*                                                )
*                                            ) )
*  CREATE BY \_ProductPlantPurchaseTax FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantPutax'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*                                                 DepartureCountry = 'IN'
*                                                )
*                                                )
*                                            ) )
*   CREATE BY \_ProductPlantQualityManagement FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantQuM'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*                                                )
*                                                )
*                                            ) )
*
*      CREATE BY \_ProductPlantInspTypeSetting FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                             %target = VALUE #( FOR any IN QMDATAINSP  INDEX INTO i  (  %cid   = |bp1_BANK_{ i }_001|
**                                            %target = VALUE #(
**                                                (
**                                                %cid = 'ProductPlantInspTypeSetting'
*                                                Product = product
*                                                Plant = WA_GeneralPlant-Plant
*                                                InspectionLotType = ANY-Insptype
*                                                InspLotIsTaskListRequired = SWITCH #( ANY-Active WHEN 'true' THEN 'X' ELSE '' )
*                                                ProdInspTypeSettingIsActive = SWITCH #( ANY-Active WHEN 'true' THEN 'X' ELSE '' )
*                                                InspQualityScoreProcedure = '06'
*                                                )
*                                                )
*                                            ) )
*    CREATE BY \_ProductPlantSales FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantSales1'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*                                                 LoadingGroup = WA_SALES-LoadingGroup
*      AvailabilityCheckType  = WA_SALES-CheckingGroupforAvailabilCheck
*      BaseUnit         = WA_SALES-BaseUnitofMeasure
*                                                )
*                                                )
*                                            ) )
*   CREATE BY \_ProductPlantForecast FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantIntlForecast'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*                                                )
*                                                )
*                                            ) )
*  CREATE BY \_ProdPlantInternationalTrade FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                 %cid  = 'PlantIntlTrade'
*                                                 Product = product
*                                                 Plant = WA_GeneralPlant-Plant
*                                                 ConsumptionTaxCtrlCode = WA_Purchase-Cntrlcdfrcnsumptntaxsnfrigntrd
*                                                )
*                                                )
*                                            ) )
*
*   CREATE BY \_ProductPlantStorage FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant =  WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                %cid = 'ProdStorage'
*                                                Product = product
*                                                Plant = WA_GeneralPlant-Plant
*                                                )
*                                                )
*                                            ) )
*
*  CREATE BY \_ProductPlantStorageLocation FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant =  WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                %cid = 'ProdStorLoc'
*                                                Product = product
*                                                Plant = WA_GeneralPlant-Plant
*                                                StorageLocation = WA_GeneralPlant-Storagelocation
*                                                )
*                                                )
*                                            ) )
*   CREATE BY \_ProductPlantMRP FROM VALUE #( (
*                                            %cid_ref = 'product2'
*                                            Product = product
*                                            Plant = WA_GeneralPlant-Plant
*                                            %target = VALUE #(
*                                                (
*                                                %cid = 'ProdMRPPLANT'
*                                                Product = product
*                                                Plant = WA_GeneralPlant-Plant
**                                                MRPArea = wa_mrpdata-
*                                                 MRPType = wa_mrpdata-MRPType
*                                                 MRPResponsible   = wa_mrpdata-MRPController
*                                                 MRPGroup   = wa_mrpdata-MRPGroup
*                                                )
*                                                )
*                                            ) )
*
*ENTITY Product
*    CREATE BY \_ProductStorage FROM VALUE #( (
*                                            %cid_ref = 'product1'
*                                            Product = product
*                                            %target = VALUE #(
*                                            (
*                                                %cid = 'ProductStorage'
*                                                Product = product
*      BaseUnit = WA_GeneralPlant-BaseUnitofMeasure
*                                                )
*                                                )
*                                            ) )
***************************************Product Valuation*****************************
*ENTITY Product
*CREATE BY \_ProductValuation
*FIELDS ( ValuationArea ValuationType )
*       WITH VALUE #( (
*                                            %cid_ref = 'product1'
*                                            Product = product
*                                            %target = VALUE #(
*                                                (
*                                            %cid = 'Valuation'
*                                            Product = product
*                                            ValuationArea  =  WA_GeneralPlant-Plant
**                                            ValuationType  = WA_GeneralPlant-
*                                            ValuationClass = ACCOUNTDATA-ValuationClass
*                                            PriceDeterminationControl = '2' "ACCOUNTDATA-Pricecontrolindicator
*                                            StandardPrice = ACCOUNTDATA-StandardPricewithPlusMinusSign
*                                            ProductPriceUnitQuantity = ACCOUNTDATA-Priceunit
*                                            InventoryValuationProcedure = ACCOUNTDATA-Pricecontrolindicator
*                                            MovingAveragePrice =  ACCOUNTDATA-MvgAvgPricePeriodicUnitPrice
*                                            ValuationCategory =  ACCOUNTDATA-ValuationCategory
*                                            Currency =  ACCOUNTDATA-CURRY
*
*                                                )
*                                                )
*                                            ) )
*   ENTITY ProductValuation
*  create by \_ProductValuationAccounting FROM VALUE #( (
*                                            %cid_ref = 'Valuation'
*                                            Product = product
*                                            ValuationArea =  WA_GeneralPlant-Plant
*                                            %target = VALUE #( (
*                                                %cid = 'ValAcct'
*                                                Product = product
*                                                ValuationArea =  WA_GeneralPlant-Plant
**                                                FuturePrice = 20
**                                                FuturePriceValidityStartDate = '20211025'
*                                            ) )
*                                          ) )
*  CREATE BY \_productvaluationledgeraccount
*  FIELDS ( ledger currencyrole )
*  WITH VALUE #( (
*                   %cid_ref = 'Valuation'
*                   product = product
*                   valuationarea = WA_GeneralPlant-Plant
*                   valuationtype = ''
*                   %target = VALUE #(
*                                      (
*                                        %cid = 'Valuationled'
*                                        product = product
*                                        valuationarea = WA_GeneralPlant-Plant
*                                        valuationtype = ''
*                                        ledger = '0L'
**                                        currencyrole = '10'
*                                        productpriceunitquantity = '1'
*                                        currency = 'INR'
*                                        StandardPrice =  ACCOUNTDATA-StandardPricewithPlusMinusSign
*
*                                      )
*
*                                                )
*                              )
*                            )
*  CREATE BY \_productvaluationledgerprices
*  FIELDS ( ledger currencyrole )
*  WITH VALUE #( (
*                   %cid_ref = 'Valuation'
*                   product = product
*                   valuationarea = WA_GeneralPlant-Plant
*                   valuationtype = ''
*                   %target = VALUE #(
*                                      (
*                                        %cid = 'Valuationledpric'
*                                        product = product
*                                        valuationarea = WA_GeneralPlant-Plant
*                                        valuationtype = ''
*                                        ledger = '0L'
**                                        currencyrole = '10'
*                                        productpriceunitquantity = '1'
*                                        currency = 'INR'
**                                        futurepricevaliditystartdate = sy-datum
*                                      )
*
*                                                )
*                              )
*                            )
*  CREATE BY \_productvaluationcosting FROM VALUE #( (
*                                            %cid_ref = 'Valuation'
*                                            product = product
*                                            valuationarea = WA_GeneralPlant-Plant
*                                            %target = VALUE #( (
*                                                    %cid = 'ValCost'
*                                                    product = product
*                                                    valuationarea = WA_GeneralPlant-Plant
*                                                    productiscostedwithqtystruc = 'X'
*                                                    Currency = 'INR'
*                                                ) )
*                                          ) )
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
IF product_t IS INITIAL .
 ERROR = 'E'.
IF reported-product IS NOT INITIAL .
  product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.
IF reported_commit-product IS NOT INITIAL .
   product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
 ENDIF.
ENDIF.

 ELSE.
  ERROR = 'E'.
IF reported-product IS NOT INITIAL .
  product_t = reported-product[ 1 ]-%msg->if_message~get_text( ).
ENDIF.
IF reported_commit-product IS NOT INITIAL .
   product_t = reported_commit-product[ 1 ]-%msg->if_message~get_text( ).
 ENDIF.
 endif .

StatusRetun = ERROR && product_t.
******************************************************************************GREY MAT END********************************************
 ENDMETHOD.


METHOD if_oo_adt_classrun~main.

DATA(REU) =  createmat( taxkid = '1000024' ).


ENDMETHOD.
ENDCLASS.
