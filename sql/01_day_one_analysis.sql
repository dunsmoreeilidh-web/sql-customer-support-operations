-- Customer Support Operations Analysis
-- Day 1: filtering, grouping, aggregation, and conditional logic

-- 1. Preview the dataset.
SELECT *
FROM tickets
LIMIT 10;

-- 2. Count all tickets.
SELECT COUNT(*) AS total_tickets
FROM tickets;

-- 3. Compare ticket volume by category.
SELECT
    category,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY category
ORDER BY ticket_count DESC;

-- 4. Compare ticket volume by channel.
SELECT
    channel,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY channel
ORDER BY ticket_count DESC;

-- 5. Calculate the escalation rate for each category.
-- Multiplying by 100.0 forces decimal division rather than integer division.
SELECT
    category,
    COUNT(*) AS ticket_count,
    SUM(escalated) AS escalated_tickets,
    ROUND(100.0 * SUM(escalated) / COUNT(*), 1) AS escalation_rate_pct
FROM tickets
GROUP BY category
ORDER BY escalation_rate_pct DESC;

-- 6. Compare average satisfaction for AI-assisted and non-AI-assisted tickets.
SELECT
    CASE
        WHEN ai_assisted = 1 THEN 'AI-assisted'
        ELSE 'Not AI-assisted'
    END AS assistance_type,
    COUNT(*) AS rated_tickets,
    ROUND(AVG(csat_score), 2) AS average_csat
FROM tickets
WHERE csat_score IS NOT NULL
GROUP BY ai_assisted
ORDER BY average_csat DESC;

-- 7. Find unresolved high-priority tickets that may need attention.
SELECT
    ticket_id,
    created_at,
    channel,
    category,
    priority,
    escalated
FROM tickets
WHERE status = 'Open'
  AND priority = 'High'
ORDER BY created_at;

-- 8. Compare AI adoption by ticket category.
SELECT
    category,
    COUNT(*) AS ticket_count,
    SUM(ai_assisted) AS ai_assisted_tickets,
    ROUND(100.0 * SUM(ai_assisted) / COUNT(*), 1) AS ai_assisted_pct
FROM tickets
GROUP BY category
ORDER BY ai_assisted_pct DESC;

