# Customer Support Operations Analysis

I built this as my first practical SQL project after working with customer-support systems, workflow automation, and operational reporting. I wanted to practice using SQL on questions that felt similar to the ones I encountered at work: what creates support volume, where tickets get stuck, what escalates, and how an AI-assisted workflow might be evaluated.

> **Data privacy:** Every customer, agent, and ticket is fictional and generated locally. No employer, employee, or customer data is included.

## Project overview

The project contains 360 fictional support tickets assigned across five agents and 180 customers. It models seven support categories and four service channels. The tickets are stored in a three-table SQLite database so I could practice both single-table analysis and joins.

## What I did and where AI helped

I worked through the foundational SQL in `01_day_one_exercises.sql`, including filtering, grouping, averages, percentages, aliases, and `CASE` logic. I then practiced connecting the tickets and agents tables with a `JOIN` and calculating response time with SQLite's `julianday()` function. I reviewed the final query outputs and focused on interpreting what the results would mean for a support team.

I used AI assistance to:

- Create the fictional data generator and Python/SQLite project scaffolding
- Review and correct SQL as I learned
- Extend my exercises into the final analysis file
- Help organize and edit the README and findings

I am presenting this as evidence of foundational SQL and AI-assisted problem solving, not as a claim that I independently engineered every part of the Python application. All data is synthetic, and the introductory exercise file preserves the queries I personally worked through while learning.

### Business questions

1. Which support categories generate the most volume?
2. Which categories and channels have the slowest response and resolution times?
3. How do AI-assisted tickets compare with human-only workflows?
4. Which issues escalate most frequently?
5. What percentage of resolved tickets meet a four-hour resolution target?
6. How do workload, escalation mix, and customer satisfaction vary by agent?
7. Do direct travelers and travel agents show different support patterns?

## Key findings

- Account Access generated the highest ticket volume with 67 tickets, but also had the fastest average resolution time at 107.4 minutes and a 100% four-hour target rate.
- Cancellation had the highest escalation rate at 33.3%. Delayed Flight had the slowest average first response at 66.7 minutes and the lowest four-hour target rate at 6.7%.
- AI-assisted tickets had a much faster average first response than human-only workflows: 18.6 minutes compared with 70.1 minutes.
- AI-assisted tickets also had a higher average CSAT score in this fictional dataset: 4.47 compared with 3.97.
- Casey Williams had a lower average CSAT than the other agents, but 100% of Casey's assigned tickets were escalations. This demonstrates why performance metrics need operational context.

See [FINDINGS.md](FINDINGS.md) for the full interpretation and recommended actions.

## SQL I practiced

- Selecting and filtering data with `SELECT` and `WHERE`
- Sorting and limiting results with `ORDER BY` and `LIMIT`
- Aggregating data with `COUNT`, `SUM`, and `AVG`
- Grouping results with `GROUP BY`
- Creating readable categories with `CASE`
- Calculating rates and percentages
- Joining related tables with `JOIN`
- Calculating elapsed time with SQLite's `julianday()` function
- Handling missing values with `IS NOT NULL` and aggregate functions
- Reading query results and translating them into operational recommendations

## Database structure

```text
agents (1) ----< tickets >---- (1) customers
```

- `agents`: agent name, team, and hire date
- `customers`: customer type, country, loyalty tier, and signup date
- `tickets`: timestamps, channel, category, priority, AI assistance, escalation status, ticket status, and CSAT

The database schema includes primary keys, foreign keys, data-quality checks, and indexes for commonly queried fields.

## Project structure

```text
sql-support-operations/
├── README.md
├── FINDINGS.md
├── data/
│   └── support_operations.csv
├── database/
│   └── support_operations.db
├── scripts/
│   ├── build_database.py       # AI-assisted scaffolding
│   ├── generate_data.py        # AI-assisted scaffolding
│   └── run_sql.py              # AI-assisted scaffolding
└── sql/
    ├── 00_schema.sql
    ├── 01_day_one_analysis.sql
    ├── 01_day_one_exercises.sql
    ├── 02_joins_and_service_analysis.sql
    └── 03_final_business_analysis.sql
```

## Run the project

The project uses Python's built-in `sqlite3` module, so it does not require a separate database server or third-party Python packages.

From the project directory:

```bash
python3 scripts/generate_data.py
python3 scripts/build_database.py
python3 scripts/run_sql.py sql/03_final_business_analysis.sql
```

To run the earlier learning exercises:

```bash
python3 scripts/run_sql.py sql/01_day_one_exercises.sql
python3 scripts/run_sql.py sql/02_joins_and_service_analysis.sql
```

## Method and limitations

The dataset is deterministic: rerunning the generator produces the same records, making results reproducible. The patterns are intentionally designed to resemble plausible support operations, but they do not demonstrate causal effects. For example, the project can compare AI-assisted and human-only tickets, but it cannot prove that AI caused the performance differences because categories and channels are not randomly assigned.

## What I learned

This project helped me move from reading individual SQL queries to understanding how they fit into a small analysis. The biggest lesson was that producing a number is not the same as understanding it. For example, the escalation specialist's CSAT looks poor until the workload is segmented and it becomes clear that every assigned ticket was already escalated. I also became more comfortable using AI as a technical assistant while checking that I understood the structure and could explain the results myself.
