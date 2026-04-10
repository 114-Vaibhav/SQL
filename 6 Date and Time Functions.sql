USE sqltask;

ALTER TABLE orders ADD COLUMN order_date DATE;

UPDATE orders SET order_date = '2026-01-01' WHERE id =1;
UPDATE orders SET order_date = '2026-03-31' WHERE id =2;
UPDATE orders SET order_date = '2026-03-16' WHERE id =3;
UPDATE orders SET order_date = '2026-04-09' WHERE id =4;
UPDATE orders SET order_date = '2026-03-11' WHERE id =5;

SELECT * FROM orders;

SELECT order_date, DAY(order_date) AS "DAY", MONTH(order_date) AS "MONTH", YEAR(order_date) AS "YEAR" FROM orders;

SELECT * from orders WHERE DATEDIFF(CURDATE(), order_date) < 30;

SELECT *
FROM orders
WHERE order_date BETWEEN '2026-03-01' AND '2026-04-10';

SELECT 
    order_date,
    DATE_ADD(order_date, INTERVAL 7 DAY) AS plus_7_days,
    DATE_SUB(order_date, INTERVAL 7 DAY) AS minus_7_days
FROM orders;

SELECT 
    order_date,
    DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_date
FROM orders;