@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZATI_I_Employee
  as select from zati_employee
  association [1..1] to ZATI_I_Department as _Deapartment on $projection.DepartmentId = _Deapartment.DepartmentId
{
  key employee_id                 as EmployeeId,
      first_name                  as FirstName,
      last_name                   as LastName,
      birth_date                  as BirthDate,
      entry_date                  as EntryDate,
      department_id               as DepartmentId,
      annual_salary               as AnnualSalary,
      currency_code               as CurrencyCode,

      /*  Ad-hoc association usage with path expression
          Check the SQL Create Statement !              */
      _Deapartment.DepartmentName as DepartmentName,

      /* Propagated Associations  */
      _Deapartment
}
