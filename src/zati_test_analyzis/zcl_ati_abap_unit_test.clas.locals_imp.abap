*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_data DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_carrier IMPORTING i_carrier_id        TYPE /dmo/carrier_id
                              RETURNING VALUE(r_carrier_id) TYPE /dmo/carrier_id
                              RAISING   cx_abap_invalid_value.

 PROTECTED SECTION.
 PRIVATE SECTION.
ENDCLASS.

CLASS lcl_data IMPLEMENTATION.

  METHOD get_carrier.
    SELECT SINGLE FROM /DMO/I_Carrier
      FIELDS AirlineID
      WHERE AirlineID = @i_carrier_id
      INTO @r_carrier_id.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_abap_invalid_value( ).
    ELSE.
      RETURN r_carrier_id.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
