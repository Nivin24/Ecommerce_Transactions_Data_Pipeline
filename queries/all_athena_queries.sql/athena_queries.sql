-- ==========================================================
-- Athena Queries for E-commerce Transaction Analysis
-- Database: ecommerce_db
-- Table: curated_for_analysiscurated
-- ==========================================================

-- 1. View the latest 10 transactions
SELECT *
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
ORDER BY transaction_id DESC
LIMIT 10;

-- 2. Count the total number of transactions
SELECT COUNT(*) AS total_transactions
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated";

-- 3. Get the distinct product categories
SELECT DISTINCT category
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated";

-- 4. Top 10 highest spending customers
SELECT customer_name,
       ROUND(SUM(total_price),2) AS total_spent
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- 5. Total revenue by payment method
SELECT payment_method,
       ROUND(SUM(total_price),2) AS total_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 6. Monthly sales trends (revenue per month)
SELECT year,
       month,
       ROUND(SUM(total_price),2) AS monthly_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY year, month
ORDER BY year, month;

-- 7. Top 5 best-selling products
SELECT product_name,
       SUM(quantity) AS total_quantity_sold
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- 8. Average transaction amount per customer
SELECT customer_name,
       AVG(total_price) AS avg_transaction_value
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY customer_name
ORDER BY avg_transaction_value DESC
LIMIT 10;

-- 9. Highest revenue-generating categories
SELECT category,
       ROUND(SUM(total_price),2) AS total_category_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY category
ORDER BY total_category_revenue DESC;

-- 10. Transactions summary by year and month
SELECT year,
       month,
       COUNT(transaction_id) AS total_transactions,
       ROUND(SUM(total_price),2) AS total_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY year, month
ORDER BY year, month;