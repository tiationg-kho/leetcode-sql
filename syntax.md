templates and execution order:
```sql
7 5 SELECT col, agrgregate(col)     
1   FROM table1                     
2   JOIN table2 ON table1.col1 = table2.col2    
3   WHERE condition                 
4   GROUP BY col                    
6   HAVING condition                
8   ORDER BY col                    
9   LIMIT count OFFSET offset;
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
-- COUNT does not count null values

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
-- the condition here will be involed the aggregate function
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
-- is executed before the main query and provide results to the outer query
-- simple subquery is independent of the outer query, and it return a single value or a set of values
SELECT 
    s.id, 
    s.salesperson_id, 
    s.amount, 
    total_sales.total_amount
FROM sales s
JOIN 
    (SELECT salesperson_id, SUM(amount) AS total_amount
     FROM sales
     GROUP BY salesperson_id) total_sales
ON s.salesperson_id = total_sales.salesperson_id;

-- correlated subquery
-- has dependencies on outer query
-- the correlated subquery references a column from the outer query 
-- correlated subquery is executed for each row of the main query and depend on values from the outer query
-- eg.
SELECT 
    s.id, 
    s.salesperson_id, 
    s.amount,
    (SELECT SUM(amount)
     FROM sales
     WHERE salesperson_id = s.salesperson_id) AS total_amount
FROM sales s;

-- common table expression (CTE)
-- easily readable
-- imporve performance
WITH TotalSales AS (
    SELECT 
        salesperson_id, 
        SUM(amount) AS total_amount
    FROM sales
    GROUP BY salesperson_id
)
SELECT 
    s.id, 
    s.salesperson_id, 
    s.amount,
    ts.total_amount
FROM sales s
JOIN TotalSales ts 
ON s.salesperson_id = ts.salesperson_id;

-- window function
-- won't change the original count of rows
SELECT 
    id, 
    salesperson_id, 
    amount,
    SUM(amount) OVER (PARTITION BY salesperson_id) AS total_amount
FROM sales;
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
-- if you want to see the difference in salary between each employee and the next when ranked by salary across the entire company (LAG for getting previous row, LEAD for getting next row)
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

-- if
IF(expression, value_to_return_if_expression_is_true, value_to_return_if_expression_is_false)
IFNULL(val, value_to_return_if_val_is_null)

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
BETWEEN AND
IN
LIKE
EXISTS

-- string related
CONCAT(col1_name, col2_name);
SUBSTRING(col_name, idx, len);
TRIM(string);
LTRIM(string);
RTRIM(string);
LENGTH(string);
REPLACE(string, pattern, replacement)
SUBSTRING_INDEX(string, delim, nth)

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
DATE_ADD(date, INTERVAL num unit)
DATE_SUB(date, INTERVAL num unit)
-- the unit can be values like DAY, MONTH, YEAR, HOUR, MINUTE, etc

-- date formatting
DATE_FORMAT(date, pattern)
-- eg. DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') will format the date in the 'YYYY-MM-DD HH:MM:SS' pattern

-- date conversion
STR_TO_DATE(string, pattern)
DATE(string)

-- date diff
DATEDIFF(end_date, start_date)

-- insert data
USE db_name;
INSERT INTO employees (id, name, department, salary) 
VALUES (1, 'John Doe', 'Engineering', 70000);

-- update data
USE db_name;
UPDATE employees 
SET salary = 75000 
WHERE id = 1;

-- delete data (without a join)
USE db_name;
DELETE FROM Person
WHERE some_condition;

-- delete data (with a join)
USE db_name;
DELETE p
FROM Person p
INNER JOIN SomeOtherTable t ON p.some_column = t.some_column
WHERE some_condition;

```

