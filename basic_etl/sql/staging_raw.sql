CREATE SCHEMA IF NOT EXISTS stg;

DROP TABLE IF EXISTS stg.sales;

CREATE TABLE stg.sales AS
SELECT
    CASE
        WHEN UPPER(BTRIM(transaction_id)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        ELSE NULLIF(
                 regexp_replace(BTRIM(transaction_id), '[^0-9]', '', 'g'),
                 ''
             )::int
    END AS transaction_id,

    CASE
        WHEN UPPER(BTRIM(item)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        ELSE NULLIF(BTRIM(item), '')
    END AS item,

    CASE
        WHEN UPPER(BTRIM(quantity)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        WHEN BTRIM(quantity) ~ '^[0-9]+$'
        THEN BTRIM(quantity)::int
        ELSE NULL
    END AS quantity,

    CASE
        WHEN UPPER(BTRIM(price_per_unit)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        ELSE NULLIF(
                 regexp_replace(BTRIM(price_per_unit), '[^0-9.]', '', 'g'),
                 ''
             )::numeric(10,2)
    END AS price_per_unit,

    CASE
        WHEN UPPER(BTRIM(total_spent)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        ELSE NULLIF(
                 regexp_replace(BTRIM(total_spent), '[^0-9.]', '', 'g'),
                 ''
             )::numeric(10,2)
    END AS total_spent,

    CASE
        WHEN UPPER(BTRIM(payment_method)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        ELSE NULLIF(BTRIM(payment_method), '')
    END AS payment_method,

    CASE
        WHEN UPPER(BTRIM(location_of_order)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        ELSE NULLIF(BTRIM(location_of_order), '')
    END AS location_of_order,

    CASE
        WHEN UPPER(BTRIM(transaction_date)) IN 
            ('ERROR','N/A','NA','NULL','NONE','NAN','-','UNKNOWN')
        THEN NULL
        WHEN BTRIM(transaction_date) ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN BTRIM(transaction_date)::date
        ELSE NULL
    END AS transaction_date

FROM raw.sales;
