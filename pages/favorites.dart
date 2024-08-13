import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recipe_details.dart'; // Import the RecipeDetails page
import 'package:whadoeat/components/bottom_appbar.dart';
import 'package:whadoeat/components/recipe_list.dart';
import 'package:whadoeat/components/recipe_card.dart'; // Import RecipeCard

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favoriteRecipes = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> recipes = [];
        for (var doc in querySnapshot.docs) {
          fetchRecipeDetails(doc['recipeId']).then((recipeData) {
            if (recipeData != null) {
              recipes.add(recipeData);
              setState(() {
                _favoriteRecipes = recipes;
              });
            }
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>?> fetchRecipeDetails(String recipeId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (doc.exists) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'details': doc['details'],
          'ingredients': doc['ingredients'],
          'ingredientNames': doc['ingredientNames'],
          'category': doc['category'],
          'image': doc['image'],
          'preparation': doc['preparation'],
          'ratingPoint': doc['ratingPoint'],
          'userCount': doc['userCount'],
        };
      }
    } catch (e) {
      print("Error fetching recipe details: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Beğendiğim Tarifler",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _favoriteRecipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _favoriteRecipes[index];
                  double averageRating = (recipe['ratingPoint'] ?? 0) / (recipe['userCount'] ?? 1);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetails(
                            recipe: recipe,
                            averageRating: averageRating,
                          ),
                        ),
                      );
                    },
                    child: RecipeCard(recipe: recipe, averageRating: averageRating),
                  );
                },
              ),
            ),
            RecipeList(recipes: _favoriteRecipes),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recipe_details.dart'; // Import the RecipeDetails page
import 'package:whadoeat/components/bottom_appbar.dart';
import 'package:whadoeat/components/recipe_list.dart';
import 'package:whadoeat/components/recipe_card.dart'; // Import RecipeCard

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favoriteRecipes = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> recipes = [];
        for (var doc in querySnapshot.docs) {
          fetchRecipeDetails(doc['recipeId']).then((recipeData) {
            if (recipeData != null) {
              recipes.add(recipeData);
              setState(() {
                _favoriteRecipes = recipes;
              });
            }
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>?> fetchRecipeDetails(String recipeId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (doc.exists) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'details': doc['details'],
          'ingredients': doc['ingredients'],
          'ingredientNames': doc['ingredientNames'],
          'category': doc['category'],
          'image': doc['image'],
          'preparation': doc['preparation'],
          'ratingPoint': doc['ratingPoint'],
          'userCount': doc['userCount'],
        };
      }
    } catch (e) {
      print("Error fetching recipe details: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Beğendiğim Tarifler",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _favoriteRecipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _favoriteRecipes[index];
                  double averageRating = (recipe['ratingPoint'] ?? 0) / (recipe['userCount'] ?? 1);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetails(
                            recipe: recipe,
                            averageRating: averageRating,
                          ),
                        ),
                      );
                    },
                    child: RecipeCard(recipe: recipe, averageRating: averageRating),
                  );
                },
              ),
            ),
            RecipeList(recipes: _favoriteRecipes),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
*/




/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recipe_details.dart'; // Import the RecipeDetails page
import 'package:whadoeat/components/bottom_appbar.dart';
import 'package:whadoeat/components/recipe_list.dart';
//import 'package:whadoeat/components/recipe_card.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favoriteRecipes = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> recipes = [];
        for (var doc in querySnapshot.docs) {
          fetchRecipeDetails(doc['recipeId']).then((recipeData) {
            if (recipeData != null) {
              recipes.add(recipeData);
              setState(() {
                _favoriteRecipes = recipes;
              });
            }
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>?> fetchRecipeDetails(String recipeId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (doc.exists) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'details': doc['details'],
          'ingredients': doc['ingredients'],
          'ingredientNames': doc['ingredientNames'],
          'category': doc['category'],
          'image': doc['image'],
          'preparation': doc['preparation'],
          'ratingPoint': doc['ratingPoint'],
          'userCount': doc['userCount'],
        };
      }
    } catch (e) {
      print("Error fetching recipe details: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Beğendiğim Tarifler",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _favoriteRecipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _favoriteRecipes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetails(recipe: recipe),
                        ),
                      );
                    },
                    //child: RecipeCard(recipe: recipe),
                  );
                },
              ),
            ),
            *//*     const SizedBox(height: 30),
          const Text(
              'Tüm Tarifler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),*//*
            RecipeList(recipes: _favoriteRecipes),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}*/


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recipe_details.dart'; // Import the RecipeDetails page
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'auth_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favoriteRecipes = [];
  Set<String> _favoriteRecipeIds = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> recipes = [];
        Set<String> favoriteIds = Set<String>();
        for (var doc in querySnapshot.docs) {
          favoriteIds.add(doc['recipeId']);
          fetchRecipeDetails(doc['recipeId']).then((recipeData) {
            if (recipeData != null) {
              recipes.add(recipeData);
              setState(() {
                _favoriteRecipes = recipes;
                _favoriteRecipeIds = favoriteIds;
              });
            }
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>?> fetchRecipeDetails(String recipeId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (doc.exists) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'details': doc['details'],
          'ingridients': doc['ingridients'],
          'ingridientnames': doc['ingridientnames'],
          'image': doc['image'],
        };
      }
    } catch (e) {
      print("Error fetching recipe details: $e");
    }
    return null;
  }

  void toggleFavorite(String recipeId) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentReference favoriteDoc = userDoc.collection('favorites').doc(recipeId);

      if (_favoriteRecipeIds.contains(recipeId)) {
        await favoriteDoc.delete();
        setState(() {
          _favoriteRecipeIds.remove(recipeId);
          _favoriteRecipes.removeWhere((recipe) => recipe['id'] == recipeId);
        });
      } else {
        await favoriteDoc.set({'recipeId': recipeId});
        fetchRecipeDetails(recipeId).then((recipeData) {
          if (recipeData != null) {
            setState(() {
              _favoriteRecipeIds.add(recipeId);
              _favoriteRecipes.add(recipeData);
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text(
          "Beğendiğim Tarifler",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _favoriteRecipes[index];
          final bool isFavorite = _favoriteRecipeIds.contains(recipe['id']);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetails(recipe: recipe),
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text(
                  recipe['name'],
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    toggleFavorite(recipe['id']);
                  },
                ),
              ),
            ),
          );
        },
      ),

      //BOTTOM GNAV
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
          child: GNav(
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            gap: 8,
            padding: EdgeInsets.all(15),
            tabs: [
              GButton(
                onPressed: () {
                  FirebaseAuth.instance.authStateChanges().listen((User? user) {
                    if (user == null) {
                      // If not authenticated, navigate to LoginPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    } else {
                      // If authenticated, navigate to UserProfilePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  });
                },
                text: "Ana Sayfa",
                icon: Icons.home,
              ),
              GButton(
                text: "Beğendiklerim",
                icon: Icons.favorite_border,
              ),
              GButton(
                onPressed: () {
                  FirebaseAuth.instance.authStateChanges().listen((User? user) {
                    if (user == null) {
                      // If not authenticated, navigate to LoginPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    } else {
                      // If authenticated, navigate to UserProfilePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    }
                  });
                },
                text: "Profil",
                icon: Icons.account_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
