USE sqltask;
SHOW TABLES;
-- SELECT * FROM Employees ;
-- SELECT * FROM customers ;
-- SELECT * FROM orders ;
-- SELECT * FROM products;

DELIMITER $$
CREATE PROCEDURE get_customer_order_count(
    IN cust_id INT,
    OUT order_count INT
)
BEGIN
    SELECT COUNT(*) INTO order_count
    FROM orders
    WHERE customer_id = cust_id;
END $$
DELIMITER ;

CALL get_customer_order_count(1, @order_count);
SELECT @order_count;


DELIMITER $$

CREATE PROCEDURE get_total_sales_by_date(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT SUM(quantity) AS total_unit_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;
END $$

DELIMITER ;

CALL get_total_sales_by_date('2026-01-01', '2026-03-31');


DELIMITER $$
CREATE FUNCTION get_full_name(
    first_name VARCHAR(50),
    last_name VARCHAR(50)
)
RETURNS VARCHAR(120)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END $$
DELIMITER ;

SELECT id, get_full_name(first_name, last_name) AS full_name
FROM employees;

DELIMITER $$

CREATE FUNCTION calculate_discount(price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    IF price > 1000 THEN
        RETURN price * 0.9;
    ELSE
        RETURN price;
    END IF;
END $$

DELIMITER ;

SELECT id, calculate_discount(price) AS discounted_price
FROM products;

DROP FUNCTION IF EXISTS calculate_discount;
DROP PROCEDURE IF EXISTS get_customer_order_count;
DROP PROCEDURE IF EXISTS get_total_sales_by_date;
DROP FUNCTION IF EXISTS get_full_name;