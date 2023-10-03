WITH cte AS (
SELECT
e.employee_code,
e.employee_name,
ast_previous.allocation_status AS previous_allocation_status,
ast_current.allocation_status AS current_allocation_status,
LAG(p_previous.project_name) OVER (PARTITION BY e.employee_id ORDER BY a_current.from_date) AS previous_project_name,
LAG(a_previous.from_date) OVER (PARTITION BY e.employee_id ORDER BY a_current.from_date) AS previous_project_from_date,
LAG(a_previous.to_date) OVER (PARTITION BY e.employee_id ORDER BY a_current.from_date) AS previous_project_to_date,
p_current.project_name AS current_project_name,
a_current.from_date AS current_project_from_date,
a_current.to_date AS current_project_to_date,
ROW_NUMBER() OVER (PARTITION BY e.employee_id ORDER BY a_current.from_date DESC) AS rn
FROM employee e
INNER JOIN allocation a_current ON a_current.employee_id = e.employee_id
INNER JOIN project p_current ON p_current.project_id = a_current.project_id
LEFT JOIN allocation a_previous ON a_previous.employee_id = e.employee_id
AND a_previous.to_date < a_current.from_date
LEFT JOIN project p_previous ON p_previous.project_id = a_previous.project_id
LEFT JOIN allocation_status ast_previous ON ast_previous.allocation_status_id = a_previous.allocation_status_id
LEFT JOIN allocation_status ast_current ON ast_current.allocation_status_id = a_current.allocation_status_id
LEFT JOIN billability b ON b.billability_id = a_current.billability
)
SELECT
employee_code,
employee_name,
COALESCE(previous_allocation_status, 'N/A') AS previous_allocation_status,
COALESCE(current_allocation_status, 'N/A') AS current_allocation_status,
COALESCE(previous_project_name, 'N/A') AS previous_project_name,
previous_project_from_date,
previous_project_to_date,
COALESCE(current_project_name, 'N/A') AS current_project_name,
current_project_from_date,
current_project_to_date
FROM cte
WHERE rn = 1
order by employee_name