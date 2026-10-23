/*
Challenge 1: 3-Order Moving Average

Calculates the moving average of order spending for each order,
considering the current order and the two immediately preceding orders
in chronological order. Uses a window function with a ROWS frame
to analyze short-term changes in order spending.
*/

SELECT 
    order_id, 
    order_date, 
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date ASC 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM orders;

-- Challenge 2: Category Revenue Share Analysis
-- Uses a CTE to calculate category-wise revenue and a window function
-- to determine each category's percentage contribution to total revenue.

WITH category_totals AS (
    SELECT
        p.category,
        SUM(o.total_amount) AS category_revenue
    FROM products AS p
    INNER JOIN orders AS o
        ON p.product_id = o.product_id
    GROUP BY p.category
)
SELECT
    category,
    category_revenue,
    SUM(category_revenue) OVER () AS total_revenue,
    ROUND(
        category_revenue / SUM(category_revenue) OVER () * 100,
        2
    ) AS revenue_percentage
FROM category_totals
ORDER BY revenue_percentage DESC;


-- Challenge 3: Customer Purchase Gaps
-- Uses a CTE and LEAD() to identify each customer's next purchase
-- and calculates the number of days between consecutive orders.

WITH cte AS(
SELECT 
	order_id,
    customer_id,
    order_date,
    lead(order_date) OVER (Partition BY customer_id ORDER BY order_date) AS next_order
FROM orders)

SELECT 
	customer_id,
    order_date,
    next_order,
    DATEDIFF(next_order,order_date) AS order_gap
FROM cte
WHERE customer_id = 1;


-- Challenge 4: Regional Category Revenue Ranking
-- Uses a CTE to calculate category revenue by region and DENSE_RANK()
-- to rank categories within each region based on total revenue.

WITH calculated_revenue AS (SELECT
	p.category,
    c.region,
    sum(o.total_amount) AS category_revenue
From products As p
JOIN orders AS o ON p.product_id = o.product_id
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY p.category,c.region)

SELECT
	category,
    region,
    category_revenue,
    dense_rank() over(partition by region ORDER BY category_revenue DESC) AS rank_of_category
FROM calculated_revenue
order by region,category_revenue DESC;


-- Challenge 5: Order Classification
-- Uses CASE to classify orders based on quantity and total amount,
-- separating them into High-Value Bulk, Medium Bundle, or Standard Single.

SELECT
	order_id,
    quantity,
    total_amount,
    CASE
		WHEN quantity >= 3 OR total_amount >= 500 THEN 'High-value Bulk'
        WHEN quantity = 2 THEN 'Medium Bundle'
        ELSE 'Standard Single'
	END AS order_type
FROM orders;


-- Challenge 6: Regional Customer Spending Analysis
-- Helps the business identify its top-spending customers in each region
-- using CTEs and DENSE_RANK() to support targeted loyalty rewards.

WITH total_spending AS (SELECT
	customer_name,
    region,
    SUM(total_amount) AS total_spent
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
Group by customer_name,region),
assign_rank AS(SELECT 
	customer_name,
    region,
    total_spent,
    dense_rank() OVER (partition BY region order by total_spent DESC) AS customer_rank
FROM total_spending)

SELECT
	*
FROM assign_rank
WHERE customer_rank < 3;
