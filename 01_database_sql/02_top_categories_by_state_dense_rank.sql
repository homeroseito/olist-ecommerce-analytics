-- ==============================================================================
-- OLIST PROJECT: TOP SELLING PRODUCT CATEGORIES BY CUSTOMER STATE
-- Tool: DBeaver | Database: PostgreSQL
-- Advanced Technique: Window Functions (DENSE_RANK)
-- ==============================================================================

WITH CategorySalesByState AS (
    SELECT 
        c.customer_state AS state,
        p.product_category_name AS product_category,
        COUNT(oi.order_id) AS total_items_sold,
        SUM(oi.price) AS total_revenue,
        -- DENSE_RANK creates an independent ranking inside each state boundary (PARTITION BY)
        -- sorted from highest items sold volume to lowest (ORDER BY DESC)
        DENSE_RANK() OVER (
            PARTITION BY c.customer_state 
            ORDER BY COUNT(oi.order_id) DESC
        ) AS ranking_position
    FROM olis_order_items oi
    JOIN olis_orders o ON oi.order_id = o.order_id
    JOIN olis_customers c ON o.customer_id = c.customer_id
    JOIN olis_products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered' 
      AND p.product_category_name IS NOT NULL
    GROUP BY c.customer_state, p.product_category_name
)
-- Extracting only the Top 3 product categories for each state in the final selection
SELECT 
    state,
    product_category,
    total_items_sold,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    ranking_position
FROM CategorySalesByState
WHERE ranking_position <= 3
ORDER BY state ASC, ranking_position ASC;