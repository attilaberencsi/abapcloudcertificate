"! <p class="shorttext synchronized" lang="en">ABAP Unit Test</p>
CLASS zcl_ati_abap_unit_test DEFINITION PUBLIC FINAL CREATE PUBLIC.
 PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.

 PROTECTED SECTION.
 PRIVATE SECTION.
ENDCLASS.

CLASS zcl_ati_abap_unit_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'AA'.

    TRY.
        DATA(carrier) = lcl_data=>get_carrier( i_carrier_id = c_carrier_id ).
        out->write( carrier ).

      CATCH cx_abap_invalid_value.
        out->write( |Carrier  { c_carrier_id } does not exist| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
