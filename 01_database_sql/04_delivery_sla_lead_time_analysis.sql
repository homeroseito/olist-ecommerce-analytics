-- ==============================================================================
-- OLIST PROJECT: DELIVERY SLA AND LEAD TIME ANALYSIS BY CUSTOMER STATE
-- Tool: DBeaver | Database: PostgreSQL
-- Advanced Technique: Date Subtraction, Conditional Aggregations & Ratios
-- ==============================================================================

SELECT 
    c.customer_state AS state,
    COUNT(o.order_id) AS total_orders,
    
    -- 1. Calculates the average transit time (Purchase to Delivery)
    ROUND(AVG(DATE(o.order_delivered_customer_date) - DATE(o.order_purchase_timestamp))::numeric, 1) AS avg_delivery_days,
    
    -- 2. Calculates the average operational buffer (Actual vs Estimated)
    ROUND(AVG(DATE(o.order_delivered_customer_date) - DATE(o.order_estimated_delivery_date))::numeric, 1) AS avg_sla_delta_days,
    
    -- 3. Counts how many unique orders arrived past their promised estimated date
    COUNT(DISTINCT CASE 
        WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) THEN o.order_id 
    END) AS delayed_orders,
    
    -- 4. Calculates the percentage rate of late deliveries out of total orders
    ROUND(
        (COUNT(DISTINCT CASE WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) THEN o.order_id END)::numeric 
        / COUNT(o.order_id)) * 100, 
        2
    ) AS sla_delay_rate_percentage

FROM olis_orders o
JOIN olis_customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY sla_delay_rate_percentage DESC;