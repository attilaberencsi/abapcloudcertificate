@AbapCatalog.sqlViewName: 'ZATIICARRIER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airplane'
@Search.searchable: true
define view ZATI_I_Carrier
  as select from zati_carrier as Airline

  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency

{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Name']
  key Airline.carrier_id    as AirlineID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      Airline.name          as Name,

      @Semantics.currencyCode: true
      Airline.currency_code as CurrencyCode,

      /* Associations */
      _Currency
}
