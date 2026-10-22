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
