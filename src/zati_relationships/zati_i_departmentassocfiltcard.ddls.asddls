@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Association Filter Cardinality Hint'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZATI_I_DepartmentAssocFiltCard
  as select from zati_department
  association [0..*] to ZATI_I_Employee as _Employee on $projection.DepartmentId = _Employee.DepartmentId
{
  key department_id                                 as DepartmentId,
      department_name                               as DepartmentName,
      department_head                               as DepartmentHead,

      /*  Association filters also possible in path expressions
          to filter the data set of the association target.
          The cardinality can be changed supressing the warning with 1:
          just in case we are SURE that the association resolves ONE entry
          so the JOIN switches on HANA to MANY TO ONE                     */
      _Employee[1: EmployeeId = '123456' ].LastName as SupervisorName,

      --Associations
      _Employee
}
