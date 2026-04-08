-- Problem: Latest order per user

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id 
               ORDER BY created_at DESC
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
