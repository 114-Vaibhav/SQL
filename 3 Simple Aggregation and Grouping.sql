USE sqltask;

SELECT COUNT(id) AS "NUMBER OF EMPLOYEES" FROM employees;

SELECT department_id,AVG(salary) AS "AVG SALARY" FROM employees GROUP BY department_id;

SELECT department_id,COUNT(id) AS "NUMBER OF EMPLOYEES" FROM employees GROUP BY department_id;

SELECT department_id,AVG(salary) AS "AVG SALARY" FROM employees GROUP BY department_id HAVING AVG(salary) > 7000;

SELECT department_id,COUNT(id) AS "NUMBER OF EMPLOYEES" FROM employees GROUP BY department_id HAVING COUNT(id) > 1;

SELECT department_id, SUM(salary) AS "TOTAL SALARY" FROM employees GROUP BY department_id;