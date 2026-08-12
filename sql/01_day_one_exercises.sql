-- DAY 1 PRACTICE
-- Write each query below the prompt. Run this file after saving your work.
-- It is completely normal to refer to 01_day_one_analysis.sql while learning.

-- Exercise 1:
-- Return ticket_id, created_at, category, and channel for all Email tickets.
-- Sort the newest tickets first and show only 15 rows.

SELECT ticket_id, created_at, category, channel
FROM tickets
WHERE channel = 'Email'
ORDER BY created_at DESC
LIMIT 15;

-- Exercise 2:
-- Count the number of tickets at each priority level.
-- Sort from the largest count to the smallest.

SELECT
    priority,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY priority
ORDER BY ticket_count DESC;

-- Exercise 3:
-- For each channel, show:
--   a) total ticket count
--   b) number of escalated tickets
--   c) escalation percentage rounded to one decimal place

SELECT
    channel,
    COUNT(*) AS ticket_count,
    SUM(escalated) AS escalated_tickets,
    ROUND(100.0 * SUM(escalated) / COUNT(*), 1) AS escalation_rate_pct
FROM tickets
GROUP BY channel
ORDER BY escalation_rate_pct DESC;

-- Exercise 4:
-- Show the average CSAT score by category, excluding tickets with no score.
-- Round the average to two decimal places and show the lowest average first.

SELECT
    category,
    ROUND(AVG(csat_score), 2) AS average_csat
FROM tickets
WHERE csat_score IS NOT NULL
GROUP BY category
ORDER BY average_csat ASC;

-- Exercise 5:
-- Create a readable label using CASE:
--   ai_assisted = 1 should display 'AI-assisted'
--   ai_assisted = 0 should display 'Human workflow'
-- Then count the number of tickets in each group.

SELECT
    CASE
        WHEN ai_assisted = 1 THEN 'AI-assisted'
        ELSE 'Human workflow'
    END AS assistance_type,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY ai_assisted;
