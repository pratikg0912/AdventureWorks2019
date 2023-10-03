WITH cte AS (
SELECT
e.employee_code,
e.employee_name,
CASE
WHEN LAG(a.allocation_status_id) OVER (PARTITION BY e.employee_id ORDER BY a.from_date) IS NULL THEN NULL
ELSE LAG(a.allocation_status_id) OVER (PARTITION BY e.employee_id ORDER BY a.from_date)
END AS previous_allocation_status,
a.allocation_status_id AS current_allocation_status,
LAG(p.project_name) OVER (PARTITION BY e.employee_id ORDER BY a.from_date) AS previous_project_name,
LAG(a.from_date) OVER (PARTITION BY e.employee_id ORDER BY a.from_date) AS previous_project_from_date,
LAG(a.to_date) OVER (PARTITION BY e.employee_id ORDER BY a.from_date) AS previous_project_to_date,
p.project_name AS current_project_name,
a.from_date AS current_project_from_date,
a.to_date AS current_project_to_date,
ROW_NUMBER() OVER (PARTITION BY e.employee_id ORDER BY a.from_date DESC) AS rn
FROM employee e
INNER JOIN allocation a ON a.employee_id = e.employee_id
INNER JOIN project p ON p.project_id = a.project_id
INNER JOIN allocation_status ast ON ast.allocation_status_id=a.allocation_status_id
)
SELECT
employee_code,
employee_name,
previous_allocation_status,
current_allocation_status,
previous_project_name,
previous_project_from_date,
previous_project_to_date,
current_project_name,
current_project_from_date,
current_project_to_date
FROM cte
WHERE rn = 1
order by employee_name