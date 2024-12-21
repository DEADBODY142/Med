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

@app.route('/add_medicine', methods=['POST'])
def add_medicine():
    try:
        conn = sqlite3.connect('backend\medicine.db')
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS medicines (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                strength TEXT NOT NULL,
                selected_time TEXT,
                selected_type TEXT,
                selected_amount TEXT,
                start_date TEXT,
                finish_date TEXT,
                selected_days TEXT,
                frequency TEXT
            )
        ''')
        conn.commit()
        # conn.close()
        # Extract the data from the incoming JSON
        data = request.get_json()
        
        # Extract necessary fields from the data (adjust according to the keys you send)
        medicine_name = data.get('medicineName')
        strength = data.get('strength')
        selected_time = data.get('selectedTime')
        selected_type = data.get('selectedType')
        selected_amount = data.get('selectedAmount')
        start_date = data.get('startDate')
        finish_date = data.get('finishDate')
        selected_days = data.get('selectedDays')
        frequency = data.get('frequency')

        # Handle the data (e.g., save to a database or process it)
        # For now, just print it
        print(f'Medicine Name: {medicine_name}')
        print(f'Strength: {strength}')
        print(f'Selected Time: {selected_time}')
        print(f'Selected Type: {selected_type}')
        print(f'Selected Amount: {selected_amount}')
        print(f'Start Date: {start_date}')
        print(f'Finish Date: {finish_date}')
        print(f'Selected Days: {selected_days}')
        print(f'Frequency: {frequency}')
        # wat = conn.cursor()
        selected_days_str = ','.join(selected_days) if isinstance(selected_days, list) else ''
        cursor.execute('''
            INSERT INTO medicines (name, strength, selected_time, selected_type, selected_amount, start_date, finish_date, selected_days, frequency)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (medicine_name, strength, selected_time, selected_type, selected_amount, start_date, finish_date, selected_days_str, frequency))

        # Commit the transaction and close the connection
        conn.commit()
        conn.close()

        return jsonify({"message": "Medicine added successfully!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 400





@app.route('/')
def home():
    return 'home enabling CORS'

if __name__ == '__main__':
    init_db()
    app.run(debug=True)

# from flask import Flask, request, jsonify
# from flask_cors import CORS
# from app.routes.auth_route import auth_routes  
# from app.routes.medicine_route import medicine_routes  
# import sqlite3

# app = Flask(__name__)
# CORS(app)

# app.register_blueprint(auth_routes, url_prefix="/api")
# app.register_blueprint(medicine_routes, url_prefix="/api")

# @app.route('/')
# def home():
#     return 'home enabling CORS'

# if __name__ == '__main__':
#     app.run(debug=True)
