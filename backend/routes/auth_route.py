from flask import Blueprint, jsonify, request
from app.services.user_service import UserService

auth_routes = Blueprint('auth_routes', __name__)
user_service = UserService()


@auth_routes.route('/')
def home():
    return 'welcome to home route'

@auth_routes.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return jsonify({"error": "Email and password are required"}), 400

        is_valid = user_service.verify_user(email, password)

        if is_valid:
            return jsonify({"message": "Login successful"}), 200
        else:
            return jsonify({"error": "Invalid email or password"}), 401
    except Exception as e:
        
        return jsonify({"error": str(e)}), 500
    
@auth_routes.route('/add_user', methods=['POST'])
def add_user():
    try:
        # Parse and validate input data
        data = request.get_json()
        email = data.get('email')
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        password = data.get('password')
        
        if not email or not first_name or not last_name or not password:
            return jsonify({"error": "Email, firstName, lastName, and password are required"}), 400

        # Register the user
        is_registered = user_service.register_user(email, first_name, last_name, password)

        if is_registered:
            return jsonify({'message': 'User added successfully!'}), 201
        else:
            return jsonify({"error": "User could not be registered. Email may already exist."}), 400
    except Exception as e:
        # Log and return the exception for debugging
        print(f"Error in add_user: {str(e)}")
        return jsonify({"error": str(e)}), 500
        
    
    

    