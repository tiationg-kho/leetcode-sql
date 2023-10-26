# Write your MySQL query statement below

WITH cte AS (
    SELECT 
        seat_id,
        LEAD(free) OVER (ORDER BY seat_id) AS lead_free,
        LAG(free) OVER (ORDER BY seat_id) AS lag_free
    FROM Cinema
)
SELECT c.seat_id
FROM Cinema c
LEFT JOIN cte
ON c.seat_id = cte.seat_id
WHERE (cte.lead_free = 1 OR cte.lag_free = 1) and c.free = 1;
