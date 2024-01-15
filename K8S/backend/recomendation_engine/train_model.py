import turicreate as tc

# read data
data = tc.SFrame.read_csv("movie_ratings.csv")

print(data)

# Create a recommendation model
model = tc.item_similarity_recommender.create(data, user_id="userId", item_id="movieId", target="rating")

# Save model
# model.save("recomendation_model")

# Select a user for recommendations
user_id = [1]

# Generate recommendations for the selected user
predictions = model.recommend(users=user_id, k=5)

# Display recommendations
# print(type(predictions))

for i in predictions:
    print (type(i))
    print(i["userId"])