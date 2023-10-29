# Write your MySQL query statement below

WITH cte AS (
  SELECT 
    d.name AS Department, 
    e.name AS Employee, 
    e.salary AS Salary, 
    DENSE_RANK() OVER(PARTITION BY e.departmentId ORDER BY e.salary DESC) AS salary_rank
  FROM Employee e
  INNER JOIN Department d
  ON e.departmentId = d.id

)
SELECT Department, Employee, Salary
FROM cte
WHERE salary_rank <= 3;