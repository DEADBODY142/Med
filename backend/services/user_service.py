import json
import sqlite3
import os

def init_db(db_path):
    # Ensure the database file exists or create the directory if necessary
    if not os.path.exists(os.path.dirname(db_path)):
        os.makedirs(os.path.dirname(db_path))

    # Connect to the database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    # Example: Create the table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS registration (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mail TEXT UNIQUE NOT NULL,
            fname TEXT NOT NULL,
            lname TEXT NOT NULL,
            pass TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

class UserService:
    def __init__(self):
        self.db_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '../models/medicine.db'))
        print(f"Database Path: {self.db_path}")
        
    def verify_user(self, email, password):
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        print(email)
        try:
            cursor.execute('''
                SELECT mail, pass FROM registration WHERE mail = ? AND pass = ?
            ''', (email, password))
            
            user = cursor.fetchone()

            print(user[0], "user")
            
            if user: 
                return 'login success'
            else:
                return 'Invalid email or password'
        except sqlite3.Error as e:
            print(f"Database error: {e}")
            return False
        finally:
            conn.close()

    def register_user(self, email, first_name, last_name, password):
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        try:
            # Insert user into the registration table
            cursor.execute('''
                INSERT INTO registration (mail, fname, lname, pass)
                VALUES (?, ?, ?, ?)
            ''', (email, first_name, last_name, password))
            conn.commit()
            
            # Check if the row was inserted
            if cursor.rowcount > 0:
                print("Insert successful")
                return True
            else:
                print("Insert failed: No rows affected")
                return False
        except sqlite3.IntegrityError as e:
            # Handle UNIQUE constraint violation for email
            print(f"Integrity Error: {e}")
            return False
        except sqlite3.Error as e:
            # Log and handle the database error
            print(f"Database error: {e}")
            return False
        finally:
            # Close the database connection
            conn.close()

