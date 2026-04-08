-- Problem: Calculate running balance for each bank account
-- Concept: CASE + cumulative SUM window function

SELECT 
    a.account_number,
    a.customer_name,
    t1.id AS transaction_id,
    t1.transaction_date,
    t1.transaction_type,
    t1.amount,
    a.opening_balance +
    (
        SELECT SUM(
            CASE
                WHEN t2.transaction_type = 'Credit' THEN t2.amount
                WHEN t2.transaction_type = 'Debit' THEN -t2.amount
                ELSE 0
            END
        )
        FROM transactions t2
        WHERE t2.account_id = t1.account_id
          AND t2.status = 'Success'
          AND (
                t2.transaction_date < t1.transaction_date
                OR (t2.transaction_date = t1.transaction_date AND t2.id <= t1.id)
          )
    ) AS running_balance
FROM transactions t1
JOIN accounts a 
    ON t1.account_id = a.id
WHERE t1.status = 'Success'
ORDER BY t1.account_id, t1.transaction_date, t1.id;
