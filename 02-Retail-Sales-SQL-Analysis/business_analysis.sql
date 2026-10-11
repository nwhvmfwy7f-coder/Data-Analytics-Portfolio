/*
Retail Sales SQL Analysis
Database: retail_analytics
Tools: PostgreSQL and DBeaver
Dataset: simulated retail sales transactions (2024-2025)
Run each statement separately in DBeaver or execute the entire script.
*/

-- Question 1: How many total orders were placed?
SELECT COUNT(*) AS total_orders
FROM orders;

-- Question 2: How many unique customers placed an order?
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;

-- Question 3: What is the company's total revenue?
SELECT SUM(p.price * oi.quantity) AS total_revenue
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id;

-- Question 4: What is the average revenue per order?
WITH order_totals AS (
    SELECT oi.order_id,
           SUM(p.price * oi.quantity) AS order_total
    FROM order_items AS oi
    JOIN products AS p ON oi.product_id = p.product_id
    GROUP BY oi.order_id
)
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM order_totals;

-- Question 5: Which 10 products generated the most revenue?
SELECT p.product_id,
       p.product_name,
       SUM(p.price * oi.quantity) AS total_revenue
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Question 6: Which product category generated the most revenue?
SELECT p.category,
       SUM(p.price * oi.quantity) AS total_revenue
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Question 7: Which state generated the most revenue?
SELECT c.state,
       SUM(p.price * oi.quantity) AS total_revenue
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY c.state
ORDER BY total_revenue DESC;

-- Question 8: Who are the top 10 customers by total spending?
SELECT c.customer_id,
       c.customer_name,
       SUM(p.price * oi.quantity) AS total_spent
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Question 9: How much revenue was generated each month?
SELECT DATE_TRUNC('month', o.order_date)::date AS sales_month,
       SUM(p.price * oi.quantity) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month ASC;

-- Question 10: Which month generated the highest revenue?
SELECT DATE_TRUNC('month', o.order_date)::date AS sales_month,
       SUM(p.price * oi.quantity) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY monthly_revenue DESC
LIMIT 1;

-- Question 11: Which products generated the most profit?
-- Profit here is revenue minus product costs, not full accounting net profit.
SELECT p.product_id,
       p.product_name,
       SUM((p.price - p.cost) * oi.quantity) AS total_profit
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit DESC;

-- Question 12: Which product category has the highest profit margin?
SELECT p.category,
       SUM(p.price * oi.quantity) AS total_revenue,
       SUM((p.price - p.cost) * oi.quantity) AS total_profit,
       ROUND(
           100.0 * SUM((p.price - p.cost) * oi.quantity)
           / NULLIF(SUM(p.price * oi.quantity), 0),
           2
       ) AS profit_margin_pct
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY profit_margin_pct DESC;
