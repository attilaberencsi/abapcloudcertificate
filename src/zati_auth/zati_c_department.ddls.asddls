@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Department'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZATI_C_Department
  as select from ZATI_I_Department
{
  key DepartmentId,
      DepartmentName,
      DepartmentHead,
      /* Associations */
      _Employee
}
