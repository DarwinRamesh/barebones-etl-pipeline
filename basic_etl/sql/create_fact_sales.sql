CREATE TABLE IF NOT EXISTS fact_sales (
    transaction_id TEXT PRIMARY KEY,
    item_Key INT NOT NULL REFERENCES dim_items(item_Key),
    payment_method_key INT NOT NULL REFERENCES dim_payment_methods(payment_method_key),
    location_key INT NOT NULL REFERENCES dim_location(location_key),
    date_key INT NOT NULL REFERENCES dim_date(date_key),

    quantity INT NOT NULL CHECK (quantity >= 0),
    price_per_unit NUMERIC (10, 2) NOT NULL CHECK (price_per_unit >= 0),
    total_spent NUMERIC (10, 2) NOT NULL CHECK (total_spent >= 0)
);

CREATE INDEX IF NOT EXISTS idx_fact_sales_date_key ON fact_sales(date_key);
CREATE INDEX IF NOT EXISTS idx_fact_sales_item_key ON fact_sales(item_key);
CREATE INDEX IF NOT EXISTS idx_fact_sales_location_key ON fact_sales(location_key);
CREATE INDEX IF NOT EXISTS idx_fact_sales_payment_method_key ON fact_sales(payment_method_key);

INSERT INTO fact_sales (
    transaction_id,
    item_key,
    payment_method_key,
    location_key,
    date_key,
    quantity,
    price_per_unit,
    total_spent
)
SELECT
    s.transaction_id,
    i.item_key,
    pm.payment_method_key,
    l.location_key,
    d.date_key,
    s.quantity::int,
    s.price_per_unit::numeric(12,2),
    s.total_spent::numeric(12,2)
FROM stg.sales s
JOIN dim_items i
    ON i.item = s.item
JOIN dim_payment_methods pm
    ON pm.payment_method = s.payment_method
JOIN dim_location l
    ON l.location_of_order = s.location_of_order
JOIN dim_date d
    ON d.dim_date = s.transaction_date::date
WHERE s.transaction_id IS NOT NULL
    AND s.total_spent IS NOT NULL
    AND s.item IS NOT NULL
    AND s.payment_method IS NOT NULL
    AND s.location_of_order IS NOT NULL
    AND s.transaction_date IS NOT NULL
    AND s.quantity IS NOT NULL
    AND s.price_per_unit IS NOT NULL
    AND s.total_spent IS NOT NULL
ON CONFLICT (transaction_id) DO UPDATE
SET
    item_key = EXCLUDED.item_key,
    location_key = EXCLUDED.location_key,
    payment_method_key = EXCLUDED.payment_method_key,
    date_key = EXCLUDED.date_key,
    quantity = EXCLUDED.quantity,
    price_per_unit = EXCLUDED.price_per_unit,
    total_spent = EXCLUDED.total_spent;
