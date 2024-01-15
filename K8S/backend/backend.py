import turicreate as tc
from flask import Flask, request, jsonify
from flask_cors import CORS

# Load the trained Turi Create model
model = tc.load_model("recomendation_engine/recomendation_model")

app = Flask("movie_recomendation")
CORS(app)

@app.route("/predict", methods=["POST"])
def predict():
    try:
        reco = {}
        data = request.json
        user_id = data.get("userId", "test_user")
        num_recommendations = data.get("numRecommendations", 5)

        # Use your model to make recommendations
        prediction = model.recommend(users=[user_id], k=num_recommendations)

        # # Extract movie names from the prediction
        # recommendations = [item["item_id"] for item in prediction]

        # Return recommendations in JSON format
        for i in prediction:
            reco = i
            break
        return jsonify({"recommendations": reco})

    except Exception as e:
        # Log the exception details
        app.logger.error(f"An error occurred: {str(e)}")

        # Return an error response with the exception details
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
