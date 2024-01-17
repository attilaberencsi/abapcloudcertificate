CLASS lhc_connection DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Connection
        RESULT result,
      CheckSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckSemanticKey,
      CheckOriginDestination FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connection~CheckOriginDestination,
      GetCities FOR DETERMINE ON SAVE
        IMPORTING keys FOR Connection~GetCities.
ENDCLASS.

CLASS lhc_connection IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD CheckSemanticKey.

    " Fetch connections with the same semantic key
    READ ENTITIES OF zr_ati_aconn IN LOCAL MODE
         ENTITY Connection FIELDS ( CarrierID ConnectionID )
         WITH CORRESPONDING #( keys )
         RESULT DATA(connections).

    " There can be max 1 record for each Carrier + Connection
    " including the record being processed
    LOOP AT connections INTO DATA(connection).

      "Count active + drafts as well
      SELECT FROM zati_aconn
        FIELDS uuid
        WHERE carrier_id     = @connection-CarrierID
          AND connection_id  = @connection-ConnectionID
          AND uuid          <> @connection-uuid

      UNION

      SELECT FROM zati_aconn_d
        FIELDS uuid
        WHERE carrierid     = @connection-CarrierID
          AND connectionid  = @connection-ConnectionID
          AND uuid         <> @connection-uuid

      INTO TABLE @DATA(check_result).

      IF check_result IS NOT INITIAL.
        "Records with the same semantic key found, reject save
        MESSAGE ID 'ZATI_CONN' TYPE 'E' NUMBER '001' INTO DATA(dummy).

        DATA(message) = new_message( id       = 'ZATI_CONN'
                                     number   = '001'
                                     severity = ms-error
                                     v1       = connection-CarrierID
                                     v2       = connection-ConnectionID ).

        APPEND VALUE #( %tky                  = connection-%tky
                        %msg                  = message
                        %element-CarrierID    = if_abap_behv=>mk-on
                        %element-ConnectionID = if_abap_behv=>mk-on ) TO reported-connection.

        APPEND VALUE #( %tky = connection-%tky ) TO failed-connection.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD CheckOriginDestination.

    READ ENTITIES OF zr_ati_aconn IN LOCAL MODE
         ENTITY Connection
         FIELDS ( AirportFromID AirportToID )
         WITH CORRESPONDING #( keys )
         RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).

      " Departure and Arrival must be different
      IF connection-AirportFromID <> connection-AirportToID.
        CONTINUE.
      ENDIF.

      MESSAGE ID 'ZATI_CONN' TYPE 'E' NUMBER  '003' INTO DATA(dummy).
      DATA(message) = new_message( id       = 'ZATI_CONN'
                                   number   = '003'
                                   severity = ms-error ).

      APPEND VALUE #( %tky                   = connection-%tky
                      %msg                   = message
                      %element-AirportFromID = if_abap_behv=>mk-on
                      %element-AirportToID   = if_abap_behv=>mk-on ) TO reported-connection.

      APPEND VALUE #( %tky = connection-%tky ) TO failed-connection.
    ENDLOOP.
  ENDMETHOD.

  METHOD GetCities.
    READ ENTITIES OF zr_ati_aconn IN LOCAL MODE
         ENTITY Connection
         FIELDS ( AirportFromID AirportToID )
         WITH CORRESPONDING #( keys )
         RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).
      SELECT SINGLE FROM ZATI_I_Airport
        FIELDS city, CountryCode
        WHERE AirportID = @connection-AirportFromID
        INTO ( @connection-CityFrom, @connection-CountryTo ).

      SELECT SINGLE FROM ZATI_I_Airport
        FIELDS city,
               CountryCode
        WHERE AirportID = @connection-AirportToID
        INTO ( @connection-CityTo, @connection-CountryTo ).

      MODIFY connections FROM connection.
    ENDLOOP.

    DATA connections_update TYPE TABLE FOR UPDATE zr_ati_aconn.
    connections_update = CORRESPONDING #( connections ).

    MODIFY ENTITIES OF zr_ati_aconn IN LOCAL MODE
           ENTITY Connection
           UPDATE
           FIELDS ( CityFrom CountryFrom CityTo CountryTo )
           WITH connections_update
           REPORTED DATA(reported_records).

    reported-connection = CORRESPONDING #( reported_records-connection ).
  ENDMETHOD.

ENDCLASS.
