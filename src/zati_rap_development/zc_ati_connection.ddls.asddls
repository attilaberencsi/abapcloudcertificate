@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_ATI_ACONN'
define root view entity ZC_ATI_CONNECTION
  provider contract transactional_query
  as projection on ZR_ATI_ACONN
{
  key UUID,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_ATI_Carrier_VH', element: 'AirlineID' }, useForValidation: true}]
      CarrierID,
      ConnectionID,
      AirportFromID,
      CityFrom,
      CountryFrom,
      AirportToID,
      CityTo,
      CountryTo,
      LocalLastChangedAt

}
