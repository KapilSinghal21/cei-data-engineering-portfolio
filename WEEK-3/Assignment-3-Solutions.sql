-- Assignment 3
-- Objective : Data loading -> Cleaning -> Validation -> Analysis

-- --------------------------------
/* STEP 1 : SETUP DATA */
-- --------------------------------

-- Step 1.1 : CREATE RAW TABLE
CREATE TABLE SUPERSTORE_RAW (
	ROW_ID INT,
	ORDER_ID TEXT,
	ORDER_DATE DATE,
	SHIP_DATE DATE,
	SHIP_MODE TEXT,
	CUSTOMER_ID TEXT,
	CUSTOMER_NAME TEXT,
	SEGMENT TEXT,
	COUNTRY TEXT,
	CITY TEXT,
	STATE TEXT,
	POSTAL_CODE TEXT,
	REGION TEXT,
	PRODUCT_ID TEXT,
	CATEGORY TEXT,
	SUB_CATEGORY TEXT,
	PRODUCT_NAME TEXT,
	SALES NUMERIC,
	QUANTITY INT,
	DISCOUNT NUMERIC,
	PROFIT NUMERIC
);

-- Step 1.2 : LOAD DATA (RAW INGESTION)
COPY SUPERSTORE_RAW
FROM
	'"C:/Users/user/Desktop/Celebal Internship/cei-data-engineering-portfolioWEEK-3\Sample_Superstore.csv"' DELIMITER ',' CSV HEADER QUOTE '"';

-- Step 1.3 : DATA VALIDATION

-- total records

SELECT COUNT(*) AS total_rows FROM superstore_raw;

-- Check for duplicates

SELECT COUNT(*) AS total_rows FROM superstore_raw;

SELECT COUNT(*) AS distinct_rows
FROM (SELECT DISTINCT * FROM superstore_raw) t;

-- Create clean table (remove duplicates)

CREATE TABLE SUPERSTORE_CLEAN AS
SELECT DISTINCT *
FROM SUPERSTORE_RAW;

-- Post Clean Validation
SELECT COUNT(*) AS clean_count FROM superstore_clean;

-- INSIGHTS :
-- if raw_count = distinct_count -> dataset has no duplicates
-- This Confirms dataset integrity

-- Step 1.4 : Creating 3 tables from superstore_raw table

-- Customer Table
CREATE TABLE CUSTOMERS AS
SELECT DISTINCT
	CUSTOMER_ID,
	CUSTOMER_NAME,
	SEGMENT
FROM
	SUPERSTORE_RAW;

-- Order Table
CREATE TABLE ORDERS AS
SELECT DISTINCT
	ORDER_ID,
	ORDER_DATE,
	SHIP_DATE,
	SHIP_MODE,
	CUSTOMER_ID,
	SALES
FROM
	SUPERSTORE_RAW;

-- Products Table
CREATE TABLE PRODUCTS AS
SELECT DISTINCT
	PRODUCT_ID,
	PRODUCT_NAME,
	CATEGORY,
	SUB_CATEGORY
FROM
	SUPERSTORE_RAW;
	
-- ---------------------------------------
/* STEP 2 : Performing Required Queries */ 
-- ---------------------------------------

/* Q1 Order where Sales > Average (Subquery) */

SELECT *
FROM orders
WHERE sales > (SELECT AVG(sales) FROM orders);

/* Q2 Highest Sales Order per Customer (Subquery) */

SELECT *
FROM orders o
WHERE sales = (
SELECT MAX(sales)
FROM orders
WHERE customer_id = o.customer_id
);

/* Q3 Total Sales per Customer (CTE) */

WITH customer_sales AS (
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
)
SELECT * FROM customer_sales;

/* Q4 Customers with Above Average Sales (CTE + Subquery) */

WITH customer_sales AS (
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales);

/* Q5 Rank Customers by total sales (Window Function) */

WITH customer_sales AS (
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
)
SELECT
customer_id,
total_sales,
RANK() OVER (ORDER BY total_sales DESC) AS rank
FROM customer_sales;

/* Q6 Row Number per order within Customer (Window Function + PARTITION BY) */

SELECT order_id, customer_id, sales,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sales DESC) AS row_num
FROM orders;

/* Q7 Top 3 Customers (Window Function) */

WITH customer_sales AS (
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
)
SELECT *
FROM (
SELECT
customer_id,
total_sales,
RANK() OVER (ORDER BY total_sales DESC) AS rank
FROM customer_sales
) t
WHERE rank <= 3;

-- -------------------------------------
/* STEP 3 : FINAL COMBINED QUERY */
-- -------------------------------------
WITH customer_sales AS (
SELECT
c.customer_name,
SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
)
SELECT
customer_name,
total_sales,
RANK() OVER (ORDER BY total_sales DESC) AS rank
FROM customer_sales;

-- -----------------------------
/* MINI PROJECT QUERIES */ 
-- -----------------------------
/* Q1 Top 5 Customers */

SELECT *
FROM (
SELECT
customer_id,
SUM(sales) AS total_sales,
RANK() OVER (ORDER BY SUM(sales) DESC) AS rank
FROM orders
GROUP BY customer_id
) t
WHERE rank <= 5;

/* Q2 Bottom 5 Customers */

SELECT *
FROM (
SELECT
customer_id,
SUM(sales) AS total_sales,
RANK() OVER (ORDER BY SUM(sales) ASC) AS rank
FROM orders
GROUP BY customer_id
) t
WHERE rank <= 5;

/* Q3 Customer with only one order */

SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) = 1;

/* Q4 Customer with above average sales */

WITH customer_sales AS (
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales);

/* Q5 Highest Order value per customer */ 

SELECT
customer_id,
MAX(sales) AS highest_order
FROM orders
GROUP BY customer_id;


-- /* INSIGHTS */ 
-- Total Sales by Category
SELECT category, SUM(sales) AS total_sales
FROM superstore_raw
GROUP BY category
ORDER BY total_sales DESC;

-- Profit by Region 
SELECT region, SUM(profit) AS total_profit
FROM superstore_raw
GROUP BY region
ORDER BY total_profit DESC;

-- Discount Impact
SELECT discount, AVG(profit) AS avg_profit
FROM superstore_raw
GROUP BY discount
ORDER BY discount;

-- Top 5 Customers
SELECT customer_name, SUM(sales) AS total_spent
FROM superstore_raw
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Montly Sales Trend
SELECT DATE_TRUNC('month', order_date) AS month,
       SUM(sales) AS monthly_sales
FROM superstore_raw
GROUP BY month
ORDER BY month;

-- By kapil Singhal 