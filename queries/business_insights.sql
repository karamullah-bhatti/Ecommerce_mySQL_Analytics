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

-- 5. Which region generates the highest revenue?

SELECT
	c.region , SUM(o.total_amount) as region_revenue
FROM customers as c
INNER JOIN orders as o ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY region_revenue DESC
LIMIT 1;

-- 6. Average Order Value

SELECT
	AVG(total_amount) as AVG_amount_perOrder FROM orders;

-- 7. Monthly Revenue Trends Analysis

SELECT
	date_format(order_date, '%Y-%m') AS years_month,
	MONTHNAME(order_date) AS month_name, 
	SUM(total_amount) as monthly_revenue from orders
GROUP BY month_name ,years_month
ORDER BY years_month ASC;

-- 8. Find the customers Who Never Placed an Order

SELECT 
	c.customer_name, c.customer_id
FROM customers AS c
LEFT JOIN orders AS o 
	ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;   
--for my dataset , all 15 customers have placed at least one order, so this query should return zero rows.

-- 9. Products That Have Never Been Sold

SELECT 
	p.product_id, p.product_name
FROM products AS p
LEFT JOIN orders AS o 
	ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- 10. 
