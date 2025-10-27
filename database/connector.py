import mysql.connector
import os
from dotenv import load_dotenv

# Carrega as variáveis do .env
load_dotenv()

def get_connection():
    """
    Cria e retorna uma conexão com o MySQL.
    """
    return mysql.connector.connect(
        host=os.getenv('DB_HOST', 'localhost'),
        database=os.getenv('DB_DATABASE', 'conecta_ubs'),
        user=os.getenv('DB_USER', 'root'),
        password=os.getenv('DB_PASSWORD', ''),
        port=int(os.getenv('DB_PORT', 3306))
    )


def execute_query(query, params=None):
    connection = get_connection()
    cursor = connection.cursor()
    
    try:
        cursor.execute(query, params or ())
        connection.commit()
        return cursor.lastrowid
    finally:
        cursor.close()
        connection.close()


def fetch_one(query, params=None):
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    
    try:
        cursor.execute(query, params or ())
        return cursor.fetchone()
    finally:
        cursor.close()
        connection.close()


def fetch_all(query, params=None):
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    
    try:
        cursor.execute(query, params or ())
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()