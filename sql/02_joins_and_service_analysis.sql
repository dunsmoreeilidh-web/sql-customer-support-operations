-- Customer Support Operations Analysis
-- Day 2: joins and cross-table analysis

-- 1. Connect each ticket with its assigned agent and team.
SELECT
    t.ticket_id,
    t.category,
    a.agent_name,
    a.team
FROM tickets AS t
JOIN agents AS a
    ON t.agent_id = a.agent_id
LIMIT 10;

-- 2. Compare assigned ticket volume by agent and team.
SELECT
    a.agent_name,
    a.team,
    COUNT(*) AS ticket_count
FROM tickets AS t
JOIN agents AS a
    ON t.agent_id = a.agent_id
GROUP BY a.agent_name, a.team
ORDER BY ticket_count DESC;

-- 3. Compare ticket volume, rating coverage, and average CSAT by agent.
SELECT
    a.agent_name,
    a.team,
    COUNT(*) AS ticket_count,
    COUNT(t.csat_score) AS rated_tickets,
    ROUND(AVG(t.csat_score), 2) AS average_csat
FROM tickets AS t
JOIN agents AS a
    ON t.agent_id = a.agent_id
GROUP BY a.agent_name, a.team
ORDER BY average_csat DESC;

-- 4. Calculate first-response time in minutes for individual tickets.
SELECT
    ticket_id,
    created_at,
    first_response_at,
    ROUND(
        (julianday(first_response_at) - julianday(created_at)) * 24 * 60,
        1
    ) AS first_response_minutes
FROM tickets
WHERE first_response_at IS NOT NULL
LIMIT 10;
