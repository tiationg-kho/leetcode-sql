# Write your MySQL query statement below

WITH cte AS (
  SELECT id, email, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS row_num
  FROM Person
)
DELETE p 
FROM Person p
INNER JOIN cte
ON p.id = cte.id
WHERE row_num > 1;