
-- ==============================================================================
-- PROJECT END-TO-END: E-COMMERCE PERFORMANCE ANALYSIS
-- Script 01: KPIs Extraction and Monthly Trend Analysis
-- Goal: Calculate monthly revenue, month-over-month (MoM) percentage change, and average ticket value.
-- ==============================================================================

WITH MonthlyRevenue AS (
    -- Step 1: Consolidates revenue and order volume by Year/Month.
    SELECT 
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(p.payment_value) AS total_revenue
    FROM olis_orders o
    JOIN olis_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
RevenueTrends AS (
    -- Step 2: Applies window functions to retrieve the previous month's revenue.
    SELECT 
        order_month,
        total_orders,
        total_revenue,
        ROUND(total_revenue / total_orders, 2) AS average_ticket,
        LAG(total_revenue, 1) OVER (ORDER BY order_month) AS previous_month_revenue
    FROM MonthlyRevenue
)
-- Step 3: Final selection calculating the month-over-month (MoM) percentage change.
SELECT 
    TO_CHAR(order_month, 'YYYY-MM') AS period,
    total_orders,
    ROUND(total_revenue, 2) AS revenue,
    average_ticket,
    ROUND(
        ((total_revenue - previous_month_revenue) / previous_month_revenue) * 100, 2
    ) AS mom_growth_percentage
FROM RevenueTrends
ORDER BY order_month;