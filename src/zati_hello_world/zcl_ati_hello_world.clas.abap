"! <p class="shorttext synchronized" lang="en">Hello World Console App</p>
"! You can run this on BTP with F9, and check the output in the Console View
CLASS zcl_ati_hello_world DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ati_hello_world IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    out->write( 'Hello World' ).

  ENDMETHOD.
ENDCLASS.
