USE sqltask;
SHOW TABLES;
-- SELECT * FROM Employees ;
-- SELECT * FROM customers ;
-- SELECT * FROM orders ;
-- SELECT * FROM products;

WITH AvgSalaryByDept AS (
    SELECT department_id, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY department_id
)
SELECT *
FROM AvgSalaryByDept;



WITH RECURSIVE dept_cte AS (
    SELECT 
        department_id,
        id,
        first_name,
        salary
    FROM employees
    WHERE department_id = 1

    UNION

    SELECT 
        e.department_id,
        e.id,
        e.first_name,
        e.salary
    FROM employees e
    INNER JOIN dept_cte d 
        ON e.department_id = d.department_id + 1
)
SELECT * FROM dept_cte;