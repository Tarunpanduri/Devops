from flask import Flask, jsonify, request
from flask_cors import CORS
from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
CORS(app)

MONGO_URI = os.getenv("MONGO_URI")
client = MongoClient(MONGO_URI)
db = client["shop_database"]
collection = db["shops"]

@app.route('/api/shopdetails', methods=['GET'])
def get_shops():
    try:
        shops = list(collection.find({}, {"_id": 0}))
        return jsonify(shops), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/add_shop', methods=['POST'])
def add_shop():
    data = request.json
    if not data or not data.get("name") or not data.get("owner"):
        return jsonify({"error": "Missing required fields"}), 400
    try:
        result = collection.insert_one(data)
        return jsonify({"message": "Shop added successfully", "id": str(result.inserted_id)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
