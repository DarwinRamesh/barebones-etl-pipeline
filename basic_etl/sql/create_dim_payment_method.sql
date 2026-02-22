CREATE TABLE IF NOT EXISTS dim_payment_methods(
    payment_method_key SERIAL PRIMARY KEY,
    payment_method varchar(80) NOT NULL UNIQUE
);

INSERT INTO dim_payment_methods (payment_method)
SELECT DISTINCT payment_method
FROM stg.sales
WHERE payment_method IS NOT NULL
ON CONFLICT (payment_method) DO NOTHING;