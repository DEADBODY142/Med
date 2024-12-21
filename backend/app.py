from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)

def init_db():
    """Initialize the database and create tables if they don't exist."""
    conn = sqlite3.connect('backend/medicine.db')
    cursor = conn.cursor()
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

@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.get_json()

    # Input validation
    email = data.get('email')
    first_name = data.get('firstName')
    last_name = data.get('lastName')
    password = data.get('password')
    if not email or not first_name or not last_name or not password:
        return jsonify({'error': 'All fields are required'}), 400


    try:
        conn = sqlite3.connect('backend\medicine.db')
        cursor = conn.cursor()

        # Check for duplicate email
        cursor.execute('SELECT * FROM registration WHERE mail = ?', (email,))
        existing_user = cursor.fetchone()
        if existing_user:
            return jsonify({'error': 'Email already exists'}), 409

        # Insert the new user
        cursor.execute('''
            INSERT INTO registration (mail, fname, lname, pass)
            VALUES (?, ?, ?, ?)
        ''', (email, first_name, last_name, password))
        conn.commit()
        return jsonify({'message': 'User added successfully!'}), 200
    except sqlite3.Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'success': False, 'message': 'Email and password are required'}), 400

    try:
        conn = sqlite3.connect('backend\medicine.db')
        cursor = conn.cursor()

        # Check if user exists with the given email and password
        cursor.execute(
            'SELECT * FROM registration WHERE mail = ? AND pass = ?',
            (email, password)
        )
        user = cursor.fetchone()
        conn.close()

        if user:
            return jsonify({'success': True, 'message': 'Login successful'}), 200
        else:
            return jsonify({'success': False, 'message': 'Invalid email or password'}), 401

    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'}), 500


@app.route('/')
def home():
    return 'home enabling CORS'

if __name__ == '__main__':
    init_db()
    app.run(debug=True)
