-- ====================================================================
-- Project: E-Commerce MySQL Analytics
-- ====================================================================

-- 1. MySQL query to calculate the total revenue along with total items sold from the orders table.

SELECT 
  SUM(total_amount) as REVENUE,sum(quantity) as total_items_sold 
FROM orders;

-- 2. Which product generates the most revenue?

SELECT
    p.product_id, p.product_name, SUM(o.total_amount) AS total_revenue
FROM products AS p
INNER JOIN orders AS o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 1;

-- 3. Which category sells the most?

SELECT
	p.category , SUM(o.total_amount) as catagory_wise_sell
FROM products as p
INNER JOIN orders as o ON p.product_id = o.product_id
GROUP BY category
ORDER BY catagory_wise_sell DESC
LIMIT 1;

-- 4. Which customer has spent the most?

SELECT
	c.customer_name , SUM(o.total_amount) as customer_money_spent
FROM customers as c
INNER JOIN orders as o ON c.customer_id = o.customer_id
GROUP BY customer_name
ORDER BY customer_money_spent DESC
LIMIT 1;

-- 5.
