-- Problem: Sales leaderboard with ranking

SELECT 
    u.id,
    u.name,
    SUM(oi.quantity * oi.price_per_unit) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.price_per_unit) DESC
    ) AS rank_position
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY u.id, u.name;
