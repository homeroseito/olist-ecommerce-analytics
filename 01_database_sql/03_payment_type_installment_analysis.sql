-- ==============================================================================
-- OLIST PROJECT: PAYMENT METHOD PERFORMANCE AND INSTALLMENT ANALYSIS
-- Tool: DBeaver | Database: PostgreSQL
-- Advanced Technique: Multi-Metric Aggregations & Explicit Type Casting
-- ==============================================================================

SELECT 
    op.payment_type,
    COUNT(DISTINCT op.order_id) AS total_orders,
    ROUND(SUM(op.payment_value)::numeric, 2) AS total_revenue,
    -- Casts the text column into an integer before calculating the average
    ROUND(AVG(op.payment_installments::integer), 1) AS avg_installments,
    -- Calculates the percentage share of revenue for each payment type
    ROUND(
        (SUM(op.payment_value) / SUM(SUM(op.payment_value)) OVER ())::numeric * 100, 
        2
    ) AS revenue_share_percentage
FROM olis_order_payments op
JOIN olis_orders o ON op.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND op.payment_type IS NOT NULL
GROUP BY op.payment_type
ORDER BY total_revenue DESC;