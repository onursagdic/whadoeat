import 'package:flutter/material.dart';
import 'package:whadoeat/pages/recipe_details.dart';

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final double averageRating;

  RecipeCard({required this.recipe, required this.averageRating});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(recipe: recipe, averageRating: averageRating),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (recipe['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        recipe['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 140,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Resim yüklenemedi', textAlign: TextAlign.center);
                        },
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['name'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Exo2',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      recipe['category'] ?? "Kategori bilgisi yok.",
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
