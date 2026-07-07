-- ==============================================================================
-- OLIST PROJECT: CUSTOMER REPEAT PURCHASE BEHAVIOR AND RETENTION ANALYSIS
-- Tool: DBeaver | Database: PostgreSQL
-- Advanced Technique: Multi-level CTEs, Sub-queries & Share Calculations
-- ==============================================================================

WITH CustomerOrderCounts AS (
    -- Step 1: Calculate how many distinct orders each unique customer made
    -- Note: olist_customers has unique customer_id per order, but customer_unique_id tracks the actual person
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders_by_customer
    FROM olis_orders o
    JOIN olis_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

CustomerSegments AS (
    -- Step 2: Categorize customers into business segments based on purchase counts
    SELECT 
        total_orders_by_customer,
        COUNT(customer_unique_id) AS total_customers_in_segment,
        CASE 
            WHEN total_orders_by_customer = 1 THEN 'Single Buyer'
            WHEN total_orders_by_customer = 2 THEN '2-Time Repeat Buyer'
            ELSE '3+ Time Loyal Buyer'
        END AS customer_loyalty_segment
    FROM CustomerOrderCounts
    GROUP BY total_orders_by_customer
)

-- Step 3: Output final summary with percentage share of our total customer base
SELECT 
    customer_loyalty_segment,
    total_orders_by_customer AS orders_placed,
    total_customers_in_segment AS total_customers,
    ROUND(
        (total_customers_in_segment::numeric / SUM(total_customers_in_segment) OVER ()) * 100, 
        2
    ) AS customer_base_share_percentage
FROM CustomerSegments
ORDER BY total_orders_by_customer ASC;