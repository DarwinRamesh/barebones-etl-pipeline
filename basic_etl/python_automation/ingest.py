import psycopg

with psycopg.connect(

    host = "localhost",
    dbname = "dirty",
    user = "postgres",
    password = "password",
    port=5432
) as conn:
    print("Connected!")

    with conn.cursor() as cur:
        cur.execute("SELECT * FROM example;")
        result = cur.fetchall()
        print(result)

