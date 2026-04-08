-- Problem: Running total of daily sales

SELECT 
    created_at,
    SUM(amount) AS daily_sales,
    SUM(SUM(amount)) OVER (
        ORDER BY created_at
    ) AS running_total
FROM orders
GROUP BY created_at;
