"! <p class="shorttext synchronized" lang="en">Internal Table Operations</p>
CLASS zcl_ati_itab_pro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA out TYPE REF TO if_oo_adt_classrun_out.
    METHODS sorting_standard.
    METHODS duplicate_records.
    METHODS table_comprehension.
    METHODS reduce.
    METHODS field_symbols.
    METHODS access_performance_by_type.

ENDCLASS.



CLASS zcl_ati_itab_pro IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    me->out = out.

    sorting_standard( ).

    duplicate_records( ).

    table_comprehension( ).

    reduce( ).

    field_symbols( ).

    access_performance_by_type( ).

  ENDMETHOD.

  METHOD sorting_standard.
    TYPES t_flights TYPE STANDARD TABLE OF /dmo/flight WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA flights TYPE t_flights.

    flights = VALUE #(
        client = sy-mandt
        ( carrier_id = 'LH' connection_id = '0400' flight_date = '20230201' plane_type_id = '747-400' price = '600' currency_code = 'EUR' )
        ( carrier_id = 'LH' connection_id = '0400' flight_date = '20230115' plane_type_id = '747-400' price = '600' currency_code = 'EUR' )
        ( carrier_id = 'QF' connection_id = '0006' flight_date = '20230112' plane_type_id = 'A380' price = '1600' currency_code = 'AUD' )
        ( carrier_id = 'AA' connection_id = '0017' flight_date = '20230110' plane_type_id = '747-400' price = '600' currency_code = 'USD' )
        ( carrier_id = 'UA' connection_id = '0900' flight_date = '20230201' plane_type_id = '777-200' price = '600' currency_code = 'USD' ) ).

    out->write( 'Contents Before Sort' ).
    out->write( '____________________' ).
    out->write( flights ).
    out->write( ` ` ).

    " Sort with no additions - sort by primary table key carrier_id connection_id flight_date
    SORT flights.

    out->write( 'Effect of SORT with no additions - sort by primary table key' ).
    out->write( '____________________________________________________________' ).
    out->write( flights ).
    out->write( ` ` ).

    " Sort with field list - default sort direction is ascending
    SORT flights BY currency_code
                    plane_type_id.

    out->write( 'Effect of SORT with field list - ascending is default direction' ).
    out->write( '________________________________________________________________' ).
    out->write( flights ).
    out->write( ` ` ).

    " Sort with field list and sort directions.
    SORT flights BY carrier_Id ASCENDING
                    flight_Date DESCENDING.
    out->write( 'Effect of SORT with field list and sort direction' ).
    out->write( '_________________________________________________' ).
    out->write( flights ).
    out->write( ` ` ).
  ENDMETHOD.


  METHOD duplicate_records.


    TYPES t_flights TYPE STANDARD TABLE OF /dmo/flight WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA: flights TYPE t_flights.


    flights = VALUE #( ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = '20230201' plane_type_id = '747-400' price = '600' currency_code = 'EUR' )
    ( client = sy-mandt carrier_id = 'QF' connection_id = '0006' flight_date = '20230112' plane_type_id = 'A380' price = '1600' currency_code = 'AUD' )
    ( client = sy-mandt carrier_id = 'AA' connection_id = '0017' flight_date = '20230110' plane_type_id = '747-400' price = '600' currency_code = 'USD' )
    ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = '20230301' plane_type_id = '747-400' price = '600' currency_code = 'EUR' )
    ( client = sy-mandt carrier_id = 'UA' connection_id = '0900' flight_date = '20230201' plane_type_id = '777-200' price = '600' currency_code = 'USD' )
    ( client = sy-mandt carrier_id = 'QF' connection_id = '0006' flight_date = '20230210' plane_type_id = 'A380' price = '1600' currency_code = 'AUD' ) ).


    out->write( 'Contents Before DELETE ADJACENT DUPLICATES' ).
    out->write( '____________________' ).
    out->write( flights ).
    out->write( ` ` ).


    DELETE ADJACENT DUPLICATES FROM flights.
    out->write( 'Contents after DELETE ADJACENT DUPLICATES' ).
    out->write( 'Nothing deleted - key values are not adjacent' ).
    out->write( 'Sort the table before DELETE ADJACENT DUPLICATES').
    out->write( flights ).
    out->write( ` ` ).


    SORT flights BY carrier_id connection_id flight_date.
    DELETE ADJACENT DUPLICATES FROM flights.
    out->write( 'Contents after DELETE ADJACENT DUPLICATES' ).
    out->write( 'Nothing deleted - ABAP compares all key values including flight_date, which is different for every entry' ).
    out->write( flights ).
    out->write( ` ` ).


    DELETE ADJACENT DUPLICATES FROM flights COMPARING carrier_id connection_id.
    out->write( 'Contents after DELETE ADJACENT DUPLICATES with COMPARING and field list' ).
    out->write( 'Entries with identical values of carrier_id and connection_id have been deleted' ).
    out->write( flights ).

  ENDMETHOD.

  METHOD table_comprehension.

    TYPES: BEGIN OF t_connection,
             carrier_id             TYPE /dmo/carrier_id,
             connection_id          TYPE /dmo/connection_id,
             departure_airport      TYPE /dmo/airport_from_id,
             departure_airport_Name TYPE /dmo/airport_Name,
           END OF t_connection.

    TYPES t_connections TYPE STANDARD TABLE OF t_connection WITH NON-UNIQUE KEY carrier_id connection_id.

    DATA connections  TYPE TABLE OF /dmo/connection.
    DATA airports     TYPE TABLE OF /dmo/airport.
    DATA result_table TYPE t_connections.

    " Aim of the method:
    " Read a list of connections from the database and use them to fill an internal table result_table.
    " This contains some data from the table connections and adds the name of the departure airport.

    SELECT FROM /dmo/airport FIELDS * INTO TABLE @airports.
    SELECT FROM /dmo/connection FIELDS * INTO TABLE @connections.

    out->write( 'Connection Table' ).
    out->write( '________________' ).
    out->write( connections ).
    out->write( ` ` ).

    " The VALUE expression iterates over the table connections. In each iteration, the variable line
    " accesses the current line. Inside the parentheses, we build the next line of result_table by
    " copying the values of line-carrier_Id, line-connection_Id and line-airport_from_id, then
    " loooking up the airport name in the internal table airports using a table expression

    result_table = VALUE #( FOR line IN connections
                            ( carrier_Id             = line-carrier_id
                              connection_id          = line-connection_id
                              departure_airport      = line-airport_from_id
                              departure_airport_name = airports[ airport_id = line-airport_from_id ]-name ) ).

    out->write( 'Results' ).
    out->write( '_______' ).
    out->write( result_table ).
  ENDMETHOD.

  METHOD reduce.
    TYPES: BEGIN OF t_results,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
           END OF t_results.

    TYPES: BEGIN OF t_results_with_Avg,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
             average  TYPE p LENGTH 16 DECIMALS 2,
           END OF t_results_with_avg.

    DATA flights TYPE TABLE OF /dmo/flight.

    SELECT FROM /dmo/flight FIELDS * INTO TABLE @flights.

    " Result is a scalar data type
    DATA(sum) = REDUCE i( INIT total = 0 FOR line IN flights NEXT total = total + line-seats_occupied ).
    out->write( 'Result is a scalar data type' ).
    out->write( '_____________ ______________' ).
    out->write( sum ).
    out->write( ` ` ).

    " Result is a structured data type
    DATA(results) = REDUCE t_results( INIT totals TYPE t_results
    FOR line IN flights NEXT totals-occupied = totals-occupied + line-seats_occupied
    totals-maximum = totals-maximum + line-seats_max ).
    out->write( 'Result is a structure' ).
    out->write( '_____________________' ).

    out->write( results ).
    out->write( ` ` ).

    " Result is a structured data type
    " Reduction uses a local helper variable
    " Result of the reduction is always the *first* variable declared after init
    out->write( 'Result is a structure. The average is calculated using a local helper variable' ).
    out->write( '______________________________________________________________________________' ).

    DATA(result_with_Average) = REDUCE t_results_with_avg( INIT totals_avg TYPE t_results_with_avg count = 1
    FOR line IN flights NEXT totals_Avg-occupied = totals_Avg-occupied + line-seats_occupied
    totals_avg-maximum = totals_avg-maximum + line-seats_max
    totals_avg-average = totals_avg-occupied / count
    count = count + 1 ).
    out->write( result_with_average ).
  ENDMETHOD.

  METHOD field_symbols.
    DATA(flights) = NEW lcl_demo( ).

    flights->use_work_area( ).
    flights->use_field_symbol( ).
    out->write( 'Done' ).
  ENDMETHOD.


  METHOD access_performance_by_type.
    " Run this using the ABAP Profiler to measure relative access times for standard, sorted, and hashed tables

    DATA(flights) = NEW lcl_flights( ).
    flights->access_standard( ).
    flights->access_sorted( ).
    flights->access_hashed( ).

    out->write( |Done| ).
  ENDMETHOD.

ENDCLASS.
