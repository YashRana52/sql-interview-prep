

-- Problem: Highest salary per department
-- Concept: RANK / DENSE_RANK


-- Table Structure
CREATE TABLE employees (
    id INT,
    name VARCHAR(100),
    salary INT,
    department_id INT
);

-- Solution (Window Function)
SELECT *
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY department_id 
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
WHERE rnk = 1;

-- Alternative (Without Window Function)
SELECT *
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);
