# barebones-etl-pipeline

A very barebones ETL pipeline written in PSQL and python using Psycopg3

In this project, I found a simple dirty dataset from Kaggle and decided to use ETL practices to load the data. I used the workflow : Raw -> Staging -> Star Schema. Using a star schema helps with the ease of analytics with the final data. I also chose the ETL workflow as it is more ideal for smaller datasets. 

![Star Schema](star_schema_diagram.png)

Above is the star schema diagram used. Identifying a grain and splitting up data into dims after serializing records allows for easy analytics as the complexity of the transformed data set increases. The star schema also provides better querying performance. 

```
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
```

Above is short snippet of some logic used to filter out unwanted records automatically. The errors in the dirty dataset was predictable. I leveraged a LLM to help me quickly identify the conditions to filter out from the dirty dataset. 

The project has a lot of limitations. The code only runs locally as there is no cloud or OOTB server integration for the script. The script also only works for smaller datasets, not larger complex ones. This was more intended as a proof of concept to practice the barebones logic of a very simple ETL piepline developed from scratch ( without any tools ). 

All automated logic lives in the main.py script. 
