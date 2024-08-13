import 'package:flutter/material.dart';

class ReadOnlyTextField extends StatelessWidget {
  final String label;
  final String value;

  ReadOnlyTextField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(height: 5),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: value,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:whadoeat/pages/recipe_details.dart';

class ReadOnlyTextField extends StatelessWidget {
  final String label;
  final String value;

  ReadOnlyTextField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18), // Yazı boyutu büyütüldü
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      readOnly: true,
      style: TextStyle(fontSize: 18), // Yazı boyutu büyütüldü
    );
  }
}

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> recipeData;

  HistoryList({required this.recipeData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          'Geçmiş:',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Divider(thickness: 1.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recipeData.length,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(recipeData[index]['name'], style: TextStyle(fontSize: 18.0)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetails(recipe: recipeData[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}*/
