"! <p class="shorttext synchronized">Hello World Console App</p>
"! You can run this on BTP with F9, and check the output in the Console View
CLASS zcl_ati_hello_world DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES:
      BEGIN OF order,
        item_id    TYPE c LENGTH 9,
        purch_date TYPE datn,
        proc_date  TYPE datn,
      END OF order.

    TYPES:
      BEGIN OF customer_purchase,
        cust_id    TYPE c LENGTH 8,
        cust_name  TYPE string,
        item_id    TYPE c LENGTH 9,
        purch_date TYPE datn,
        proc_date  TYPE datn,
      END OF customer_purchase,

      customer_purchases TYPE STANDARD TABLE OF customer_purchase
        WITH EMPTY KEY.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ati_hello_world IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( 'Hello World' ) ##NO_TEXT.

    DATA orders TYPE TABLE OF order.

    DATA(customer_purchases) = VALUE customer_purchases( ( cust_id    = '00000001'
                                                           cust_name  = `Customer A`
                                                           item_id    = '781029348'
                                                           purch_date = `20211108`
                                                           proc_date  = `20211109` )
                                                         ( cust_id    = '00000001'
                                                           cust_name  = `Customer A`
                                                           item_id    = '781028275'
                                                           purch_date = `20211117`
                                                           proc_date  = `20211118` )
                                                         ( cust_id    = '00000001'
                                                           cust_name  = `Customer A`
                                                           item_id    = '781029350'
                                                           purch_date = `20211203`
                                                           proc_date  = `20211206` )
                                                         ( cust_id    = '00000002'
                                                           cust_name  = `Customer B`
                                                           item_id    = '781029348'
                                                           purch_date = `20211207`
                                                           proc_date  = `20211208` )
                                                         ( cust_id    = '00000003'
                                                           cust_name  = `Customer C`
                                                           item_id    = '781029353'
                                                           purch_date = `20211215`
                                                           proc_date  = `20211216` )
                                                         ( cust_id    = '00000004'
                                                           cust_name  = `Customer D`
                                                           item_id    = '781029321'
                                                           purch_date = `20211215`
                                                           proc_date  = `20211216` )
                                                         ( cust_id    = '00000005'
                                                           cust_name  = `Customer E`
                                                           item_id    = '781029342'
                                                           purch_date = `20211216`
                                                           proc_date  = `20211217` ) ) ##NO_TEXT.

    LOOP AT customer_purchases REFERENCE INTO FINAL(customer_purchase) STEP -1
         WHERE purch_date <= `20211231` AND purch_date >= `20211001`.

      orders = VALUE #( BASE orders
                        ( item_id    = customer_purchase->item_id
                          purch_date = customer_purchase->purch_date
                          proc_date  = customer_purchase->proc_date ) ).

      FINAL(quarter) = 'Q4 2021'.
    ENDLOOP.

    out->write( |Orders of all customers in { quarter }:| ) ##NO_TEXT.
    out->write( orders ).
  ENDMETHOD.
ENDCLASS.
