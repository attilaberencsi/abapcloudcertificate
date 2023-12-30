"! <p class="shorttext synchronized" lang="en">EML Operations</p>
CLASS zcl_ati_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ati_eml IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA travel_read_keys   TYPE TABLE FOR READ IMPORT /DMO/R_Travel_D.
    DATA travel_read_result TYPE TABLE FOR READ RESULT /DMO/R_Travel_D.
    DATA travel_updates     TYPE TABLE FOR UPDATE /DMO/R_Travel_D.

    " READ
    SELECT SINGLE FROM /DMO/R_Travel_D
      FIELDS *
      INTO @DATA(travel_cds).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    travel_read_keys = VALUE #( ( TravelUUID = travel_cds-TravelUUID ) ).

    READ ENTITIES OF /DMO/R_Travel_D
         ENTITY Travel
         ALL FIELDS
         WITH travel_read_keys
         RESULT travel_read_result.

    out->write( '<--- Travel EML Read Before Update --->' ).
    out->write( travel_read_result ).

    " UPDATE
    travel_updates = VALUE #(
        ( TravelUUID = travel_cds-TravelUUID Description = |RELAX Time at { cl_abap_context_info=>get_system_time( ) TIME = USER }| ) ).

    MODIFY ENTITIES OF /DMO/R_Travel_D
           ENTITY Travel
           UPDATE FIELDS ( Description )
           WITH travel_updates.

    COMMIT ENTITIES. " IN SIMULATION MODE.

    " RE-READ
    READ ENTITIES OF /DMO/R_Travel_D
         ENTITY Travel
         ALL FIELDS
         WITH travel_read_keys
         RESULT travel_read_result.

    out->write( '<--- Travel EML Read After Update --->' ).
    out->write( travel_read_result ).
  ENDMETHOD.
ENDCLASS.
