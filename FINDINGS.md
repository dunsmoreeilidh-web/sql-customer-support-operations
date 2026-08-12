# Findings and Recommendations

This document records my interpretation of the query results. AI assistance helped me check the calculations and organize the writing, but the purpose of the exercise was to practice deciding which metrics matter and what questions I would ask next.

## Executive summary

The fictional dataset contains 360 support tickets. Of these, 335 were resolved and 25 remained open. The overall escalation rate was 16.4%, and the average CSAT score among rated tickets was 4.28 out of 5.

The analysis suggests that support performance varies more meaningfully by issue category than by intake channel. Account Access and Package Recommendation performed well against the four-hour resolution target. Cancellation, Travel Agent Support, and Delayed Flight created greater operational risk through higher escalation rates, slower resolution, or both.

AI-assisted tickets performed better than human-only workflows across the selected response, resolution, escalation, and satisfaction measures. Because this is synthetic observational data, these differences should be treated as signals for further investigation rather than proof that AI assistance caused the improvement.

## 1. Ticket demand

Account Access was the largest category with 67 tickets, followed by Cancellation with 60 and Order Change with 56. Delayed Flight was the smallest category with 35 tickets.

Email and Chat handled most of the workload, with 133 and 127 tickets respectively. Together, they represented more than 72% of all tickets.

**Recommendation:** Prioritize automation, documentation, and staffing decisions around high-volume categories and the Email and Chat channels.

## 2. Category performance

| Category | Tickets | Avg. first response | Avg. resolution | Escalation rate | Avg. CSAT |
| --- | ---: | ---: | ---: | ---: | ---: |
| Account Access | 67 | 32.1 min | 107.4 min | 6.0% | 4.90 |
| Cancellation | 60 | 38.1 min | 388.6 min | 33.3% | 3.64 |
| Order Change | 56 | 37.3 min | 278.7 min | 21.4% | 4.00 |
| Package Recommendation | 50 | 28.9 min | 139.6 min | 0.0% | 4.79 |
| Travel Agent Support | 48 | 46.0 min | 361.7 min | 27.1% | 3.84 |
| Payment Question | 44 | 32.7 min | 194.7 min | 9.1% | 4.66 |
| Delayed Flight | 35 | 66.7 min | 525.7 min | 17.1% | 3.71 |

Cancellation combined the highest escalation rate with relatively low satisfaction. Delayed Flight had the slowest response and resolution times. These two categories are the clearest candidates for process review.

**Recommendation:** Review Cancellation decision rules, approval requirements, and escalation triggers. For Delayed Flight, investigate whether response delays result from staffing, missing information, or reliance on external updates.

## 3. Four-hour resolution target

Account Access and Package Recommendation achieved a 100% four-hour resolution rate. Payment Question reached 72.1%. Delayed Flight reached only 6.7%, while Cancellation reached 20.8%.

**Recommendation:** Use category-specific targets rather than relying only on one overall service metric. A four-hour target may be realistic for Account Access but may require redesigned workflows or a different benchmark for complex disruption cases.

## 4. AI-assisted and human workflows

| Workflow | Tickets | Avg. first response | Avg. resolution | Escalation rate | Avg. CSAT |
| --- | ---: | ---: | ---: | ---: | ---: |
| AI-assisted | 219 | 18.6 min | 205.7 min | 15.1% | 4.47 |
| Human workflow | 141 | 70.1 min | 363.2 min | 18.4% | 3.97 |

AI-assisted tickets were associated with faster responses, faster resolutions, a slightly lower escalation rate, and higher satisfaction in this dataset.

**Recommendation:** Investigate expanding AI assistance in categories with repeatable information needs, while continuing to monitor accuracy, escalations, customer satisfaction, and cases that require human judgment.

## 5. Agent workload and context

Four Customer Experience agents handled between 71 and 86 tickets each, indicating a fairly balanced general workload. Casey Williams handled 34 tickets and had an average CSAT of 2.74, but every assigned ticket was escalated.

**Recommendation:** Do not compare agent-level CSAT without accounting for case complexity and escalation mix. Performance reporting should segment specialist escalation work from standard support work.

## 6. Customer type

Direct Travelers generated 254 tickets with a 15.7% escalation rate and 4.29 average CSAT. Travel Agents generated 106 tickets with a 17.9% escalation rate and 4.26 average CSAT. The satisfaction difference was minimal, while Travel Agents escalated slightly more often.

**Recommendation:** Review Travel Agent support needs separately and determine whether dedicated documentation, routing, or specialized workflows could reduce escalations.

## Limitations

- The data is fictional and intentionally generated with built-in patterns.
- The analysis describes associations and does not establish causation.
- Average resolution calculations exclude open tickets because they do not have a resolution timestamp.
- Average CSAT calculations exclude unrated tickets because SQLite's `AVG()` ignores `NULL` values.
- A production analysis would also examine trends over time, repeat contacts, staffing schedules, cost, and statistically meaningful changes after workflow updates.
