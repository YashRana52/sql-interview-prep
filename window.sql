
USE practice_db;
-- 1. Department ke andar highest salary wale employee ko find karo  -----
-- DENSE_RANK version----

SELECT d.department_name, e.name, e.salary
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM employees
) e
JOIN departments d ON e.department_id = d.id
WHERE rnk = 1;

----- Correlated Subquery------
SELECT *
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- JOIN + GROUP BY-----
SELECT e.*
FROM employees e
JOIN (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
) t
ON e.department_id = t.department_id 
AND e.salary = t.max_salary;


-- Har department ke top 3 highest paid employees nikalo

-- Use: ROW_NUMBER() / 

SELECT *
FROM (
    SELECT 
        e.*,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees e
) t
WHERE rn <= 3;

-- DENSE_RANK() 
SELECT d.department_name, e.name, e.salary,rnk
FROM (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM employees
) e
JOIN departments d ON e.department_id = d.id
WHERE rnk <= 3;


-- Har city ke sabse zyada orders wale top 2 customers find karo----
SELECT *
FROM (
    SELECT 
        u.city,
        u.id AS user_id,
        u.name,
        COUNT(o.id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY u.city 
            ORDER BY COUNT(o.id) DESC
        ) AS rnk
    FROM users u
    JOIN orders o ON u.id = o.user_id
    GROUP BY u.city, u.id, u.name
) t
WHERE t.rnk <= 2;

-- Product category wise best selling product find karo----
SELECT *
FROM (
    SELECT 
        p.category,
        p.id AS product_id,
        p.name,
        sum(oi.quantity * oi.price_per_unit) as total_sales,
        Rank() OVER (
            PARTITION BY p.category
            ORDER BY sum(oi.quantity * oi.price_per_unit) DESC
        ) AS rnk
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY  p.category, p.id,  p.name
) t
WHERE t.rnk <= 1;

-- Har month ke top 5 revenue generating products nikalo

SELECT *
FROM (
    SELECT 
        MONTH(o.created_at) AS month,
        p.id AS product_id,
        p.name,
        SUM(oi.quantity * oi.price_per_unit) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY MONTH(o.created_at)
            ORDER BY SUM(oi.quantity * oi.price_per_unit) DESC
        ) AS rn
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON p.id = oi.product_id
    GROUP BY MONTH(o.created_at), p.id, p.name
) t
WHERE rn <= 5;

-- Har team ke andar latest joining employee ko identify karo----


SELECT d.department_name, e.name, e.hire_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY department_id 
               ORDER BY hire_date DESC
           ) AS rn
    FROM employees
) e
JOIN departments d ON e.department_id = d.id
WHERE rn = 1;


-- Har branch ke lowest performing employee ko find karo
SELECT d.department_name, e.name,e.salary
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY department_id 
               ORDER BY salary asc
           ) AS rn
    FROM employees
) e
JOIN departments d ON e.department_id = d.id
WHERE rn <= 1;


-- Tie hone par same rank dena hai — sales leaderboard banao---

SELECT 
    u.id AS user_id,
    u.name,
    SUM(oi.quantity * oi.price_per_unit) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.price_per_unit) DESC
    ) AS rank_position
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY u.id, u.name;

-- Unique serial rank assign karo chahe tie ho----

SELECT 
    u.id AS user_id,
    u.name,
    SUM(oi.quantity * oi.price_per_unit) AS total_sales,
   row_number() OVER (
        ORDER BY SUM(oi.quantity * oi.price_per_unit) DESC
    ) AS rank_position
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY u.id, u.name;

-- Har customer segment me top spender find karo----
SELECT *
FROM (
    SELECT 
        u.status AS segment,
        u.id AS user_id,
        u.name,
        SUM(o.amount) AS total_spend,
        DENSE_RANK() OVER (
            PARTITION BY u.status
            ORDER BY SUM(o.amount) DESC
        ) AS rnk
    FROM users u
    JOIN orders o ON u.id = o.user_id
    GROUP BY u.status, u.id, u.name
) t
WHERE rnk = 1;

-- Har user ka latest order nikaalo-------

SELECT u.name, o.*
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id 
               ORDER BY created_at DESC
           ) AS rn
    FROM orders
) o
JOIN users u ON o.user_id = u.id
WHERE rn = 1;
-- . Har patient ka latest appointment status find karo
SELECT *
FROM (
    SELECT 
        a.patient_id,
        p.name AS patient_name,
         d.name AS doctor_name,
        a.id AS appointment_id,
        a.appointment_date,
        a.status,
        ROW_NUMBER() OVER (
            PARTITION BY a.patient_id
            ORDER BY a.appointment_date DESC
        ) AS rn
    FROM appointments a
    JOIN patients p ON a.patient_id = p.id
      JOIN doctors d ON a.doctor_id = d.id
) t
WHERE rn = 1;



-- Har product ka most recent price record nikaalo ----

SELECT *
FROM (
    SELECT 
        pph.product_id,
        p.name AS product_name,
        pph.price,
        pph.effective_date,
        ROW_NUMBER() OVER (
            PARTITION BY pph.product_id
            ORDER BY pph.effective_date DESC
        ) AS rn
    FROM product_price_history pph
    JOIN products p ON pph.product_id = p.id
) t
WHERE rn = 1;















