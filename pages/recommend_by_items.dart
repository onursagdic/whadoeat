import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whadoeat/components/recipe_card.dart'; // Import the RecipeCard widget

class RecommendByItems extends StatefulWidget {
  @override
  _RecommendByItemsState createState() => _RecommendByItemsState();
}

class _RecommendByItemsState extends State<RecommendByItems> {
  List<Map<String, dynamic>> _recommendations = [];

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchRecipes(user.uid);
    }
  }

  Future<void> fetchRecipes(String userId) async {
    var url = Uri.parse('http://192.168.162.128/recommend?user_id=$userId');

    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);

        if (data is Map && data.containsKey('recommended_recipes')) {
          setState(() {
            _recommendations = List<Map<String, dynamic>>.from(data['recommended_recipes']);
          });
        } else {
          setState(() {
            _recommendations = [];
            _showErrorDialog('Unexpected data format.');
          });
        }
      } else {
        setState(() {
          _recommendations = [];
          _showErrorDialog('Failed to load recipes. Status code: ${response.statusCode}');
        });
      }
    } catch (e) {
      setState(() {
        _recommendations = [];
        _showErrorDialog('Error occurred while fetching recipes: $e');
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Önerilen Tarifler",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: user != null
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: _recommendations.isNotEmpty
            ? ListView.builder(
          itemCount: _recommendations.length,
          itemBuilder: (context, index) {
            var recipe = _recommendations[index];
            double averageRating = (recipe['ratingPoint'] ?? 0) / (recipe['userCount'] ?? 1);
            return RecipeCard(recipe: recipe, averageRating: averageRating);
          },
        )
            : const Center(child: CircularProgressIndicator()),
      )
          : const Center(child: Text('No user is currently signed in.')),
    );
  }
}

