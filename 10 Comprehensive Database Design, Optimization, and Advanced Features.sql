
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

SELECT "Database Ready";

DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE IF NOT EXISTS OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(50),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE IF NOT EXISTS Logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT "Tables Created" ;


-- INDEXES


CREATE INDEX idx_customer_email ON Customers(email);
CREATE INDEX  idx_product_name ON Products(name);
CREATE INDEX  idx_order_customer ON Orders(customer_id);
CREATE INDEX  idx_orderdetails_order ON OrderDetails(order_id);
CREATE INDEX  idx_orderdetails_product ON OrderDetails(product_id);

SELECT "Indexes Added";

-- TRIGGERS


DROP TRIGGER IF EXISTS before_order_insert;
DELIMITER $$

CREATE TRIGGER before_order_insert
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    SELECT stock INTO available_stock
    FROM Products
    WHERE product_id = NEW.product_id;

    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock!';
    END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS after_order_insert;
DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    INSERT INTO Logs(message)
    VALUES (CONCAT('Stock updated for product ', NEW.product_id));
END$$

DELIMITER ;

SELECT "Triggers Created";




INSERT IGNORE INTO Customers(customer_id, name, email, phone) VALUES
(1, 'Vaibhav', 'vaibhav@gmail.com', '9999999999'),
(2, 'Amit', 'amit@gmail.com', '8888888888'),
(3, 'Riya', 'riya@gmail.com', '7777777777');

INSERT IGNORE INTO Products(product_id, name, price, stock) VALUES
(1, 'Laptop', 50000, 10),
(2, 'Mouse', 500, 50),
(3, 'Keyboard', 1500, 30),
(4, 'Monitor', 12000, 20);


-- VIEW

CREATE OR REPLACE VIEW OrderSummary AS
SELECT 
    o.order_id,
    c.name AS customer_name,
    SUM(od.quantity * od.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY o.order_id;

SELECT "View Created";


-- TRANSACTION TEST


SELECT "Transaction Started";

START TRANSACTION;

INSERT INTO Orders(customer_id) VALUES (1);
SET @order_id = LAST_INSERT_ID();

INSERT INTO OrderDetails(order_id, product_id, quantity, price)
VALUES (@order_id, 1, 1, 50000);

INSERT INTO OrderDetails(order_id, product_id, quantity, price)
VALUES (@order_id, 2, 2, 500);

INSERT INTO Payments(order_id, amount, payment_status)
VALUES (@order_id, 51000, 'Success');

COMMIT;

SELECT "Transaction Completed";


-- TESTING SECTION


SELECT "Customers Table";
SELECT * FROM Customers;


SELECT "Products Table (Check Stock Update)";
SELECT * FROM Products;


SELECT "Orders Table";
SELECT * FROM Orders;


SELECT "OrderDetails Table";
SELECT * FROM OrderDetails;


SELECT "Payments Table" ;
SELECT * FROM Payments;


SELECT "Logs Table (Trigger Output)";
SELECT * FROM Logs;


SELECT "Order Summary View";
SELECT * FROM OrderSummary;


SELECT "Index Test - Email Search";
EXPLAIN SELECT * FROM Customers WHERE email = 'vaibhav@gmail.com';

SELECT "Index Test - Product Name";
EXPLAIN SELECT * FROM Products WHERE name = 'Laptop';

SELECT "Index Test - Join Performance";
EXPLAIN 
SELECT o.order_id, c.name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;


SELECT "Trigger Test - Should Fail (High Quantity)";

INSERT INTO OrderDetails(order_id, product_id, quantity, price)
VALUES (1, 1, 1000, 50000);
