import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="airport_db"
    )

def execute_query(query, params=None, fetch=False):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(query, params or ())

    if fetch:
        result = cursor.fetchall()
        conn.close()
        return result

    conn.commit()
    conn.close()