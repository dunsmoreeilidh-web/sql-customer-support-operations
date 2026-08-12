-- Customer Support Operations Analysis
-- Final analysis: operational performance, AI assistance, service targets,
-- and agent workload
-- Developed with AI assistance after completing the foundational exercises.
-- I reviewed the query structure, outputs, and business interpretation.

-- 1. Create a high-level operational summary.
SELECT
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved_tickets,
    SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) AS open_tickets,
    SUM(escalated) AS escalated_tickets,
    ROUND(100.0 * SUM(escalated) / COUNT(*), 1) AS escalation_rate_pct,
    ROUND(AVG(csat_score), 2) AS average_csat
FROM tickets;

-- 2. Compare volume, speed, escalations, and satisfaction by category.
SELECT
    category,
    COUNT(*) AS ticket_count,
    ROUND(AVG(
        (julianday(first_response_at) - julianday(created_at)) * 24 * 60
    ), 1) AS avg_first_response_minutes,
    ROUND(AVG(
        (julianday(resolved_at) - julianday(created_at)) * 24 * 60
    ), 1) AS avg_resolution_minutes,
    ROUND(100.0 * SUM(escalated) / COUNT(*), 1) AS escalation_rate_pct,
    ROUND(AVG(csat_score), 2) AS average_csat
FROM tickets
GROUP BY category
ORDER BY ticket_count DESC;

-- 3. Compare service performance by support channel.
SELECT
    channel,
    COUNT(*) AS ticket_count,
    ROUND(AVG(
        (julianday(first_response_at) - julianday(created_at)) * 24 * 60
    ), 1) AS avg_first_response_minutes,
    ROUND(AVG(
        (julianday(resolved_at) - julianday(created_at)) * 24 * 60
    ), 1) AS avg_resolution_minutes,
    ROUND(100.0 * SUM(escalated) / COUNT(*), 1) AS escalation_rate_pct,
    ROUND(AVG(csat_score), 2) AS average_csat
FROM tickets
GROUP BY channel
ORDER BY avg_first_response_minutes ASC;

-- 4. Compare AI-assisted tickets with human-only workflows.
SELECT
    CASE
        WHEN ai_assisted = 1 THEN 'AI-assisted'
        ELSE 'Human workflow'
    END AS assistance_type,
    COUNT(*) AS ticket_count,
    ROUND(AVG(
        (julianday(first_response_at) - julianday(created_at)) * 24 * 60
    ), 1) AS avg_first_response_minutes,
    ROUND(AVG(
        (julianday(resolved_at) - julianday(created_at)) * 24 * 60
    ), 1) AS avg_resolution_minutes,
    ROUND(100.0 * SUM(escalated) / COUNT(*), 1) AS escalation_rate_pct,
    ROUND(AVG(csat_score), 2) AS average_csat
FROM tickets
GROUP BY ai_assisted
ORDER BY ai_assisted DESC;

-- 5. Measure a four-hour resolution target for each category.
-- Only resolved tickets belong in this calculation.
SELECT
    category,
    COUNT(*) AS resolved_tickets,
    SUM(
        CASE
            WHEN (julianday(resolved_at) - julianday(created_at)) * 24 <= 4
            THEN 1
            ELSE 0
        END
    ) AS resolved_within_four_hours,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN (julianday(resolved_at) - julianday(created_at)) * 24 <= 4
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS four_hour_target_pct
FROM tickets
WHERE status = 'Resolved'
GROUP BY category
ORDER BY four_hour_target_pct DESC;

-- 6. Compare agent workload, escalation mix, rating coverage, and CSAT.
-- A lower CSAT for an escalation specialist should be interpreted alongside
-- the percentage of that agent's tickets that were escalated.
SELECT
    a.agent_name,
    a.team,
    COUNT(*) AS assigned_tickets,
    SUM(t.escalated) AS escalated_tickets,
    ROUND(100.0 * SUM(t.escalated) / COUNT(*), 1) AS escalated_ticket_pct,
    COUNT(t.csat_score) AS rated_tickets,
    ROUND(AVG(t.csat_score), 2) AS average_csat
FROM tickets AS t
JOIN agents AS a
    ON t.agent_id = a.agent_id
GROUP BY a.agent_id, a.agent_name, a.team
ORDER BY assigned_tickets DESC;

-- 7. Compare ticket patterns for direct travelers and travel agents.
SELECT
    c.customer_type,
    COUNT(*) AS ticket_count,
    ROUND(100.0 * SUM(t.escalated) / COUNT(*), 1) AS escalation_rate_pct,
    ROUND(AVG(t.csat_score), 2) AS average_csat
FROM tickets AS t
JOIN customers AS c
    ON t.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY ticket_count DESC;
