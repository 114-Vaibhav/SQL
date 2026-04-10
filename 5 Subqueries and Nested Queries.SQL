USE sqltask;

SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = 1);

SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

SELECT 
    first_name,
    salary,
    department_id,
    (SELECT AVG(salary)
     FROM employees e2
     WHERE e2.department_id = e1.department_id) AS dept_avg_salary
FROM employees e1;