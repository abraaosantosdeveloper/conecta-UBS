from flask import Blueprint, request, jsonify
from services.auth_service import login_service

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=["POST", "OPTIONS"])
def login():
    if request.method == "OPTIONS":
        return jsonify({}), 200
    
    data = request.get_json()
    return login_service(data)