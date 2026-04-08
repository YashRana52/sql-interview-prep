-- Problem: Top 3 employees per department

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY department_id 
               ORDER BY salary DESC
           ) AS rn
    FROM employees
) t
WHERE rn <= 3;
