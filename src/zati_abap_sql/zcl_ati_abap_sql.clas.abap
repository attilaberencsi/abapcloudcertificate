"! <p class="shorttext synchronized" lang="en">ABAP SQL</p>
CLASS zcl_ati_abap_sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_ati_abap_sql IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " ---------------------------------------------------------------------
    " LITERALS *                                                          -
    " ---------------------------------------------------------------------

    CONSTANTS c_number TYPE i VALUE 1234.

    SELECT FROM I_Country
      FIELDS 'Hello'   AS Character,    " Type c
             1         AS Integer1,     " Type i
             -1        AS Integer2,     " Type i

             @c_number AS constant      " Type i  (same as constant)

      INTO TABLE @DATA(result).

    out->write( data = result
                name = 'RESULT' ).

    " ---------------------------------------------------------------------
    " CAST *                                                              -
    " ---------------------------------------------------------------------

    SELECT FROM I_Language
      FIELDS '19891109'                         AS char_8,
             CAST( '19891109' AS CHAR( 4 ) )    AS char_4,
             CAST( '19891109' AS NUMC( 8  ) )   AS numc_8,

             CAST( '19891109' AS INT4 )         AS integer,
             CAST( '19891109' AS DEC( 10, 2 ) ) AS dec_10_2,
             CAST( '19891109' AS FLTP )         AS fltp,

             CAST( '19891109' AS DATS )         AS date

      INTO TABLE @DATA(results).

    out->write( data = results
                name = 'RESULTS' ).

    " ---------------------------------------------------------------------
    " CASE *                                                              -
    " ---------------------------------------------------------------------

    SELECT FROM I_LanguageText
      FIELDS LanguageCode,
             LanguageName,
             CASE LanguageCode
               WHEN 'D' THEN 'Deutsch'
               WHEN 'H' THEN 'Magyar'
               ELSE          ' '
            END                         AS title_long

      WHERE LanguageCode IN ( 'D', 'H' )
      INTO TABLE @DATA(result_simple).

    out->write( data = result_simple
                name = 'RESULT_SIMPLE' ).

    SELECT FROM I_Country
      FIELDS CountryISOCode,
             CountryThreeLetterISOCode,
             Country,
             CASE
               WHEN CountryISOCode < CountryThreeLetterISOCode THEN 'Less'
               WHEN CountryISOCode = CountryThreeLetterISOCode THEN 'Same'
               WHEN CountryISOCode > CountryThreeLetterISOCode THEN 'More'
               ELSE 'This is impossible'
             END                                                         AS Booking_State

      INTO TABLE @DATA(result_complex).

    out->write( data = result_complex
                name = 'RESULT_COMPLEX' ).

    " ---------------------------------------------------------------------
    " ARITHMETIC EXPRESSIONS *                                            -
    " ---------------------------------------------------------------------

* SELECT FROM /dmo/flight
*         FIELDS seats_max,
*                seats_occupied,
*
*                seats_max - seats_occupied           AS seats_avaliable,
*
*                (   CAST( seats_occupied AS FLTP )
*                  * CAST( 100 AS FLTP )
*                ) / CAST(  seats_max AS FLTP )       AS percentage_fltp
*
*           WHERE carrier_id = 'LH' AND connection_id = '0400'
*            INTO TABLE @DATA(result).
*
*    out->write(
*      EXPORTING
*        data   = result
*        name   = 'RESULT'
*    ).


*    SELECT FROM /dmo/customer
*         FIELDS customer_id,
*
*                street && ',' && ' ' && postal_code && ' ' && city   AS address_expr,
*
*                concat( street,
*                        concat_with_space(  ',',
*                                             concat_with_space( postal_code,
*                                                                upper(  city ),
*                                                                1
*                                                              ),
*                                            1
*                                         )
*                     ) AS address_func
*
*          WHERE country_code = 'ES'
*           INTO TABLE @DATA(result_concat).
*
*    out->write(
*      EXPORTING
*        data   = result_concat
*        name   = 'RESULT_CONCAT'
*    ).
*
***********************************************************************
*
*    SELECT FROM /dmo/carrier
*         FIELDS carrier_id,
*                name,
*                upper( name )   AS name_upper,
*                lower( name )   AS name_lower,
*                initcap( name ) AS name_initcap
*
*         WHERE carrier_id = 'SR'
*          INTO TABLE @DATA(result_transform).
*
*    out->write(
*      EXPORTING
*        data   = result_transform
*        name   = 'RESULT_TRANSLATE'
*    ).
*
***********************************************************************
*
*  SELECT FROM /dmo/flight
*       FIELDS flight_date,
*              cast( flight_date as char( 8 ) )  AS flight_date_raw,
*
*              left( flight_Date, 4   )          AS year,
*
*              right(  flight_date, 2 )          AS day,
*
*              substring(  flight_date, 5, 2 )   AS month
*
*        WHERE carrier_id = 'LH'
*          AND connection_id = '0400'
*         INTO TABLE @DATA(result_substring).
*
*    out->write(
*      EXPORTING
*        data   = result_substring
*        name   = 'RESULT_SUBSTRING'
*    ).


  "FUNCTIONS FOR PROCESSING DATES, TIMES, AND TIMESTAMPS

*    SELECT FROM /dmo/travel
*         FIELDS begin_date,
*                end_date,
*                is_valid( begin_date  )              AS valid,
*
*                add_days( begin_date, 7 )            AS add_7_days,
*                add_months(  begin_date, 3 )         AS add_3_months,
*                days_between( begin_date, end_date ) AS duration,
*
*                weekday(  begin_date  )              AS weekday,
*                extract_month(  begin_date )         AS month,
*                dayname(  begin_date )               AS day_name
*
*          WHERE customer_id = '000001'
*            AND days_between( begin_date, end_date ) > 10
*
*           INTO TABLE @DATA(result).
*
*    out->write(
*      EXPORTING
*        data   = result
*        name   = 'RESULT'
*    ).

  "CONVERSION FUNCTIONS


*  SELECT FROM /dmo/travel
*         FIELDS lastchangedat,
*                CAST( lastchangedat AS DEC( 15,0 ) ) AS latstchangedat_short,
*
*                tstmp_to_dats( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
*                               tzone = CAST( 'EST' AS CHAR( 6 ) )
*                             ) AS date_est,
*                tstmp_to_tims( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
*                               tzone = CAST( 'EST' AS CHAR( 6 ) )
*                             ) AS time_est
*
*          WHERE customer_id = '000001'
*           INTO TABLE @DATA(result_date_time).
*
*    out->write(
*      EXPORTING
*        data   = result_date_time
*        name   = 'RESULT_DATE_TIME'
*    ).
*
*
**********************************************************************
*
*    DATA(today) = cl_abap_context_info=>get_system_date(  ).
*
*    SELECT FROM /dmo/travel
*         FIELDS total_price,
*                currency_code,
*
*                currency_conversion( amount             = total_price,
*                                     source_currency    = currency_code,
*                                     target_currency    = 'EUR',
*                                     exchange_rate_date = @today
*                                   ) AS total_price_EUR
*
*          WHERE customer_id = '000001' AND currency_code <> 'EUR'
*           INTO TABLE @DATA(result_currency).
*
*    out->write(
*      EXPORTING
*        data   = result_currency
*        name   = 'RESULT__CURRENCY'
*    ).
*
*
***********************************************************************
*
*    SELECT FROM /dmo/connection
*         FIELDS distance,
*                distance_unit,
*                unit_conversion( quantity = CAST( distance AS QUAN ),
*                                 source_unit = distance_unit,
*                                 target_unit = CAST( 'MI' AS UNIT ) )  AS distance_MI
*
*          WHERE airport_from_id = 'FRA'
*           INTO TABLE @DATA(result_unit).
*
*    out->write(
*      EXPORTING
*        data   = result_unit
*        name   = 'RESULT_UNIT'
*    ).



  ENDMETHOD.
ENDCLASS.
