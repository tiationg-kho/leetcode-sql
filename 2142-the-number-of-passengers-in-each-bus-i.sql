# Write your MySQL query statement below

WITH cte AS (
    SELECT p.passenger_id, MIN(b.arrival_time) AS take_time
    FROM passengers p
    INNER JOIN buses b
    ON b.arrival_time >= p.arrival_time
    GROUP BY p.passenger_id
)
SELECT b.bus_id, COUNT(cte.take_time) AS passengers_cnt
FROM cte
RIGHT JOIN buses b
ON cte.take_time = b.arrival_time
GROUP BY b.bus_id
ORDER BY bus_id;
