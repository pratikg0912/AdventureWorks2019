WITH cte AS (
SELECT 
e.employee_id,
e.employee_code,
e.employee_name,
d.department_name AS current_department,
a.from_date,
a.to_date,
department_allocated_date AS date_of_change,
LAG(d.department_name) OVER (PARTITION BY e.employee_id ORDER BY a.from_date, a.to_date) AS previous_department,
LAG(a.to_date) OVER (PARTITION BY e.employee_id ORDER BY a.from_date, a.to_date) AS previous_to_date,
LAG(a.from_date) OVER (PARTITION BY e.employee_id ORDER BY a.from_date, a.to_date) AS previous_from_date,
ROW_NUMBER() OVER (PARTITION BY e.employee_id ORDER BY a.from_date DESC, a.to_date DESC) AS rn
FROM
allocation a
INNER JOIN
employee e ON e.employee_id = a.employee_id
INNER JOIN
project p ON p.project_id = a.project_id
INNER JOIN
department d ON d.department_id = p.department_id
INNER JOIN
department_change_history dc ON dc.employee_id = a.employee_id
)
SELECT
employee_id,
employee_code,
employee_name,
current_department,
from_date,
to_date,
previous_department,
previous_from_date,
previous_to_date,
date_of_change
FROM
cte
WHERE
rn = 2
AND current_department <> previous_department;