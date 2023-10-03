select  * FROM employee_id,employee_name from employee
select * FROM allocation_status where employee_id = 312
select * from billability
select * from project
select * from department
select * from designation
select * from department_change_history
SELECT * FROM allocation
select * FROM allocation_status
select * from employee_status
select * from projection
select * from project
select e.employee_code, e.employee_name,a.project_id,
p.project_name,a.allocation_status_id,ast.allocation_status,
a.from_date,a.to_date
from employee e
inner join allocation a  ON e.employee_id= a.employee_id
inner join project p ON a.project_id = p.project_id
inner join allocation_status ast ON a.allocation_status_id=ast.allocation_status_id
--inner join billability ON b.billability_id=a.billability

