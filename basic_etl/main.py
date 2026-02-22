from __future__ import annotations

import os
from pathlib import Path
import psycopg

#Initializing cursor logic

def run_file(cur: psycopg.Cursor, path: Path) -> None:
    sql = path.read_text(encoding="utf-8").strip()
    if not sql:
        return 
    cur.execute(sql)

#Executing files

def main() -> int:
    sql_dir = Path("/home/n9wiff/basic_etl/sql/")
    
    files = [
            "create_raw.sql",
            "staging_raw.sql",
            "create_dim_date.sql",
            "create_dim_item.sql",
            "create_dim_location.sql",
            "create_dim_payment_method.sql",
            "create_fact_sales.sql",
        ]


    conn = psycopg.connect(
        host=os.getenv("PGHOST", "localhost"),
        port=int(os.getenv("PGPORT", "5432")),
        dbname=os.getenv("PGDATABASE", "dirty"),
        user=os.getenv("PGUSER", "postgres"),
        password=os.getenv("PGPASSWORD", ""),

    )
    print("Connected to PSQL")
    
    try:
        with conn:
            with conn.cursor() as cur:
                for name in files:
                    run_file(cur, sql_dir / name)
                    print("Runnning files")
        return 0
    finally:
        conn.close()
        print("Operation succesful")


if __name__ == "__main__":
    raise SystemExit(main())
