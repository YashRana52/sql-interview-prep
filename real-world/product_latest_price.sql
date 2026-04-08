-- Problem: Latest price per product

SELECT *
FROM (
    SELECT 
        product_id,
        price,
        effective_date,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY effective_date DESC
        ) AS rn
    FROM product_price_history
) t
WHERE rn = 1;
