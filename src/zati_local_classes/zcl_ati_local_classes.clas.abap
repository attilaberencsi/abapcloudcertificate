"! <p class="shorttext synchronized" lang="en">Working with local classes</p>
CLASS zcl_ati_local_classes DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ati_local_classes IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

    TRY.
        APPEND NEW #( i_carrier_id    = 'LH'
                      i_connection_id = '0400' ) TO connections.

        APPEND NEW #( i_carrier_id    = 'AA'
                      i_connection_id = '0017' ) TO connections REFERENCE INTO DATA(connection).
        connection->*->carrier_id    = 'AA'.
        connection->*->connection_id = '0017'.


        APPEND NEW #( i_carrier_id    = ''
                      i_connection_id = '0001' ) TO connections ASSIGNING FIELD-SYMBOL(<connection>).

      CATCH cx_abap_invalid_value INTO DATA(ex).

        out->write( ex->get_text( ) ).

    ENDTRY.

    out->write( connections ).
  ENDMETHOD.
ENDCLASS.
