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

    " ---------------------------------------------------------------------

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
  ENDMETHOD.
ENDCLASS.
