CREATE TABLE superstore_raw (
    row_id INT,
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales NUMERIC,
    quantity INT,
    discount NUMERIC,
    profit NUMERIC
);

SELECT * from superstore_raw;

COPY superstore_raw
FROM '"C:/Users/user/Desktop/Celebal Internship/cei-data-engineering-portfolioWEEK-3\Sample_Superstore.csv"'
DELIMITER ','
CSV HEADER
QUOTE '"';

SELECT DISTINCT * FROM superstore_raw;

SELECT COUNT(*) FROM superstore_raw;
SELECT COUNT(*) FROM (
    SELECT DISTINCT * FROM superstore_raw
) t;

CREATE TABLE superstore_clean AS SELECT DISTINCT * FROM superstore_raw;
SELECT COUNT(*) FROM superstore_clean;

CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_name, segment
FROM superstore_raw;

CREATE TABLE orders AS
SELECT DISTINCT order_id, order_date, ship_date, ship_mode, customer_id, sales
FROM superstore_raw;

CREATE TABLE products AS
SELECT DISTINCT product_id, product_name, category, sub_category
FROM superstore_raw;


/* Q1 Sales > Average */ 
SELECT *
FROM orders
WHERE sales > (SELECT AVG(sales) FROM orders);

/* Q2 Highest Order per Customer */
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

/* Q4 Above Average Customers */
WITH customer_sales AS (
    SELECT customer_id, SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales);

/* Q5 Rank Customers (Window) */
WITH customer_sales AS (
    SELECT customer_id, SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *,
RANK() OVER (ORDER BY total_sales DESC) AS rank
FROM customer_sales;

/* Q6 Row Number per Customer */
SELECT *,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sales DESC) AS row_num
FROM orders;

/* Q7 Top 3 Customers */
WITH customer_sales AS (
    SELECT customer_id, SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM (
    SELECT *,
    RANK() OVER (ORDER BY total_sales DESC) AS rank
    FROM customer_sales
) t
WHERE rank <= 3;

/* COMBINED QUERY */
WITH customer_sales AS (
    SELECT customer_id, SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT c.customer_name,
       cs.total_sales,
       RANK() OVER (ORDER BY cs.total_sales DESC) AS rank
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id;

/* MINI PROJECT ANSWERS */

/* Q1 Top 5 Customers */ 
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

/* Q2 Bottom 5 Customers */
SELECT customer_id, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
ORDER BY total_sales ASC
LIMIT 5;

/* Q3 Single Order Customers */
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) = 1;

/* Q4 Highest Order per Customer */
SELECT customer_id, MAX(sales)
FROM orders
GROUP BY customer_id;


