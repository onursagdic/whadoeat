from flask import Flask, request, jsonify
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import MultiLabelBinarizer
from collections import Counter
from sklearn.feature_extraction.text import TfidfTransformer
import firebase_admin
from firebase_admin import credentials, firestore
import json

app = Flask(__name__)

# Firestore'a bağlanmak için Firebase Admin SDK'nızın özel anahtarını kullanın
firebase_admin.initialize_app()

# Firestore client'ını başlat
db = firestore.client()

# Tarif ID'lerine göre tarifleri bir sözlükte sakla
try:
    with open('recipes.json', 'r', encoding='utf-8') as file:
        recipes_data = json.load(file)
    recipes_dict = {recipe['id']: {'ingredients': recipe.get('ingredientNames', []), 'name': recipe['name']} for recipe in recipes_data}
    print(f"Loaded {len(recipes_dict)} recipes from recipes.json")
except Exception as e:
    print(f"Error loading recipes.json: {e}")
    recipes_dict = {}

# Kullanıcı verilerini JSON dosyasından yükle
try:
    with open('users_data.json', 'r', encoding='utf-8') as file:
        users_data = json.load(file)
    print(f"Loaded {len(users_data)} users from users_data.json")
except Exception as e:
    print(f"Error loading users_data.json: {e}")

def get_user_data(user_id):
    try:
        print(f"Fetching user data for user_id: {user_id}")
        user_ref = db.collection('users').document(user_id)
        user_doc = user_ref.get()

        if user_doc.exists:
            user_data = user_doc.to_dict()

            user_history = user_ref.collection('history').stream()
            user_favorites = user_ref.collection('favorites').stream()

            history_ids = [doc.to_dict().get('recipeId') for doc in user_history]
            favorites_ids = [doc.to_dict().get('recipeId') for doc in user_favorites]

            print(f"User {user_id} history: {history_ids}")
            print(f"User {user_id} favorites: {favorites_ids}")

            return {
                'userId': user_id,
                'history': history_ids,
                'favorites': favorites_ids
            }
        else:
            print(f"User {user_id} not found in Firestore")
            return None
    except Exception as e:
        print(f"Error getting user data for {user_id}: {e}")
        return None

def get_recipe_details(recipe_ids):
    try:
        recipe_details = []

        for recipe_id in recipe_ids:
            print(f"Fetching details for recipe ID: {recipe_id}")
            recipe_doc = db.collection('recipes').document(recipe_id).get()

            if recipe_doc.exists:
                data = recipe_doc.to_dict()
                recipe_details.append({
                    'id': recipe_id,
                    'name': data.get('name'),
                    'details': data.get('details'),
                    'ingredients': data.get('ingredients'),
                    'ingredientNames': data.get('ingredientNames'),
                    'category': data.get('category'),
                    'image': data.get('image'),
                    'preparation': data.get('preparation'),
                    'ratingPoint': data.get('ratingPoint'),
                    'userCount': data.get('userCount')
                })
                print(f"Fetched details for recipe {recipe_id}")
            else:
                print(f"Recipe {recipe_id} not found in Firestore")

        return recipe_details
    except Exception as e:
        print(f"Error getting recipe details: {e}")
        return []

def process_json_user_data(users_data):
    try:
        combined_recipes = []
        user_ids = []
        user_favorites = []

        for user in users_data:
            combined = set()
            for recipe_id in user['history'] + user['favorites']:
                if recipe_id in recipes_dict:
                    ingredients = recipes_dict[recipe_id]['ingredients']
                    combined.update(ingredients)
            combined_recipes.append(list(combined))
            user_ids.append(user['userId'])
            user_favorites.append(set(user['favorites']))

        print(f"Processed {len(user_ids)} users from JSON data")
        return combined_recipes, user_ids, user_favorites
    except Exception as e:
        print(f"Error processing JSON user data: {e}")
        return [], [], []

def recommend_recipes(user_id):
    try:
        if not user_id:
            print("User ID is missing")
            return {'error': 'User ID is missing'}

        print(f"Received request for user_id: {user_id}")
        user_data = get_user_data(user_id)
        if not user_data:
            print(f"Invalid User ID: {user_id}")
            return {'error': 'User ID is invalid'}

        combined_recipes, user_ids, user_favorites = process_json_user_data(users_data)

        user_combined = set()
        for recipe_id in user_data['history'] + user_data['favorites']:
            if recipe_id in recipes_dict:
                ingredients = recipes_dict[recipe_id]['ingredients']
                user_combined.update(ingredients)
        combined_recipes.append(list(user_combined))
        user_ids.append(user_id)
        user_favorites.append(set(user_data['favorites']))

        mlb = MultiLabelBinarizer()
        recipe_matrix = mlb.fit_transform(combined_recipes)
        tfidf_transformer = TfidfTransformer()
        tfidf_matrix = tfidf_transformer.fit_transform(recipe_matrix)

        knn = NearestNeighbors(n_neighbors=3, algorithm='brute')
        knn.fit(tfidf_matrix)

        user_index = user_ids.index(user_id)
        distances, indices = knn.kneighbors(tfidf_matrix[user_index], n_neighbors=3)

        recommended_recipes = []
        for index in indices[0]:
            if index < len(users_data):
                favorite_ids = users_data[index]['favorites']
                non_favorite_recipes = [rec_id for rec_id in favorite_ids if rec_id not in user_favorites[user_index]]
                recommended_recipes.extend(non_favorite_recipes)

        # Kullanıcının favori kategorilerini belirle
        favorite_categories = Counter()
        for recipe_id in user_data['favorites']:
            if recipe_id in recipes_dict:
                category = recipes_dict[recipe_id].get('category')
                if category:
                    favorite_categories[category] += 1

        # Önerilen tarifleri favori kategorilere göre ağırlıklandır
        recommended_recipe_ids = [rec_id for rec_id, count in Counter(recommended_recipes).most_common(50)]
        weighted_recommendations = []
        for rec_id in recommended_recipe_ids:
            category = recipes_dict[rec_id].get('category')
            weight = favorite_categories.get(category, 1)
            weighted_recommendations.extend([rec_id] * weight)

        final_recommendations = [rec_id for rec_id, count in Counter(weighted_recommendations).most_common(10)]
        print(f"Recommended recipe IDs: {final_recommendations}")

        recipe_details = get_recipe_details(final_recommendations)
        print(f"Recipe details: {recipe_details}")

        return {'recommended_recipes': recipe_details}
    except Exception as e:
        print(f"Error in recommend_recipes: {e}")
        return {'error': 'Internal server error'}


@app.route('/recommend', methods=['GET'])
def recommend():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is missing'}), 400
    
    result = recommend_recipes(user_id)
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
