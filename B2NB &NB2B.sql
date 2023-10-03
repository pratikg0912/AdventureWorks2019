WITH cte AS (
SELECT
e.employee_code,
e.employee_name,
d.department_name AS current_department,
p.project_name AS current_project_name,
a.from_date AS allocation_from_date,
a.to_date AS allocation_to_date,
p.account_manager,
en.employee_name AS project_manager,
LAG(p.project_name) OVER (PARTITION BY e.employee_id ORDER BY a.from_date desc) AS previous_project_name,
LAG(a.billable_percent) OVER (PARTITION BY e.employee_id ORDER BY a.from_date desc ) AS previous_billable_percent,
LAG(b.billability) OVER (PARTITION BY e.employee_id ORDER BY a.from_date desc ) AS previous_billability,
a.billable_percent AS current_billable_percent,
b.billability AS current_billability,
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
current_department,
current_project_name,
allocation_from_date,
allocation_to_date,
--account_manager,
project_manager,
previous_billability,
current_billability,
previous_project_name,
previous_billable_percent,
current_billable_percent
FROM
cte
WHERE
rn = 1
ORDER BY
employee_name