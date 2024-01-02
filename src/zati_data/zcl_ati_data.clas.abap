"! <p class="shorttext synchronized" lang="en">Working With Basic Data Objects and Data Types</p>
CLASS zcl_ati_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "Initial value by data type in constants
    CONSTANTS initial_value TYPE c LENGTH 3 VALUE IS INITIAL.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ati_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*   Data Objects with Built-in Types ----------------------------------------------------------------------
    " Comment/Uncomment the following declarations and check the output
    "DATA variable TYPE string.
    "DATA variable TYPE i.
    "DATA variable TYPE d.
    "DATA variable TYPE c LENGTH 10.
    "DATA variable TYPE n LENGTH 10.
    DATA variable TYPE p LENGTH 8 DECIMALS 2.

    " Output ----------------------------------------------------------------------
    out->write( 'Result with Initial Value'(001) ).
    out->write( variable ).
    out->write( '---------' ).
    variable = '19891109'.
    out->write( 'Result with Value 19891109'(002) ).
    out->write( variable ).
    out->write( '---------' ).

    " Example 1: Local Types ********************************************************************** -
    " Comment/Uncomment the following lines to change the type of my_var
    TYPES my_type TYPE p LENGTH 3 DECIMALS 2.
    "TYPES my_type TYPE i .
    "TYPES my_type TYPE string.
    "TYPES my_type TYPE n length 10.

    " Variable based on local type DATA my_variable TYPE my_type.
    DATA my_variable TYPE my_type.
    out->write( `my_variable (TYPE MY_TYPE)` ) ##NO_TEXT.
    out->write( my_variable ).

    " Example 2: Global Types ----------------------------------------------------------------------
    " Variable based on global type .
    " Place cursor on variable and press F2 or F3
    DATA airport TYPE /dmo/airport_id VALUE 'FRA'.
    out->write( `airport (TYPE /DMO/AIRPORT_ID )` ) ##NO_TEXT.
    out->write( airport ).

    " Example 3: Constants ----------------------------------------------------------------------
    CONSTANTS c_text   TYPE string VALUE `Hello World` ##NO_TEXT.
    CONSTANTS c_number TYPE i      VALUE 12345.
    " Uncomment this line to see syntax error ( VALUE is mandatory)
    " constants c_text2 type string.

    out->write( `c_text (TYPE STRING)` ) ##NO_TEXT.
    out->write( c_text ).
    out->write( '---------' ).
    out->write( `c_number (TYPE I )` ) ##NO_TEXT.
    out->write( c_number ).
    out->write( `---------` ).

    " Example 4 Literals ----------------------------------------------------------------------
    out->write( '12345 ' ).
    " Text Literal (Type C) out->write( '12345' ).
    " String Literal (Type STRING) out->write( 12345 ).
    " Number Literal (Type I)
    " uncomment this line to see syntax error (no number literal with digits)
    " out->write( 12345.67 ).
  ENDMETHOD.
ENDCLASS.
