USE sqltask;

SELECT "WHERE salary > 7000 ORDER BY salary DESC";

SELECT * FROM employees
WHERE salary > 7000
ORDER BY salary DESC;

SELECT "WHERE salary > 7000 ORDER BY salary DESC LIMIT 2";

SELECT * FROM employees
WHERE salary > 7000
ORDER BY salary DESC
LIMIT 2;

SELECT "WHERE salary > 7000 AND salary < 9000 ORDER BY salary DESC";
SELECT * FROM employees
WHERE salary > 7000 AND salary < 9000
ORDER BY salary DESC;

SELECT "employees WHERE salary = 7000 OR salary = 9000 ORDER BY salary DESC";

SELECT * FROM employees
WHERE salary = 7000 OR salary = 9000
ORDER BY salary DESC;