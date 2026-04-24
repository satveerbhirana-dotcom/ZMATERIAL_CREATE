CLASS zmdm_table_mat_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   CLASS-METHODS :
      CreateMat
      IMPORTING VALUE(TaxkID)  TYPE STring OPTIONAL
      VALUE(MATNR)  TYPE STring OPTIONAL
      RETURNING VALUE(StatusRetun) TYPE string,
      UnapprovedMat
      IMPORTING VALUE(TaxkID)  TYPE STring OPTIONAL
            Userid   TYPE string
      RETURNING VALUE(StatusRetun) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMDM_TABLE_MAT_UPDATE IMPLEMENTATION.


 METHOD CreateMat.


  UPDATE zmat_accountdata SET
       matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

    UPDATE zmat_basicdata_m SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.


        UPDATE zmat_costingdata SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.


        UPDATE zmat_genplant SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

        UPDATE zmat_mrpdata SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

           UPDATE zmat_purdata SET
              matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

           UPDATE zmat_qmdata SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

           UPDATE zmat_salesdata SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

           UPDATE zmat_wmdata SET
               matnr = @MATNR
                WHERE
              taskid = @taxkid .
      COMMIT WORK AND WAIT.

   StatusRetun = 'Material Update '  .
 ENDMETHOD.


 METHOD  UnapprovedMat.


   UPDATE zmat_accountdata SET
              apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.
IF Userid IS NOT  INITIAL .

    UPDATE zmat_basicdata_m SET
               apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000',
              unappid = @Userid,
              unapp_date  = @SY-datum,
              unapp_time = @SY-timlo

              WHERE
              taskid = @TaxkID .
ELSE.

   UPDATE zmat_basicdata_m SET
               apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .

ENDIF.
*      COMMIT WORK AND WAIT.


        UPDATE zmat_costingdata SET
               apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.


        UPDATE zmat_genplant SET
                apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.

        UPDATE zmat_mrpdata SET
                apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.

           UPDATE zmat_purdata SET
                apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.

           UPDATE zmat_qmdata SET
                apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.

           UPDATE zmat_salesdata SET
                apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.

           UPDATE zmat_wmdata SET
               apstatus  = '' ,
              appid = '',
              app_date = '00000000',
              app_time = '000000'
                WHERE
              taskid = @TaxkID .
*      COMMIT WORK AND WAIT.

 ENDMETHOD.
ENDCLASS.
