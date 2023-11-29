# Write your MySQL query statement below

WITH RECURSIVE cte AS (
    SELECT p.passenger_id, MIN(b.arrival_time) AS take_time
    FROM passengers p
    INNER JOIN buses b
    ON b.arrival_time >= p.arrival_time
    GROUP BY p.passenger_id
),
cte2 AS (
    SELECT b.bus_id, COUNT(cte.take_time) AS passengers_cnt
    FROM cte
    RIGHT JOIN buses b
    ON cte.take_time = b.arrival_time
    GROUP BY b.bus_id
    ORDER BY b.arrival_time
),
cte3 AS (
    SELECT
        cte2.bus_id,
        b.capacity,
        cte2.passengers_cnt,
        LEAST(b.capacity, cte2.passengers_cnt) AS actual_cnt,
        GREATEST(0, cte2.passengers_cnt - b.capacity) AS remaining_cnt,
        ROW_NUMBER() OVER () AS row_rank
    FROM cte2
    INNER JOIN buses b
    ON cte2.bus_id = b.bus_id
),
recursive_cte AS (
    SELECT
        bus_id,
        capacity,
        passengers_cnt,
        actual_cnt,
        remaining_cnt,
        row_rank
    FROM cte3
    WHERE row_rank = 1

    UNION ALL

    SELECT
        c.bus_id,
        c.capacity,
        c.passengers_cnt,
        LEAST(c.capacity, c.passengers_cnt + r.remaining_cnt) AS actual_cnt,
        GREATEST(0, c.passengers_cnt + r.remaining_cnt - c.capacity) AS remaining_cnt,
        c.row_rank
    FROM cte3 c
    INNER JOIN recursive_cte r
    ON c.row_rank = r.row_rank + 1
)
SELECT
    bus_id,
    actual_cnt AS passengers_cnt
FROM recursive_cte
ORDER BY bus_id;

