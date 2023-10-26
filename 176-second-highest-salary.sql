# Write your MySQL query statement below

WITH cte AS (
    SELECT 
        id, 
        DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM Employee
)

SELECT
    IFNULL(
        (SELECT e.salary 
        FROM Employee e
        LEFT JOIN cte
        ON e.id = cte.id
        WHERE cte.salary_rank = 2
        LIMIT 1), 
        NULL) AS SecondHighestSalary