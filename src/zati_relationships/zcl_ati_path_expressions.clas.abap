"! <p class="shorttext synchronized">CDS Association Path Expressions in ABAP SQL</p>
"! <strong>Association prefix</strong><br/>
"! In ABAP SQL path expressions, associations have to be escaped with a backslash (\).<br/>
"! <strong>Element Selector</strong><br/>
"! In CDS path expressions, a period sign (.) is used as separator between the association name and the element name.
"! In ABAP SQL, the period sign is not suitable because it would end the statement.
"! Therefore, in ABAP SQL, a hyphen is used as element selector.
"! <strong>Filter conditions</strong><br/>
"! In ABAP SQL, filter conditions are added in square brackets, just like in CDS.
"! However, to specify a cardinality, an entirely different syntax is used.
"! Instead of "1:", you have to add keywords <em>MANY TO ONE WHERE</em>.
"! There are several other options like <em>ONE TO ONE WHERE</em> and <em>MANY TO MANY WHERE</em>.
"! There is an alternative syntax where you write <em>[ (1) WHERE … ]</em> instead of <em>[ MANY TO ONE WHERE … ]</em>, but this alternative syntax is not recommended.
CLASS zcl_ati_path_expressions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ati_path_expressions IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT FROM ZATI_I_Department
      FIELDS DepartmentName,
             \_Employee[ MANY TO ONE WHERE EmployeeId = '123456' ]-LastName AS SupervisorName
      INTO TABLE @DATA(deputydirectors).

    out->write( deputydirectors ).

  ENDMETHOD.

ENDCLASS.
