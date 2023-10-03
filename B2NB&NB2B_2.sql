WITH cte AS (
SELECT
e.employee_code,
e.employee_name,
d.department_name AS department,
p.project_name AS project_name,
a.from_date AS allocation_from_date,
a.to_date AS allocation_to_date,
p.account_manager,
en.employee_name AS project_manager,
a.billable_percent AS billable_percent,
b.billability AS billability,
ROW_NUMBER() OVER (PARTITION BY e.employee_id ORDER BY a.from_date asc) AS rn
FROM
employee e
LEFT JOIN allocation a ON e.employee_id = a.employee_id
LEFT JOIN project p ON a.project_id = p.project_id
LEFT JOIN department d ON e.department_id = d.department_id
LEFT JOIN billability b ON a.billability = b.billability_id
LEFT JOIN employee en on en.employee_id = p.account_manager
)
SELECT
employee_code,
employee_name,
department,
project_name,
allocation_from_date,
allocation_to_date,
project_manager,
billability,
billable_percent,
rn as rank 
FROM
cte
ORDER BY
employee_name