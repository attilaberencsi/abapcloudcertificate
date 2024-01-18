@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department with Aggregated Association'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZATI_I_DepartmentAggr
  as select from zati_department
  association [0..*] to ZATI_I_Employee as _Employee on $projection.DepartmentId = _Employee.DepartmentId
{
  key department_id              as DepartmentId,
      department_name            as DepartmentName,
      department_head            as DepartmentHead,

      /* Use Aggregation and Group By to keep cardinality of result set */
      max( _Employee.BirthDate ) as YoungestBirthDay,

      --Associations
      _Employee
}

group by
  department_id,
  department_name,
  department_head
