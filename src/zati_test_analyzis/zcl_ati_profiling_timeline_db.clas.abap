"! <p class="shorttext synchronized" lang="en">ABAP Performance Profiling</p>
CLASS zcl_ati_profiling_timeline_db DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ati_profiling_timeline_db IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'LH'.

    TRY.
        DO 10 TIMES.
          DATA(carrier) = NEW lcl_carrier( c_carrier_id ).
          out->write( |Carrier '{ carrier->get_name( ) }' has currency '{ carrier->get_currency( ) }'| ).
        ENDDO.

      CATCH cx_abap_invalid_value.

        out->write( |Carrier '{ c_carrier_id }' does not exist. | ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
