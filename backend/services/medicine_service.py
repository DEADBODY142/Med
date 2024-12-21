import json
import sqlite3
import os

def init_db(db_path):
    if not os.path.exists(os.path.dirname(db_path)):
        os.makedirs(os.path.dirname(db_path))

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS medicine (
            medicine_id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicine_name TEXT NOT NULL,
            doze TEXT NOT NULL,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            user_id INTEGER NOT NULL,
            medicine_image TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
        );
    ''')
    conn.commit()
    conn.close()

class MedicineService:
    def add_medicine(self, name, doze, start_date, end_date, user_id, medicine_image):
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        try:
            # Insert user into the registration table
            cursor.execute('''
                INSERT INTO medicines (medicine_name, doze, start_date, end_date, user_id, medicine_image)
                VALUES (?, ?, ?, ?)
                ''', (name, doze, start_date, end_date, user_id, medicine_image))
            conn.commit()
            conn.close()
            
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
