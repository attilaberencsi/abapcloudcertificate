"! <p class="shorttext synchronized" lang="en">Exception handling</p>
CLASS zcl_ati_exception DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS c_raise_custom TYPE abap_bool VALUE abap_false.
    DATA out TYPE REF TO if_oo_adt_classrun_out.
    METHODS raise_custom_exception.

ENDCLASS.



CLASS zcl_ati_exception IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      number1 TYPE i                     VALUE 2000000000,
      number2 TYPE p LENGTH 2 DECIMALS 1 VALUE '0.5',
      result  TYPE i.

    me->out = out.

    TRY.
        result = number1 / number2.

      CATCH cx_sy_arithmetic_overflow.
        out->write( 'Arithmetic Overflow' ).
      CATCH cx_sy_zerodivide.
        out->write( 'Division by zero' ).
    ENDTRY.

    number2 = 0.

    TRY.

        result = number1 / number2.

      CATCH cx_sy_arithmetic_overflow.
        out->write( 'Arithmetic Overflow' ).
      CATCH cx_sy_zerodivide.
        out->write( 'Division by zero' ).
    ENDTRY.

    TRY.
        result = number1 / number2.

      CATCH cx_sy_arithmetic_overflow cx_sy_zerodivide.
        out->write( 'Arithmetic overflow or division by zero' ).
    ENDTRY.

    TRY.
        result = number1 / number2.
      CATCH cx_sy_arithmetic_error.
        out->write( 'Caught both exceptions using their common superclass' ).
    ENDTRY.

    TRY.
        result = number1 / number2.
      CATCH cx_root.
        out->write( 'Caught any exception using CX_ROOT' ).
    ENDTRY.

    TRY.
        result = number1 / number2.
      CATCH cx_root INTO DATA(Exception).
        out->write( 'Used INTO to intercept the exception object' ).
        out->write( 'The get_Text( ) method returns the following error text: ' ).
        out->write( Exception->get_text( ) ).
    ENDTRY.

    IF c_raise_custom = abap_true.
      raise_custom_exception( ).
    ENDIF.


  ENDMETHOD.

  METHOD raise_custom_exception.

    DATA:
      fromairport TYPE zati_conn-airport_from_id,
      toairport   TYPE zati_conn-airport_to_id.

    SELECT SINGLE FROM zati_conn
      FIELDS airport_from_id, airport_to_id
      WHERE carrier_id    = 'HI'
        AND connection_id = '4444'
      INTO ( @fromairport, @toairport ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_ati_exception
        EXPORTING
          airlineid     = 'HI'
          connection_id = '4444'.
    ELSE.
      out->write( `I'm not trusting myself :D` ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
