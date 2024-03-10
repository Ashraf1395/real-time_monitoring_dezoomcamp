import psycopg2

# Add your PostgreSQL database connection details
DB_HOST = 'postgres'
DB_NAME = 'de_zoomcamp_data'
DB_USER = 'root'
DB_PASSWORD = 'ashraf'

# POSTGRES_DBNAME=
# POSTGRES_SCHEMA=de_zoomcamp
# POSTGRES_USER=
# POSTGRES_PASSWORD=
# POSTGRES_HOST=
# POSTGRES_PORT=5432

def insert_into_database(module_name, module_id, email, time_homework, time_lectures, score):
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()
    
    # Define your SQL query to insert data into the database
    sql = """INSERT INTO user_data_2024 (module_name, module_id, email, time_homework, time_lectures, score) 
             VALUES (%s, %s, %s, %s, %s, %s)"""
    
    # Execute the SQL query with the form data as parameters
    cursor.execute(sql, (module_name, module_id, email, time_homework, time_lectures, score))
    
    # Commit the transaction
    conn.commit()
    
    # Close the cursor and connection
    cursor.close()
    conn.close()
