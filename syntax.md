templates and execution order:
```sql
7 5 SELECT col, agrgregate(col)     
1   FROM table1                     
2   JOIN table2 ON table1.col1 = table2.col2    
3   WHERE condition                 
4   GROUP BY col                    
6   HAVING condition                
8   ORDER BY col                    
9   LIMIT count                     
```

```sql
-- basic statement to retrieve data from tables
SELECT col_name
FROM table_name;

-- removing duplicate rows
SELECT DISTINCT col_name
FROM table_name;

-- filtering rows based on conditions
SELECT col_name
FROM table_name
WHERE condition; 
-- for condition we can use AND, OR, () to present complicated conditions

SELECT col_name
FROM table_name
WHERE col_name IN (val_list);
-- we can also NOT IN, EXISTS, NOT EXISTS

SELECT col_name
FROM table_name
WHERE col_name BETWEEN lower_bound AND upper_bound;

SELECT col_name
FROM table_name
WHERE col_name LIKE 'pattern_with_wildcards';
-- wildcard in SQL
-- _ means exactly 1 char
-- % means 0, 1, or multiple chars

-- sorting results
SELECT *
FROM table_name
WHERE condition
ORDER BY col_name ASC;
-- WHERE clause is optional here
-- we can use ASC, DESC
-- we can ORDER BY multiple conditions

SELECT AVG(col_name)
FROM table_name
-- we can use AVG, MIN, MAX, SUM, COUNT

SELECT COUNT(DISTINCT col_name)
FROM table_name;

-- grouping rows that have the same values in specified columns
SELECT col1_name, SUM(col2_name) AS total_col2_name
FROM table_name
GROUP BY col1_name;
-- GROUP BY is used with aggregate functions to perform calculations on the grouped data

-- filtering group results
SELECT col1_name, SUM(col2_name)
FROM table_name
GROUP BY col1_name
HAVING condition;
-- the condition here will be involen the aggregate function
-- eg. HAVING SUM(revenue) > 1500

-- combining rows from two or more tables based on related columns
SELECT *
FROM table1_name
INNER JOIN table2_name
ON table1_name1.col_name = table2_name.col_name;

SELECT *
FROM table1_name
LEFT JOIN table2_name
ON table1_name1.col_name = table2_name.col_name;

SELECT *
FROM table1_name
RIGHT JOIN table2_name
ON table1_name1.col_name = table2_name.col_name;

SELECT table1_name.col_name, table2_name.col_name
FROM table1_name
CROSS JOIN table2_name;
-- we do not neeed join condition here

CONCAT(col1_name, col2_name);
SUBSTRING(col_name, idx, len);
TRIM(string);
LTRIM(string);
RTRIM(string);
LENGTH(string);
REPLACE(string, pattern, replacement)

SELECT col_name FROM table1_name
UNION
SELECT col_name FROM table2_name;
-- res are unique

SELECT col_name FROM table1_name
UNION ALL
SELECT col_name FROM table2_name;
-- res might have duplicates

SELECT col_name FROM table1_name
INTERSECT
SELECT col_name FROM table2_name;
-- res are unique

SELECT col_name FROM table1_name
MINUS
SELECT col_name FROM table2_name;
-- res are unique

-- subquery can use in WHERE, FROM / JOIN, SELECT clauses

-- simple subquery
-- can run on its own
-- is used to retrieve data required for the main query's condition or result
-- is executed before the main query and provide results to the outer query
-- simple subquery is independent of the outer query, and it return a single value or a set of values
SELECT EmployeeName
FROM Employees
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Sales');

-- correlated subquery
-- has dependencies on outer query
-- the correlated subquery references a column from the outer query 
-- is executed for each row processed by the main query
-- correlated subquery is executed for each row of the main query and depend on values from the outer query
-- eg.
SELECT EmployeeName, Salary
FROM Employees e1
WHERE Salary > (SELECT AVG(Salary) FROM Employees e2 WHERE e2.DepartmentID = e1.DepartmentID);
-- eg.
SELECT *
FROM Departments d
WHERE NOT EXISTS (SELECT 1 FROM Employees e WHERE e.DepartmentID = d.DepartmentID);

-- common table expression (CTE)
-- easily readable
-- imporve performance
WITH CTE AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM
        employees
    GROUP BY
        department_id
)
SELECT
    d.department_name,
    CTE.avg_salary
FROM
    departments AS d
INNER JOIN
    CTE ON d.department_id = CTE.department_id;

-- window function
-- won't change the original count of rows
SELECT product_id, SUM(val) OVER (PARTITION BY product_id ORDER BY order_id) AS sum
FROM products;
-- there are also ROW_NUMBER(), RANK(), DENSE_RANK(), LEAD(), LAG(), FIRST_VALUE(), NTH_VALUE(), NTILE() to use
-- PARTITION BY:
-- Purpose: PARTITION BY allows you to split the result set into smaller groups (or "windows") and apply the window function independently to each group. It's used when you want to compute statistics, such as the average salary for each department, within each group
-- Necessity: Whether or not you need this clause depends on the requirement of the query. If you want to apply a uniform window calculation across the entire result set, you don't need it. If you need to perform calculations group-wise, then you must use it
-- ORDER BY:
-- Purpose: ORDER BY determines the order of data within the window. Many window functions, such as ROW_NUMBER(), LEAD(), LAG(), etc., rely on the ordering of the data
-- Necessity: For window functions that consider the order of data (like LEAD(), LAG(), ROW_NUMBER(), and others), ORDER BY is essential. But if you're just computing a grouped sum or average without regard to ordering, you can omit it
-- if you want to compute the average salary for each department
SELECT department, AVG(salary) OVER (PARTITION BY department)
FROM employees;
-- if you want to compute the overall average salary for all employees
SELECT department, AVG(salary) OVER ()
FROM employees;
-- if you want to rank employees within each department by salary
SELECT department, salary, ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)
FROM employees;
-- if you want to see the difference in salary between each employee and the next when ranked by salary across the entire company
SELECT employee_name, salary, LAG(salary) OVER (ORDER BY salary DESC) - salary
FROM employees;

-- if else statement (conditional logic)
SELECT 
    name, 
    status,
    CASE status
        WHEN 'active' THEN 'Currently in use'
        WHEN 'inactive' THEN 'No longer in use'
        WHEN 'pending' THEN 'Awaiting approval'
        WHEN 'obsolete' THEN 'Outdated and not used'
        ELSE 'Unknown status'
    END AS status_description
FROM products;

SELECT 
    name, 
    grade,
    CASE 
        WHEN grade >= 90 THEN 'A'
        WHEN grade >= 80 AND grade < 90 THEN 'B'
        WHEN grade >= 70 AND grade < 80 THEN 'C'
        WHEN grade >= 60 AND grade < 70 THEN 'D'
        ELSE 'F'
    END AS grade_letter
FROM students;

-- if null
IFNULL(expression, value_to_return_if_expression_is_NULL)

-- operators
=
!=
<
<=
>
>=
+
-
*
/
%
AND
OR
NOT
IS NULL
BETWEEN
IN
LIKE
EXISTS

-- time related
-- current date and time
NOW()
CURDATE()
CURTIME()

-- date extraction
YEAR(date)
MONTH(date)
DAY(date)

-- date manipulation
DATE_ADD(date, INTERVAL NUM UNIT)
DATE_SUB(date, INTERVAL NUM UNIT)
-- the unit can be values like DAY, MONTH, YEAR, HOUR, MINUTE, etc

-- date formatting
DATE_FORMAT(date, PATTERN)
-- eg. DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') will format the date in the 'YYYY-MM-DD HH:MM:SS' pattern

-- date conversion
STR_TO_DATE(STRING, PATTERN)
DATE(STRING)

-- date diff
DATEDIFF(end_date, start_date)

-- deleting without a join
DELETE FROM Person
WHERE some_condition;

-- deleting with a join
DELETE p
FROM Person p
INNER JOIN SomeOtherTable t ON p.some_column = t.some_column
WHERE some_condition;

```

