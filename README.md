# SQL Practice Project

This repository contains a set of SQL tasks that move from core database basics to more advanced database design and optimization features. The scripts are written primarily for MySQL-style syntax and each task has a matching output file inside the `Output/` folder.

## Tasks 1-9 Overview

### 1. Creating and Populating Tables
Creates the `sqltask` database, defines an `employees` table, and inserts sample employee records for later exercises.

### 2. Basic Filtering and Sorting
Demonstrates `WHERE`, `ORDER BY`, `LIMIT`, and logical conditions to filter employee data by salary ranges.

### 3. Simple Aggregation and Grouping
Uses `COUNT()`, `AVG()`, `SUM()`, `GROUP BY`, and `HAVING` to summarize employee information by department.

### 4. Multi-Table JOINs
Builds `products`, `customers`, and `orders` tables, inserts sample data, and practices `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN`.

### 5. Subqueries and Nested Queries
Uses scalar and correlated subqueries to compare employee salaries against overall and department-level averages.

### 6. Date and Time Functions
Adds `order_date` to the `orders` table and demonstrates `DAY()`, `MONTH()`, `YEAR()`, `DATEDIFF()`, `BETWEEN`, `DATE_ADD()`, `DATE_SUB()`, and `DATE_FORMAT()`.

### 7. Window Functions and Ranking
Explores `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `PERCENT_RANK()`, `LEAD()`, and `LAG()` partitioned by department.

### 8. CTE and Recursive Query
Introduces a standard CTE for department average salary and a recursive CTE example using department progression logic.

### 9. Stored Procedures and User-Defined Functions
Creates procedures for counting customer orders and summarizing sales by date range, plus functions for full name formatting and product discount calculation.

## Task 10 Detailed Documentation

File: `10 Comprehensive Database Design, Optimization, and Advanced Features.sql`

Task 10 is a mini e-commerce database project that combines schema design, indexing, triggers, a view, transactional inserts, and validation queries in one script.

### Objective

The goal is to simulate a realistic order-processing system where:

- customers place orders
- products maintain current stock
- order items reduce inventory automatically
- payments are recorded separately
- log entries capture stock-related changes
- indexes improve lookup and join performance
- a view exposes summarized business data

### Database Setup

The script creates and uses a dedicated database:

```sql
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;
```

Before rebuilding the schema, it drops core transactional tables in dependency order so the script can be rerun safely during practice.

### Schema Design

The database includes six main objects:

#### 1. `Customers`
Stores customer identity and contact details.

- `customer_id`: primary key
- `name`: customer name
- `email`: unique email
- `phone`: unique phone number
- `created_at`: automatic timestamp

#### 2. `Products`
Stores product catalog and inventory.

- `product_id`: primary key
- `name`: product name
- `price`: product price
- `stock`: available inventory
- `created_at`: automatic timestamp

#### 3. `Orders`
Represents one order placed by one customer.

- `order_id`: primary key
- `customer_id`: foreign key to `Customers`
- `order_date`: automatic timestamp
- `status`: order state, default `'Pending'`

#### 4. `OrderDetails`
Stores line items for each order.

- `order_detail_id`: primary key
- `order_id`: foreign key to `Orders`
- `product_id`: foreign key to `Products`
- `quantity`: units purchased
- `price`: item price captured at purchase time

#### 5. `Payments`
Tracks payment details separately from the order record.

- `payment_id`: primary key
- `order_id`: foreign key to `Orders`
- `amount`: amount paid
- `payment_status`: payment result such as `Success`
- `payment_date`: automatic timestamp

#### 6. `Logs`
Captures trigger-generated log messages for auditing simple stock activity.

- `log_id`: primary key
- `message`: log text
- `created_at`: automatic timestamp

### Relationships

The schema models the following relationships:

- one customer can have many orders
- one order can have many order detail rows
- one product can appear in many order detail rows
- one order can have related payment information

This structure follows a normalized design by separating master data (`Customers`, `Products`) from transactional data (`Orders`, `OrderDetails`, `Payments`).

### Index Optimization

The script adds indexes to improve common search and join operations:

- `idx_customer_email` on `Customers(email)`
- `idx_product_name` on `Products(name)`
- `idx_order_customer` on `Orders(customer_id)`
- `idx_orderdetails_order` on `OrderDetails(order_id)`
- `idx_orderdetails_product` on `OrderDetails(product_id)`

These indexes help in:

- searching customers by email
- searching products by name
- joining orders to customers
- joining order details to orders and products

The script later uses `EXPLAIN` statements to inspect these access paths.

### Trigger Logic

Two triggers automate inventory control.

#### `before_order_insert`

This is a `BEFORE INSERT` trigger on `OrderDetails`.

Purpose:
- checks available stock before a new order item is inserted
- prevents invalid sales when requested quantity exceeds stock

Behavior:
- fetches current stock from `Products`
- compares stock with `NEW.quantity`
- raises an error with SQLSTATE `45000` and message `Not enough stock!` if stock is insufficient

#### `after_order_insert`

This is an `AFTER INSERT` trigger on `OrderDetails`.

Purpose:
- updates inventory automatically after a valid order item is added
- records the stock update in the `Logs` table

Behavior:
- subtracts ordered quantity from the product stock
- inserts a simple audit log message

Together, these triggers enforce a basic stock-control workflow directly inside the database.

### Seed Data

The script inserts sample records into:

- `Customers`
- `Products`

`INSERT IGNORE` is used so repeated runs do not fail because of duplicate primary keys or unique values.

### View

The script creates a view named `OrderSummary`:

```sql
CREATE OR REPLACE VIEW OrderSummary AS
SELECT 
    o.order_id,
    c.name AS customer_name,
    SUM(od.quantity * od.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY o.order_id;
```

Purpose:

- provides a compact order report
- shows customer name with total order amount
- hides repeated join and aggregation logic from future queries

### Transaction Flow

The script demonstrates a complete transactional order process:

1. start a transaction
2. insert a new row into `Orders`
3. capture the generated `order_id` with `LAST_INSERT_ID()`
4. insert two line items into `OrderDetails`
5. insert a payment row into `Payments`
6. commit the transaction

This section shows how multiple related operations can be treated as one unit of work.

### Testing and Validation

The script validates the system by querying:

- `Customers`
- `Products`
- `Orders`
- `OrderDetails`
- `Payments`
- `Logs`
- `OrderSummary`

It also includes:

- `EXPLAIN` for indexed email search
- `EXPLAIN` for indexed product-name search
- `EXPLAIN` for join performance between `Orders` and `Customers`
- a failure test that tries to insert an unrealistic quantity and should trigger the stock validation error

### Key Concepts Demonstrated

Task 10 brings together several important SQL concepts in one place:

- database creation and reset workflow
- table design with primary and foreign keys
- normalized transactional schema
- indexing for performance
- triggers for business-rule enforcement
- views for reusable reporting
- transactions for safe multi-step operations
- validation using direct queries and `EXPLAIN`

### How to Run

Run the SQL files in order if you want to build understanding progressively:

1. `1 Creating and Populating Tables.sql`
2. `2 Basic Filtering and Sorting.sql`
3. `3 Simple Aggregation and Grouping.sql`
4. `4 Multi-Table JOINs.sql`
5. `5 Subqueries and Nested Queries.SQL`
6. `6 Date and Time Functions.sql`
7. `7 Window Functions and Ranking.sql`
8. `8 CTE_Recursive.sql`
9. `9 Stored Procedures and User-Defined Functions.sql`
10. `10 Comprehensive Database Design, Optimization, and Advanced Features.sql`

You can also review the sample outputs in the `Output/` directory after executing the scripts.

### Notes

- The scripts use MySQL-style features such as `AUTO_INCREMENT`, `DELIMITER`, triggers, procedures, and functions.
- Task dependencies exist across earlier files because several scripts reuse the `sqltask` database and tables created in earlier tasks.
- Task 10 is self-contained because it creates its own `ecommerce_db` database and rebuilds its schema from scratch.
