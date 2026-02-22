# barebones-etl-pipeline

A very barebones ETL pipeline written in PSQL and python using Psycopg3

In this project, I found a simple dirty dataset from Kaggle and decided to use ETL practices to load the data. I used the workflow : Raw -> Staging -> Star Schema. Using a star schema helps with the ease of analytics with the final data. I also chose the ETL workflow as it is more ideal for smaller datasets. 

![Star Schema](star_schema_diagram.png)

Above is the star schema diagram used. Identifying a grain and splitting up data into dims after serializing records allows for easy analytics as the complexity of the transformed data set increases. The star schema also provides better querying performance. 
