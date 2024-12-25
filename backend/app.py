import base64
from io import BytesIO
from flask import Flask, json, request, jsonify
from flask_cors import CORS
import sqlite3,os

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
                medicine_name TEXT,
                frequency TEXT,
                start_date TEXT,
                finish_date TEXT,
                selected_type TEXT,
                selected_amount TEXT,
                reminder_time TEXT,
                image_path TEXT
            )
        ''')
        conn.commit()
        # conn.close()
        # Extract the data from the incoming JSON
        if 'data' not in request.form:
            return jsonify({"error": "'data' field is missing from the request"}), 400
        
        # Get JSON data from the 'data' field in form-data
        data = json.loads(request.form['data'])  # Extract the 'data' field which is JSON
        print(f"Received data: {data}")  # Debugging print statement

        # Extract the fields from the JSON data
        medicine_name = data.get('medicine_name')
        frequency = data.get('frequency')
        start_date = data.get('start_date')
        finish_date = data.get('finish_date')
        selected_type = data.get('selected_type')
        selected_amount = data.get('selected_amount')
        reminder_time = data.get('reminder_time')
        if not all([medicine_name, frequency, start_date, finish_date,selected_type,selected_amount,reminder_time]):
            return jsonify({"error": "All fields are required"}), 400

        # base64_image = data.get('image')
        # filename = data.get('filename')

        # # Decode the base64 image
        # if base64_image:
        #     image_data = base64.b64decode(base64_image)
        #     image = BytesIO(image_data)
        #     image_path = os.path.join('uploads', filename)
            
        #     # Save the image
        #     with open(image_path, 'wb') as img_file:
        #         img_file.write(image_data)
        #     print(f"Image saved at {image_path}")


        
        # Debugging: Print the data
        print(f"Medicine Name: {medicine_name}, Frequency: {frequency}, Reminder Time: {reminder_time}")

        # Image handling (if exists)
        image_path = None
        if 'image' in request.files:
            image = request.files['image']
            # Save the image in the uploads folder
            image_path = os.path.join('uploads', image.filename)
            image.save(image_path)
            print(f"Image saved: {image.filename}")
        else:
            print("No image received")

        cursor.execute('''
            INSERT INTO medicines (medicine_name, frequency, start_date, finish_date, selected_type, selected_amount, reminder_time, image_path)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (medicine_name, frequency, start_date, finish_date, selected_type, selected_amount, reminder_time, image_path))

        # Commit the transaction
        conn.commit()
        conn.close()

        return jsonify({"status": "success", "message": "Medicine added successfully"}), 200

    except Exception as e:
        # If error occurs, return error response with message
        print(f"Error: {str(e)}")  # Log the exception for debugging
        return jsonify({"error": str(e)}), 400
        
        
        
        

    except Exception as e:
        return jsonify({"error": str(e)}), 400



@app.route('/add_reminder', methods=['POST'])
def add_reminder():
    try:
        conn = sqlite3.connect('backend\medicine.db')
        cursor = conn.cursor()
        cursor.execute('''
                    CREATE TABLE IF NOT EXISTS remainder (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mid TEXT,
            uid TEXT,
            time TEXT,
            msg TEXT,
            FOREIGN KEY (mid) REFERENCES medicines(mid),
            FOREIGN KEY (uid) REFERENCES registration(uid)
        );'''
        )
        conn.commit()
        data = request.get_json()

        # Input validation
        time = data.get('time')
        msg = data.get('msg')
        if not time or not msg:
            return jsonify({'error': 'All fields are required'}), 400
        return jsonify({"status": "success", "message": "Reminder added successfully"}), 200
    except:
        return jsonify({"error": "An error occurred while adding reminder"}), 500


@app.route('/appointment', methods=['POST'])
def appointment():
    try:
        conn = sqlite3.connect('backend\medicine.db')
        cursor = conn.cursor()
        cursor.execute('''
                    CREATE TABLE IF NOT EXISTS appointment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            speciality TEXT,
            date TEXT,
            time TEXT,
            uid INT,
            FOREIGN KEY (uid) REFERENCES registration(uid)
        );'''
        )
        conn.commit()
        data = request.get_json()

        # Input validation
        name = data.get('name')
        speciality = data.get('speciality')
        date = data.get('date')
        time = data.get('time')
        if not name or not speciality or not date or not time:
            return jsonify({'error': 'All fields are required'}), 400
        return jsonify({"status": "success", "message": "Reminder added successfully"}), 200
    except:
        return jsonify({"error": "An error occurred while adding reminder"}), 500



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
