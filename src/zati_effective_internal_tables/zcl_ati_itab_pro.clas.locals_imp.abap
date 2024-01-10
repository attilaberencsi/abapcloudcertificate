*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.


    METHODS use_work_area.
    METHODS use_field_symbol.
  PRIVATE SECTION.
    TYPES t_flights TYPE STANDARD TABLE OF /dmo/flight WITH NON-UNIQUE KEY carrier_id connection_id flight_date.


    METHODS loop_field_symbol CHANGING c_flights TYPE t_Flights.
    METHODS loop_Work_area CHANGING c_flights TYPE t_flights.
ENDCLASS.


CLASS lcl_demo IMPLEMENTATION.

  METHOD use_field_symbol.
    DATA flights TYPE t_flights.
    SELECT FROM /dmo/flight FIELDS * INTO TABLE @flights.
    loop_field_symbol( CHANGING c_flights = flights ).
  ENDMETHOD.


  METHOD use_work_area.
    DATA flights TYPE t_flights.
    SELECT FROM /dmo/flight FIELDS * INTO TABLE @flights.
    loop_work_area( CHANGING c_flights = flights ).
  ENDMETHOD.

  METHOD loop_field_symbol.
    LOOP AT c_flights ASSIGNING FIELD-SYMBOL(<flight>).
      <flight>-seats_occupied += 1.
    ENDLOOP.
  ENDMETHOD.

  METHOD loop_work_area.
    LOOP AT c_flights INTO DATA(flight).
      flight-seats_occupied += 1.
      MODIFY c_flights FROM flight.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_flights DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS access_standard.
    METHODS access_sorted.
    METHODS access_hashed.
  PRIVATE SECTION.


    DATA standard_table TYPE STANDARD TABLE OF zati_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA sorted_table TYPE SORTED TABLE OF zati_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA hashed_table TYPE HASHED TABLE OF zati_flights WITH UNIQUE KEY carrier_id connection_id flight_date.


    DATA key_carrier_id TYPE /dmo/carrier_id.
    DATA key_connection_id TYPE /dmo/connection_id.
    DATA key_date TYPE /dmo/flight_date.
    METHODS set_line_to_read.


ENDCLASS.


CLASS lcl_flights IMPLEMENTATION.


  METHOD access_hashed.
    DATA(result) = hashed_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.


  METHOD access_sorted.
    DATA(result) = sorted_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.


  METHOD constructor.
    SELECT FROM zati_flights FIELDS * INTO TABLE @standard_table.
    SELECT FROM zati_flights FIELDS * INTO TABLE @sorted_table.
    SELECT FROM zati_flights FIELDS * INTO TABLE @hashed_table.


    set_line_to_read( ).
  ENDMETHOD.

  METHOD access_standard.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(result) = standard_table[ carrier_Id    = key_carrier_id
                                   connection_Id = key_connection_id
                                   flight_date   = key_date ].
  ENDMETHOD.

  METHOD set_line_to_read.
    DATA(line) = standard_table[ CONV i( lines( standard_table ) * '0.65' ) ].
    key_carrier_id = line-carrier_Id.
    key_connection_Id = line-connection_id.
    key_date = line-flight_date.
  ENDMETHOD.


ENDCLASS.
