*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.
    DATA:
      carrier_id    TYPE c length 3,
      connection_id TYPE n length 4.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE clike
        i_connection_id TYPE clike
      RAISING
        cx_abap_invalid_value.

    CLASS-DATA:
      conn_counter TYPE int8.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.

    IF i_carrier_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value EXPORTING value = CONV #( i_carrier_id ).
    ENDIF.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

  ENDMETHOD.

ENDCLASS.
