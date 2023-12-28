# Write your MySQL query statement below

WITH cte AS (
    SELECT  t.request_at, t.id, t.status != 'completed' AS cancell
    FROM Trips t
    INNER JOIN Users u1
    ON t.client_id = u1.users_id
    INNER JOIN Users u2
    ON t.driver_id = u2.users_id
    WHERE 
        (t.request_at BETWEEN '2013-10-01' AND '2013-10-03') AND 
        (u1.banned = 'No') AND 
        (u2.banned = 'No')
)
SELECT cte.request_at AS Day, ROUND(SUM(cte.cancell) / COUNT(cte.id), 2) AS 'Cancellation Rate'
FROM cte
GROUP BY cte.request_at;
