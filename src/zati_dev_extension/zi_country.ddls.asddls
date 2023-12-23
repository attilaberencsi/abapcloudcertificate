@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Countries'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_Country
  as select from I_Country
{
  key Country,
      CountryThreeLetterISOCode,
      CountryThreeDigitISOCode,
      CountryISOCode,
      IsEuropeanUnionMember,
      BankAndBankInternalIDCheckRule,
      BankInternalIDLength,
      BankInternalIDCheckRule,
      BankNumberLength,
      BankCheckRule,
      BankAccountLength,
      BankPostalCheckRule,
      BankDataCheckIsCountrySpecific,
      /* Associations */
      _Text
}
