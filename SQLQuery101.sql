SELECT STUFF((SELECT ', ' + CAST(s.skill AS VARCHAR(100))
    FROM employee_skills es 
join skill s on es.skill_id=s.skill_id
         WHERE es.employee_id  = a.employee_id
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') Skill2
,        STUFF((SELECT case when count(s.skill_family_id)>1 then s.skill_family else
',' + CAST(s.skill_family AS VARCHAR(100)) end as skillfam 
         FROM employee_skills es 
         join skill_family s on es.skill_family_id=s.skill_family_id
         WHERE es.employee_id  = a.employee_id and is_primary_skill = 1
         group by s.skill_family
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,0,' ') Skillfam
        ,a.employee_id, a.from_date, a.to_date,
    dbo.employee.employee_name, dbo.billability.billability, a.billable_percent, a.allocation_percent, dbo.allocation_status.allocation_status,
    dbo.customer.customer_name,am.employee_name as Account_Manager, dbo.project_type.project_type, dbo.project.project_name, dbo.designation.designation,dp1.department_name as Emp_Department,dp2.department_name as Prj_Department,
   employee.date_of_joining, dbo.employee.experience_years, dbo.employee.experience_months, a.allocation_id, dbo.employee.resignation_date,
    dbo.employee.last_working_day, a.comment, a.committed_project, a.committed_date, a.project_id, project_1.project_name AS temporary_allocation, 
    a.temp_allocation_from, a.temp_allocation_to,[sez_unit],[employee_location],[employee_status],[timeline]
from allocation a
INNER JOIN  dbo.employee  ON a.employee_id = employee.employee_id 
INNER JOIN  dbo.department dp1 ON employee.department_id = dp1.department_id
INNER JOIN  dbo.designation ON employee.designation_id  = dbo.designation.designation_id
INNER JOIN  dbo.allocation_status ON a.allocation_status_id = dbo.allocation_status.allocation_status_id 
INNER JOIN  dbo.project ON a.project_id = dbo.project.project_id 
INNER JOIN department dp2 on project.department_id=dp2.department_id
INNER JOIN  dbo.customer ON dbo.project.customer_id = dbo.customer.customer_id
INNER JOIN  dbo.project_type ON dbo.project.project_type_id = dbo.project_type.project_type_id
INNER JOIN  dbo.billability ON a.billability = cast(dbo.billability.billability_id as varchar(50))
LEFT OUTER JOIN  dbo.project AS project_1 ON a.temporary_allocation = project_1.project_id
LEFT OUTER JOIN employee am on dbo.project.account_manager=am.employee_id
INNER JOIN  employee_status on employee.employee_status_id=employee_status.employee_status_id
INNER JOIN  sez_unit on employee.sez_unit_id=sez_unit.sez_unit_id
INNER JOIN employee_location on employee.employee_location_id=employee_location.employee_location_id
order by a.employee_id,a.from_date