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
