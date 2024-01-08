"! <p class="shorttext synchronized" lang="en">ABAP Context info (SYST on BTP)</p>
CLASS zcl_ati_context_info DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ati_context_info IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA(sydatum) = cl_abap_context_info=>get_system_date( ).
    out->write( 'sy-datum: ' )->write( sydatum ).

    DATA(syuzeit) = cl_abap_context_info=>get_system_time( ).
    out->write( 'sy-uzeit: ' )->write( syuzeit ).

    DATA(syzonlo) = cl_abap_context_info=>get_system_time( ).
    out->write( 'sy-zonlo: ' )->write( syzonlo ).

    TRY.
        DATA(httpurlloc) = cl_abap_context_info=>get_system_url( ).
      CATCH cx_abap_context_info_error.
        out->write( 'Who Am I - Kein System ist Sicher' ).
    ENDTRY.

    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).
    out->write( 'sy-uname: ' )->write( user ).

    out->write( 'Find more in cl_abap_context_info' ).

  ENDMETHOD.
ENDCLASS.
