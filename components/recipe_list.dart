import 'package:flutter/material.dart';
import 'recipe_card.dart';
import 'package:whadoeat/pages/recipe_details.dart';

class RecipeList extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  RecipeList({required this.recipes});

  double _calculateAverageRating(int ratingPoint, int userCount) {
    if (userCount == 0) return 0.0;
    return ratingPoint / userCount;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final result = recipes[index];
        double averageRating = _calculateAverageRating(
          result['ratingPoint'] ?? 0,
          result['userCount'] ?? 0,
        );

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
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (result['image'] != null)
                    SizedBox(
                      width: 90,
                      height: 87,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.0),
                        child: Image.network(
                          result['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Icon(Icons.restaurant),
                    ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['name'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Exo2',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(result['category']),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
