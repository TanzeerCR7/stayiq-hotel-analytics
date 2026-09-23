-- StayIQ: Core Business Analysis Queries
-- Database: stayiq.db | Table: bookings (119,390 rows)

-- 1. Overall cancellation rate
SELECT 
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS total_cancelled,
    ROUND(100.0 * SUM(is_canceled) / COUNT(*), 2) AS cancellation_rate_percent
FROM bookings;

-- 2. Cancellation rate by hotel type
SELECT 
    hotel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS total_cancelled,
    ROUND(100.0 * SUM(is_canceled) / COUNT(*), 2) AS cancellation_rate_percent
FROM bookings
GROUP BY hotel;

-- 3. Total revenue lost to cancellations (nightly rate basis)
SELECT 
    ROUND(SUM(adr), 2) AS revenue_lost_to_cancellations
FROM bookings
WHERE is_canceled = 1;

-- 4. Average lead time: cancelled vs completed bookings
SELECT 
    is_canceled,
    ROUND(AVG(lead_time), 1) AS avg_lead_time
FROM bookings
GROUP BY is_canceled;

-- 5. Cancellation rate by deposit type
SELECT 
    deposit_type,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS total_cancelled,
    ROUND(100.0 * SUM(is_canceled) / COUNT(*), 2) AS cancellation_rate_percent
FROM bookings
GROUP BY deposit_type
ORDER BY cancellation_rate_percent DESC;

-- 6. Cancellation rate by market segment
SELECT 
    market_segment,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS total_cancelled,
    ROUND(100.0 * SUM(is_canceled) / COUNT(*), 2) AS cancellation_rate_percent
FROM bookings
GROUP BY market_segment
ORDER BY cancellation_rate_percent DESC;

-- 7. Total revenue by customer type
SELECT 
    customer_type, 
    ROUND(SUM(adr), 2) AS total_revenue
FROM bookings
GROUP BY customer_type
ORDER BY total_revenue DESC;