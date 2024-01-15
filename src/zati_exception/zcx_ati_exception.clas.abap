"! <p class="shorttext synchronized" lang="en">Exception with T100 (message class) text</p>
CLASS zcx_ati_exception DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF zcx_ati_exception,
        msgid TYPE symsgid      VALUE 'ZATI_EX',
        msgno TYPE symsgno      VALUE '001',
        attr1 TYPE scx_attrname VALUE 'AIRLINEID',
        attr2 TYPE scx_attrname VALUE 'CONNECTION_ID',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF zcx_ati_exception.

    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.

    DATA:
      airlineid     TYPE zati_flights-carrier_id,
      connection_id TYPE zati_flights-connection_id.

    METHODS constructor
      IMPORTING textid        LIKE if_t100_message=>t100key   OPTIONAL
                !previous     LIKE previous                   OPTIONAL
                airlineid     TYPE zati_flights-carrier_id    OPTIONAL
                connection_id TYPE zati_flights-connection_id OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_ati_exception IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).

    me->airlineid = airlineid.
    me->connection_id = connection_id.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = zcx_ati_exception.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
