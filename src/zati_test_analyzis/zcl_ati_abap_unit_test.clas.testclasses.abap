*"* use this source file for your ABAP unit test classes
CLASS ltcl_unit DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS:
      test_success FOR TESTING RAISING cx_static_check,
      test_exception FOR TESTING.
ENDCLASS.


CLASS ltcl_unit IMPLEMENTATION.

  METHOD test_success.

    SELECT SINGLE FROM /DMO/I_Carrier
      FIELDS AirlineID
      INTO @DATA(carrier_id).

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( 'Test requires at least on entry in the table or view' ).
    ENDIF.

    TRY.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(carrier) = lcl_data=>get_carrier( carrier_id ).

      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( msg    = 'Inappropriate exception'
                                   level  = if_abap_unit_constant=>severity-medium
                                   quit   = if_abap_unit_constant=>quit-test
                                   detail = 'Method lcl_data=>get_carrier() raises an exception' ).

    ENDTRY.
  ENDMETHOD.

  METHOD test_exception.
    " Specify an incorrect Carrier
    CONSTANTS c_wrong_carrier_id TYPE /dmo/carrier_id VALUE 'HU'.

    SELECT SINGLE FROM /DMO/I_Carrier
      FIELDS AirlineID
      WHERE AirlineID = @c_wrong_carrier_id
    " TODO: variable is assigned but never used (ABAP cleaner)
      INTO @DATA(r_carrier_id).

    IF sy-subrc = 0.
      cl_abap_unit_assert=>fail( msg    = |Carrier { c_wrong_carrier_id } exists in /dmo/carrier|
                                 level  = if_abap_unit_constant=>severity-high
                                 quit   = if_abap_unit_constant=>quit-test
                                 detail = 'DB table /dmo/carrier contains an entry with '  &&
                                          | { c_wrong_carrier_id } . |   &&
                                          'Therefore not possible to test the exception' ).
    ENDIF.

    TRY.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(carrier) = lcl_data=>get_carrier( c_wrong_carrier_id ).

      CATCH cx_abap_invalid_value.
        RETURN.
    ENDTRY.

    cl_abap_unit_assert=>fail( msg    = 'No exception'
                               level  = if_abap_unit_constant=>severity-medium
                               quit   = if_abap_unit_constant=>quit-test
                               detail = 'Method does not raise an exceptiuon when it should.' ).
  ENDMETHOD.
ENDCLASS.
