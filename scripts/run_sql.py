"""AI-assisted utility that runs my SQL files and prints each result."""

from __future__ import annotations

import sqlite3
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATABASE = ROOT / "database" / "support_operations.db"


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python scripts/run_sql.py sql/your_file.sql")

    sql_path = Path(sys.argv[1])
    if not sql_path.is_absolute():
        sql_path = ROOT / sql_path
    statements = [part.strip() for part in sql_path.read_text(encoding="utf-8").split(";") if part.strip()]

    with sqlite3.connect(DATABASE) as connection:
        for number, statement in enumerate(statements, start=1):
            cursor = connection.execute(statement)
            if cursor.description is None:
                continue
            columns = [item[0] for item in cursor.description]
            rows = cursor.fetchall()
            print(f"\nQuery {number}")
            print(" | ".join(columns))
            print("-" * max(30, len(" | ".join(columns))))
            for row in rows:
                print(" | ".join("NULL" if value is None else str(value) for value in row))


if __name__ == "__main__":
    main()
