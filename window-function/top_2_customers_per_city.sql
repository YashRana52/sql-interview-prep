-- Problem: Top 2 customers per city

SELECT *
FROM (
    SELECT 
        u.city,
        u.id,
        u.name,
        COUNT(o.id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY u.city 
            ORDER BY COUNT(o.id) DESC
        ) AS rn
    FROM users u
    JOIN orders o ON u.id = o.user_id
    GROUP BY u.city, u.id, u.name
) t
WHERE rn <= 2;
