# Write your MySQL query statement below

SELECT Email
FROM Person
GROUP BY email
HAVING count(DISTINCT id) > 1;