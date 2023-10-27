CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE res INT;

    WITH cte AS (
        SELECT 
            id, 
            DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
        FROM Employee
    )
    SELECT 
        IFNULL(
            (SELECT e.salary
            FROM Employee e
            LEFT JOIN cte
            ON e.id = cte.id
            WHERE cte.salary_rank = N
            LIMIT 1),
            NULL) INTO res;

    RETURN res;
END