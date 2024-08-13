import 'package:flutter/material.dart';
import 'package:whadoeat/pages/recipe_details.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> recipeData;

  HistoryList({required this.recipeData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recipeData.length,
      itemBuilder: (context, index) {
        var recipe = recipeData[index];
        double averageRating = (recipe['ratingPoint'] ?? 0) / (recipe['userCount'] ?? 1);

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
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (recipe['image'] != null)
                    SizedBox(
                      width: 90,
                      height: 87,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.0),
                        child: Image.network(
                          recipe['image'],
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
                          recipe['name'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(recipe['category']),
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
