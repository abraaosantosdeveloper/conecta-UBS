from flask import Flask, jsonify, request, jsonify
from flask_cors import CORS

server = Flask(__name__)
CORS(server, 
     resources={r"/*": {
         "origins": "*",
         "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
         "allow_headers": ["Content-Type", "Authorization"]
     }})


@server.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    name = data.get('username')
    password = data.get('password')
    
    # print(f"Recebido: Nome: {name} | Senha: {password}")
    if name and password:
        import mysql.connector as connector
        cnx = connector.connect(host="localhost", user="root", password="", database="cesar_teste", port=3306)
        cursor = cnx.cursor()
        database_info = cursor.execute("SELECT * FROM usuarios")
        cnx.close()
        print(database_info)
        
        return jsonify({"message": "User data received successfully"}), 200
    else:
        return jsonify({"error": "Missing name or email"}), 400

@server.route('/')
def home():
    return "Bem vindo à api do Conecta UBS!"
