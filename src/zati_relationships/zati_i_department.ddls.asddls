@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZATI_I_Department
  as select from zati_department
  association [0..*] to ZATI_I_Employee as _Employee on $projection.DepartmentId = _Employee.DepartmentId
{
  key department_id   as DepartmentId,
      department_name as DepartmentName,
      department_head as DepartmentHead,

      --Associations
      _Employee
}
