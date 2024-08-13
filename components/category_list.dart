import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(String) onCategoryTap;

  CategoryList({required this.categories, required this.selectedCategories, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategories.contains(category);
          return GestureDetector(
            onTap: () => onCategoryTap(category),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white, // İç kısım beyaz
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.grey, // Dış çerçeve seçili ise mor, değilse gri
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.purple : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
