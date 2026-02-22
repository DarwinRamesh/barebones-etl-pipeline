CREATE TABLE IF NOT EXISTS dim_date (
    date_key SERIAL PRIMARY KEY,
    dim_date DATE NOT NULL UNIQUE
);

INSERT INTO dim_date (dim_date)
SELECT DISTINCT transaction_date::date FROM stg.sales
WHERE transaction_date IS NOT NULL
ON CONFLICT (dim_date) DO NOTHING;