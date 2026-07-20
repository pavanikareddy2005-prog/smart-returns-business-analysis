-- Smart Returns Platform - SQL Queries

-- Overall return rate
SELECT ROUND(100.0 * COUNT(DISTINCT r.return_id) / COUNT(DISTINCT o.order_id),2) AS return_rate_pct
FROM orders o LEFT JOIN returns r ON o.order_id = r.order_id;

-- Average refund cycle time
SELECT AVG(DATEDIFF(day, r.created_at, rf.refunded_at)) AS avg_refund_days
FROM returns r JOIN refunds rf ON r.return_id = rf.return_id;

-- Top return reasons
SELECT reason, COUNT(*) AS total FROM returns GROUP BY reason ORDER BY total DESC;

-- Fraud rate
SELECT ROUND(100.0*SUM(CASE WHEN risk_level='High' THEN 1 ELSE 0 END)/COUNT(*),2) AS fraud_rate_pct
FROM fraud_scores;

-- Returns by category
SELECT p.category, COUNT(r.return_id) AS returns_count
FROM returns r JOIN order_items oi ON r.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.category ORDER BY returns_count DESC;

-- Repeat abusers
SELECT r.customer_id, COUNT(*) AS suspicious
FROM returns r JOIN fraud_scores fs ON r.return_id=fs.return_id
WHERE fs.risk_level='High'
GROUP BY r.customer_id HAVING COUNT(*) >= 3;
