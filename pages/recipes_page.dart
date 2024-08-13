import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whadoeat/components/categories.dart'; // RecipeCategories sınıfını import ediyoruz
import 'dart:async'; // Timer kullanımı için
import 'package:whadoeat/components/recipe_card.dart';
import 'package:whadoeat/components/category_list.dart';
import 'package:whadoeat/components/recipe_list.dart';
import 'recipe_details.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  RecipesPageState createState() => RecipesPageState();
}

class RecipesPageState extends State<RecipesPage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _cachedData = [];
  List<Map<String, dynamic>> _displayedRecipes = [];
  String _username = "";
  final List<String> _selectedCategories = [];
  final PageController _pageController = PageController();
  Timer? _timer;
  int _itemsPerPage = 30;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserData();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= _getTopRatedRecipes().length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _username = capitalize(userDoc['name'] ?? 'User');
      });
    }
  }

  void fetchData() {
    FirebaseFirestore.instance.collection("recipes").limit(200).get().then((QuerySnapshot querySnapshot) {
      List<Map<String, dynamic>> newRecipes = [];
      for (var doc in querySnapshot.docs) {
        newRecipes.add({
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
        });
      }
      setState(() {
        _cachedData = newRecipes;
        _searchResults = newRecipes;
        _displayedRecipes = _searchResults.take(_itemsPerPage).toList();
      });
    }).catchError((error) {
      //print('Error fetching recipes: $error');
    });
  }

  void veriGetir() {
    var searchTerms = _searchController.text
        .split(',')
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty)
        .toList();
    setState(() {
      _searchResults = _cachedData.where((recipe) {
        var name = recipe['name'].toLowerCase();
        return searchTerms.any((term) => name.contains(term));
      }).toList();
      _displayedRecipes = _searchResults.take(_itemsPerPage).toList();
    });
  }

  void _onSearch() {
    if (_searchController.text.isNotEmpty) {
      veriGetir();
    } else {
      setState(() {
        _searchResults = _cachedData;
        _displayedRecipes = _searchResults.take(_itemsPerPage).toList();
      });
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }

      if (_selectedCategories.isEmpty) {
        _searchResults = _cachedData;
      } else {
        _searchResults = _cachedData.where((recipe) {
          return _selectedCategories.contains(recipe['category']);
        }).toList();
      }
      _displayedRecipes = _searchResults.take(_itemsPerPage).toList();
    });
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  List<Map<String, dynamic>> _getTopRatedRecipes() {
    return _cachedData.where((recipe) => recipe['ratingPoint'] != null && recipe['userCount'] != null).toList()
      ..sort((a, b) {
        double avgRatingA = (a['ratingPoint'] ?? 0) / (a['userCount'] ?? 1);
        double avgRatingB = (b['ratingPoint'] ?? 0) / (b['userCount'] ?? 1);
        return avgRatingB.compareTo(avgRatingA);
      });
  }

  void _loadMoreRecipes() {
    if (_loadingMore) return;

    setState(() {
      _loadingMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _itemsPerPage += 50;
          _displayedRecipes = _searchResults.take(_itemsPerPage).toList();
          _loadingMore = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var topRatedRecipes = _getTopRatedRecipes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarif Ara'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Merhaba $_username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Exo2'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bugün ne yemek istersin?',
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pizza, puding, çorba diye aratabilirsin...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _onSearch(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kategoriler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CategoryList(
              categories: RecipeCategories.categories,
              selectedCategories: _selectedCategories,
              onCategoryTap: _filterByCategory,
            ),
            const SizedBox(height: 30),
            const Text(
              'En Yüksek Puanlı Tarifler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: topRatedRecipes.length,
                itemBuilder: (context, index) {
                  final result = topRatedRecipes[index];
                  double averageRating = (result['ratingPoint'] ?? 0) / (result['userCount'] ?? 1);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetails(
                            recipe: result,
                            averageRating: averageRating,
                          ),
                        ),
                      );
                    },
                    child: RecipeCard(recipe: result, averageRating: averageRating),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Tüm Tarifler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RecipeList(recipes: _displayedRecipes),
            if (_displayedRecipes.length < _searchResults.length)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _loadMoreRecipes,
                  child: const Text('Daha Fazla Yükle'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}




