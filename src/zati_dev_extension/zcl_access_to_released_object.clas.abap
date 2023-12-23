"! <p class="shorttext synchronized" lang="en">Released Object Access</p>
CLASS zcl_access_to_released_object DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_access_to_released_object IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT * FROM ZI_Country INTO TABLE @DATA(countries).
    out->write( data = countries ).
  ENDMETHOD.

ENDCLASS.
