import turicreate as tc
from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import base64

# Load the trained Turi Create model
model = tc.load_model("recomendation_engine/recomendation_model")

app = Flask("movie_recomendation")
CORS(app)

# Connect to MongoDB
client = MongoClient("mongodb://mongodb-service:27017", username="admin", password="admin")
db = client["movie"]  # Zmień "myDatabase" na nazwę rzeczywistej bazy danych
photos_collection = db["image"]  # Zmień "myPhotos" na nazwę rzeczywistej kolekcji


@app.route("/predict", methods=["POST"])
def predict():
    try:
        reco = {}
        data = request.json
        user_id = data.get("userId", "test_user")
        num_recommendations = data.get("numRecommendations", 5)

        # Use your model to make recommendations
        prediction = model.recommend(users=[user_id], k=num_recommendations)

        # Retrieve photo information based on recommendation
        recommendations = []
        for i in prediction:
            recommendation = {
                "movieId": i["movieId"],
                "recommendationScore": i["score"]
            }
                     
            
            # Retrieve photo information from the database
            movie_data = photos_collection.find_one({"id": (i["movieId"])})

            if movie_data != None:
                photo_base64 = base64.b64encode(movie_data["data"]).decode("utf-8")
                # Add base64-encoded photo data to the recommendation
                recommendation["photoData"] = photo_base64
                
                if "title" in movie_data:
                    recommendation["title"] = movie_data["title"]

            
            recommendations.append(recommendation)

        app.logger.error(recommendation["title"])

        return jsonify({"recommendations": recommendations})

    except Exception as e:
        # Log the exception details
        app.logger.error(f"An error occurred: {str(e)}")

        # Return an error response with the exception details
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
