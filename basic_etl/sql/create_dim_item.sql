CREATE TABLE if not exists dim_items (
    item_key SERIAL PRIMARY KEY,
    item varchar(80) NOT NULL UNIQUE
);

INSERT INTO dim_items (item)
SELECT DISTINCT item
FROM stg.sales
WHERE item IS NOT NULL
ON CONFLICT (item) DO NOTHING;