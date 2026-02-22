CREATE TABLE IF NOT EXISTS dim_location(
    location_key SERIAL PRIMARY KEY,
    location_of_order VARCHAR(80) not NULL UNIQUE
);

INSERT INTO dim_location (location_of_order)
SELECT DISTINCT location_of_order
FROM stg.sales
WHERE location_of_order IS NOT NULL
ON CONFLICT (location_of_order) DO NOTHING;