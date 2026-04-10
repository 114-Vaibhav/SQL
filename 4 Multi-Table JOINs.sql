USE sqltask;

CREATE TABLE IF NOT EXISTS products(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    price DECIMAL(10, 2),
    quantity INT
);

CREATE TABLE IF NOT EXISTS customers(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS orders(
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name, price, quantity)
VALUES 
    ('Laptop', 1000.00, 5),
    ('Smartphone', 800.00, 10),
    ('Tablet', 600.00, 8),
    ('Desktop', 1200.00, 3),
    ('Headphones', 50.00, 20);

INSERT INTO customers (name, email, phone)
VALUES 
    ('VAIBHAV', '0FbZ2@example.com', '1234567890'),
    ('SAKSHI', 't9G0V@example.com', '9876543210'),
    ('ASTIK', '8Hc9b@example.com', '5555555555'),
    ('Alice ', 'WlVHt@example.com', '1111111111'),
    ('Bob', 'M2e2B@example.com', '2222222222');

INSERT INTO orders (customer_id, product_id, quantity)
VALUES 
    (1, 1, 2),
    (2, 2, 1),
    (3, 3, 3),
    (4, 4, 1),
    (5, 5, 2);

SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM orders;

SELECT * FROM orders
JOIN products ON orders.product_id = products.id;

SELECT * FROM products 
LEFT JOIN orders ON products.id = orders.product_id;

SELECT * FROM orders
RIGHT JOIN products ON orders.product_id = products.id;

SELECT * FROM orders
JOIN products ON orders.product_id = products.id
JOIN customers ON orders.customer_id = customers.id;
