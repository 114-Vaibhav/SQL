USE sqltask;

-- INSERT INTO employees (first_name, last_name, email, salary, department_id) VALUES
--     ('AMAN', 'KUMAR', '345@GFA.COM', 6000.00, 1);
-- INSERT INTO employees (first_name, last_name, email, salary, department_id) VALUES
--     ('ALLU', 'K', '444@GFA.COM', 8000.00, 2);
-- INSERT INTO employees (first_name, last_name, email, salary, department_id) VALUES
--     ('ARJUN', 'KUMAR', 'V44@GFA.COM', 6000.00, 3);

SELECT 
    id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS department_rank
FROM employees;

SELECT 
    id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS department_DENSE_rank
FROM employees;

SELECT 
    id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS department_ROW_NUMBER
FROM employees;

SELECT 
    id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    PERCENT_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS department_PERCENT_rank
FROM employees;

SELECT 
    id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    LEAD(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) AS next_salary
FROM employees;

SELECT 
    id,
    first_name,
    last_name,
    email,
    salary,
    department_id,
    LAG(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) AS previous_salary
FROM employees;