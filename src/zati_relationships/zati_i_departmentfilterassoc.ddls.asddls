@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department with Association Filter'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZATI_I_DepartmentFilterAssoc
  as select from zati_department
  association [0..*] to ZATI_I_Employee as _Employee on $projection.DepartmentId = _Employee.DepartmentId
{
  key department_id                                       as DepartmentId,
      department_name                                     as DepartmentName,
      department_head                                     as DepartmentHead,

      /*  Association filters also possible in path expressions
          to filter the data set of the association target.
          On RHS literals, built-in function etc. possible      */
      max( _Employee[ EntryDate > BirthDate ].BirthDate ) as YoungestBirthDay,

      --Associations
      _Employee
}

group by
  department_id,
  department_name,
  department_head
