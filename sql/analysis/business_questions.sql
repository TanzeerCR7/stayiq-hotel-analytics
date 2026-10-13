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

-- 3. ADR-only exposure on cancelled bookings (nightly rate; ignores length of stay)
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

-- 7. ADR-only booking value by customer type (nightly rate; includes cancelled bookings; superseded by query 9)
SELECT 
    customer_type, 
    ROUND(SUM(adr), 2) AS total_revenue
FROM bookings
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 8. Revenue exposure incl. length of stay (cancelled bookings)
-- Definition: SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)) WHERE is_canceled = 1
SELECT ROUND(SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)), 2) AS exposure_with_stay
FROM bookings
WHERE is_canceled = 1;

-- 9. Realised revenue by customer type incl. length of stay (non-cancelled bookings)
SELECT customer_type,
       ROUND(SUM(adr * (stays_in_weekend_nights + stays_in_week_nights)), 2) AS realised_revenue
FROM bookings
WHERE is_canceled = 0
GROUP BY customer_type
ORDER BY realised_revenue DESC;