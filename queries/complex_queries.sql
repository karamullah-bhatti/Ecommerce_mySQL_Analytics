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


