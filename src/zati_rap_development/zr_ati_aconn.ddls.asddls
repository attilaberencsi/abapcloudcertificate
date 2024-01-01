@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Connections'
define root view entity ZR_ATI_ACONN
  as select from zati_aconn as Connection
{
  key uuid as UUID,
  carrier_id as CarrierID,
  connection_id as ConnectionID,
  airport_from_id as AirportFromID,
  city_from as CityFrom,
  country_from as CountryFrom,
  airport_to_id as AirportToID,
  city_to as CityTo,
  country_to as CountryTo,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
