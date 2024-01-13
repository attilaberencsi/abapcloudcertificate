*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING i_carrier_id TYPE clike
      RAISING   cx_abap_invalid_value.

    METHODS get_name     RETURNING VALUE(r_result) TYPE zati_carrier-name.
    METHODS get_currency RETURNING VALUE(r_result) TYPE zati_carrier-currency_code.


  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA carrier_data TYPE zati_carrier.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

* Method to be checked by the ATC

  METHOD constructor.
    SELECT SINGLE FROM ZATI_I_Carrier
      FIELDS AirlineID    AS carrier_id,
             Name         AS name,
             CurrencyCode AS currency_code
      WHERE AirlineID = @i_carrier_id
      INTO CORRESPONDING FIELDS OF @me->carrier_data.

    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_abap_invalid_value( ).
    ENDIF.
  ENDMETHOD.

  METHOD get_currency.

    r_result = me->carrier_data-currency_code.

  ENDMETHOD.

  METHOD get_name.

    r_result = me->carrier_data-name.

  ENDMETHOD.

ENDCLASS.
