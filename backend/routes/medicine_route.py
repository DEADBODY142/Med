
from flask import Blueprint, jsonify, request
from app.services.medicine_service import MedicineService

medicine_routes = Blueprint('medicine_routes', __name__)
medicine_service = MedicineService()
# medicine_service = MedicineService(db_path='path/to/your/database/medicine.db')

# Add Medicine API
@medicine_routes.route('/add_medicine', methods=['POST'])
def add_medicine():
    try:
        data = request.get_json()
        medicine_name = data.get('medicine_name')
        doze = data.get('doze')
        timing = data.get('timing')
        type = data.get('type')
        amount = data.get('amount')
        frequency = data.get('frequency')
        start_date = data.get('start_date')
        end_date = data.get('end_date')
        days = data.get('days')
        image = data.get('image')
        user_id = data.get('user_id') #get uding token or session

        if not all([medicine_name, doze, timing, type, amount, frequency, start_date, end_date, days, image, user_id]):
            return jsonify({"error": "All fields are required"}), 400
        
        is_valid = medicine_service.add_medicine(medicine_name, doze, timing, type, amount, frequency, start_date, end_date, days, user_id, image)

        if is_valid:
            return jsonify({"message": "Medicine added successfully"}), 201
        else:
            return jsonify({"error": "failed to add medicine"}), 401

        
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# Get All Medicines API
# @medicine_routes.route('/api/medicines', methods=['GET'])
# def get_medicines():
#     try:
#         user_id = request.args.get('user_id')
#         if not user_id:
#             return jsonify({"error": "User ID is required"}), 400

#         conn = sqlite3.connect(DB_PATH)
#         cursor = conn.cursor()
#         cursor.execute('SELECT id, name, dosage, timing FROM medicines WHERE user_id = ?', (user_id,))
#         medicines = [{"id": row[0], "name": row[1], "dosage": row[2], "timing": row[3]} for row in cursor.fetchall()]
#         conn.close()

#         return jsonify(medicines), 200
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
