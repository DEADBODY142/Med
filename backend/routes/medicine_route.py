
from flask import Blueprint, jsonify, request
from app.services.medicine_service import MedicineService

medicine_routes = Blueprint('medicine_routes', __name__)
medicine_service = MedicineService()

# Add Medicine API
@medicine_routes.route('/api/add_medicine', methods=['POST'])
def add_medicine():
    try:
        data = request.get_json()
        name = data.get('name')
        dosage = data.get('dosage')
        timing = data.get('timing')
        user_id = data.get('user_id')

        if not all([name, dosage, timing, user_id]):
            return jsonify({"error": "All fields are required"}), 400

        # conn = sqlite3.connect(DB_PATH)
        # cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO medicines (name, dosage, timing, user_id)
            VALUES (?, ?, ?, ?)
        ''', (name, dosage, timing, user_id))
        conn.commit()
        conn.close()

        return jsonify({"message": "Medicine added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Get All Medicines API
@medicine_routes.route('/api/medicines', methods=['GET'])
def get_medicines():
    try:
        user_id = request.args.get('user_id')
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute('SELECT id, name, dosage, timing FROM medicines WHERE user_id = ?', (user_id,))
        medicines = [{"id": row[0], "name": row[1], "dosage": row[2], "timing": row[3]} for row in cursor.fetchall()]
        conn.close()

        return jsonify(medicines), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
