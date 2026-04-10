CREATE DATABASE IF NOT EXISTS sqltask;

USE sqltask;

CREATE TABLE IF NOT EXISTS employees(
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    department_id INT(6)
);

INSERT INTO employees (first_name, last_name, email, salary, department_id)
VALUES
    ('VAIBHAV', 'GUPTA', 'VG@example.com', 5000.00, 1),
    ('SAKSHI', 'KATIYAR', 'SK@example.com', 6000.00, 1),
    ('AKSHAY', 'GUPTA', '2Fj5o@example.com', 7000.00, 2),
    ('KUSHAL', 'GUPTA', 'kUSHAL@GUPTA.COM', 8000.00, 2),
    ('VISHAL', 'MITTAL', 'VISHAL@GUPTA.COM', 9000.00, 3);

SELECT * FROM employees;