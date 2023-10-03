SELECT e.employee_id,e.employee_code,e.employee_name,
e.department_id as employee_department_id,d.department_name as employee_department_name,
p.department_id as project_department_id, dt1.department_name as project_department_name,
p.project_id,p.project_name,p.account_manager,en.employee_name as project_manager,
a.from_date,a.to_date
FROM project p
JOIN allocation a ON a.project_id = p.project_id
join employee e on a.employee_id = e.employee_id 
join employee en on en.employee_id = p.account_manager
JOIN department d ON e.department_id = d.department_id
JOIN department dt ON p.department_id = dt.department_id
JOIN department dt1 ON p.department_id = dt1.department_id
WHERE 
e.department_id != p.department_id 
--a.to_date >= GETDATE()
order by en.employee_name											