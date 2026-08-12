"""AI-assisted scaffolding that generates fictional data for my SQL practice."""

from __future__ import annotations

import csv
import random
from datetime import datetime, timedelta
from pathlib import Path


SEED = 20260807
ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "data" / "support_operations.csv"

CATEGORIES = {
    "Cancellation": {"weight": 18, "ai_rate": 0.55, "escalation_rate": 0.30, "minutes": 360},
    "Order Change": {"weight": 16, "ai_rate": 0.60, "escalation_rate": 0.22, "minutes": 280},
    "Payment Question": {"weight": 15, "ai_rate": 0.72, "escalation_rate": 0.16, "minutes": 210},
    "Delayed Flight": {"weight": 11, "ai_rate": 0.38, "escalation_rate": 0.36, "minutes": 420},
    "Account Access": {"weight": 14, "ai_rate": 0.80, "escalation_rate": 0.09, "minutes": 120},
    "Package Recommendation": {"weight": 13, "ai_rate": 0.76, "escalation_rate": 0.08, "minutes": 150},
    "Travel Agent Support": {"weight": 13, "ai_rate": 0.42, "escalation_rate": 0.25, "minutes": 330},
}

CHANNELS = ["Email", "Chat", "Web Form", "Phone"]
CHANNEL_WEIGHTS = [36, 34, 18, 12]
PRIORITIES = ["Low", "Normal", "High"]
PRIORITY_WEIGHTS = [18, 64, 18]
COUNTRIES = ["United States", "Canada", "United Kingdom", "Germany", "Australia"]
LOYALTY_TIERS = ["Standard", "Silver", "Gold"]
CUSTOMER_TYPES = ["Direct Traveler", "Travel Agent"]

AGENTS = [
    (1, "Avery Chen", "Customer Experience", "2024-03-11"),
    (2, "Jordan Patel", "Customer Experience", "2024-08-19"),
    (3, "Morgan Rivera", "Customer Experience", "2025-01-06"),
    (4, "Riley Thompson", "Customer Experience", "2025-05-27"),
    (5, "Casey Williams", "Escalations", "2023-11-13"),
]


def iso(dt: datetime | None) -> str:
    return dt.strftime("%Y-%m-%d %H:%M:%S") if dt else ""


def main() -> None:
    rng = random.Random(SEED)
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)

    customers = []
    for customer_id in range(1, 181):
        signup = datetime(2022, 1, 1) + timedelta(days=rng.randint(0, 1459))
        customers.append(
            {
                "customer_id": customer_id,
                "customer_type": rng.choices(CUSTOMER_TYPES, weights=[84, 16], k=1)[0],
                "country": rng.choices(COUNTRIES, weights=[72, 10, 8, 5, 5], k=1)[0],
                "loyalty_tier": rng.choices(LOYALTY_TIERS, weights=[67, 23, 10], k=1)[0],
                "signup_date": signup.strftime("%Y-%m-%d"),
            }
        )

    category_names = list(CATEGORIES)
    category_weights = [CATEGORIES[name]["weight"] for name in category_names]
    start = datetime(2026, 1, 1, 8, 0)
    rows = []

    for ticket_id in range(1001, 1361):
        category = rng.choices(category_names, weights=category_weights, k=1)[0]
        rules = CATEGORIES[category]
        channel = rng.choices(CHANNELS, weights=CHANNEL_WEIGHTS, k=1)[0]
        priority = rng.choices(PRIORITIES, weights=PRIORITY_WEIGHTS, k=1)[0]
        ai_assisted = int(rng.random() < rules["ai_rate"] and channel != "Phone")

        escalation_rate = rules["escalation_rate"]
        if priority == "High":
            escalation_rate += 0.12
        if ai_assisted:
            escalation_rate -= 0.03
        escalated = int(rng.random() < max(0.02, escalation_rate))

        created_at = start + timedelta(
            days=rng.randint(0, 180), hours=rng.randint(0, 11), minutes=rng.randint(0, 59)
        )

        first_response_minutes = rng.randint(2, 35) if ai_assisted else rng.randint(18, 190)
        if channel == "Phone":
            first_response_minutes = rng.randint(1, 8)
        first_response_at = created_at + timedelta(minutes=first_response_minutes)

        is_open = rng.random() < 0.07
        if is_open:
            status = "Open"
            resolved_at = None
            csat = None
        else:
            status = "Resolved"
            resolution_minutes = int(rules["minutes"] * rng.uniform(0.45, 1.75))
            if ai_assisted:
                resolution_minutes = int(resolution_minutes * 0.72)
            if escalated:
                resolution_minutes = int(resolution_minutes * 1.65)
            if priority == "High":
                resolution_minutes = int(resolution_minutes * 0.85)
            resolved_at = created_at + timedelta(minutes=max(15, resolution_minutes))

            score = 5
            if resolution_minutes > 240:
                score -= 1
            if resolution_minutes > 600:
                score -= 1
            if escalated:
                score -= 1
            score += rng.choices([-1, 0, 1], weights=[15, 70, 15], k=1)[0]
            csat = min(5, max(1, score)) if rng.random() < 0.78 else None

        agent_id = 5 if escalated and rng.random() < 0.58 else rng.randint(1, 4)
        customer = rng.choice(customers)
        if category == "Travel Agent Support":
            customer = rng.choice([c for c in customers if c["customer_type"] == "Travel Agent"])

        rows.append(
            {
                "ticket_id": ticket_id,
                "customer_id": customer["customer_id"],
                "agent_id": agent_id,
                "created_at": iso(created_at),
                "first_response_at": iso(first_response_at),
                "resolved_at": iso(resolved_at),
                "channel": channel,
                "category": category,
                "priority": priority,
                "ai_assisted": ai_assisted,
                "escalated": escalated,
                "status": status,
                "csat_score": "" if csat is None else csat,
            }
        )

    fieldnames = list(rows[0])
    with OUTPUT.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Generated {len(rows)} synthetic tickets at {OUTPUT}")


if __name__ == "__main__":
    main()
