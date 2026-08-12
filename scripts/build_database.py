"""AI-assisted scaffolding that builds the SQLite practice database."""

from __future__ import annotations

import csv
import sqlite3
from pathlib import Path

from generate_data import AGENTS, CUSTOMER_TYPES, COUNTRIES, LOYALTY_TIERS, SEED


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "support_operations.db"
SCHEMA = ROOT / "sql" / "00_schema.sql"
CSV_PATH = ROOT / "data" / "support_operations.csv"


def reconstruct_customers() -> list[tuple]:
    """Recreate the seeded customer dimension used by generate_data.py."""
    import random
    from datetime import datetime, timedelta

    rng = random.Random(SEED)
    customers = []
    for customer_id in range(1, 181):
        signup = datetime(2022, 1, 1) + timedelta(days=rng.randint(0, 1459))
        customers.append(
            (
                customer_id,
                rng.choices(CUSTOMER_TYPES, weights=[84, 16], k=1)[0],
                rng.choices(COUNTRIES, weights=[72, 10, 8, 5, 5], k=1)[0],
                rng.choices(LOYALTY_TIERS, weights=[67, 23, 10], k=1)[0],
                signup.strftime("%Y-%m-%d"),
            )
        )
    return customers


def main() -> None:
    if not CSV_PATH.exists():
        raise SystemExit("Run scripts/generate_data.py first.")

    DATABASE.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(DATABASE) as connection:
        connection.executescript(SCHEMA.read_text(encoding="utf-8"))
        connection.executemany(
            "INSERT INTO agents(agent_id, agent_name, team, hire_date) VALUES (?, ?, ?, ?)",
            AGENTS,
        )
        connection.executemany(
            "INSERT INTO customers(customer_id, customer_type, country, loyalty_tier, signup_date) VALUES (?, ?, ?, ?, ?)",
            reconstruct_customers(),
        )

        with CSV_PATH.open(newline="", encoding="utf-8") as file:
            rows = list(csv.DictReader(file))
        connection.executemany(
            """
            INSERT INTO tickets(
                ticket_id, customer_id, agent_id, created_at, first_response_at,
                resolved_at, channel, category, priority, ai_assisted,
                escalated, status, csat_score
            ) VALUES (
                :ticket_id, :customer_id, :agent_id, :created_at, :first_response_at,
                NULLIF(:resolved_at, ''), :channel, :category, :priority,
                :ai_assisted, :escalated, :status, NULLIF(:csat_score, '')
            )
            """,
            rows,
        )

        checks = connection.execute(
            "SELECT (SELECT COUNT(*) FROM tickets), (SELECT COUNT(*) FROM customers), (SELECT COUNT(*) FROM agents)"
        ).fetchone()

    print(f"Built {DATABASE}")
    print(f"Validation: {checks[0]} tickets, {checks[1]} customers, {checks[2]} agents")


if __name__ == "__main__":
    main()
