import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whadoeat/components/custom_buildpage.dart';
import 'rating_page.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetails extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final double averageRating;

  RecipeDetails({Key? key, required this.recipe, required this.averageRating}) : super(key: key);

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
    addToHistory();
  }

  void checkIfFavorite() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .where('recipeId', isEqualTo: widget.recipe['id'])
          .get();
      setState(() {
        isFavorited = querySnapshot.docs.isNotEmpty;
      });
    }
  }

  void addToHistory() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var lastViewedSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('history')
          .orderBy('viewedAt', descending: true)
          .limit(1)
          .get();

      var lastViewedRecipeId = lastViewedSnapshot.docs.isNotEmpty
          ? lastViewedSnapshot.docs.first.data()['recipeId']
          : null;

      if (lastViewedRecipeId != widget.recipe['id']) {
        var timestamp = DateTime.now();
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('history')
            .add({'recipeId': widget.recipe['id'], 'viewedAt': timestamp});
      }
    }
  }

  void setFavorite() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      var querySnapshot = await favoritesCollection
          .where('recipeId', isEqualTo: widget.recipe['id'])
          .get();

      FirebaseFirestore.instance.runTransaction((transaction) async {
        if (querySnapshot.docs.isNotEmpty) {
          transaction.delete(querySnapshot.docs.first.reference);
        } else {
          transaction.set(favoritesCollection.doc(), {'recipeId': widget.recipe['id']});
        }
      }).then((_) {
        setState(() {
          isFavorited = !isFavorited;
        });
      }).catchError((error) {
        print("Error updating favorite status: $error");
      });
    }
  }

  void navigateToRatingPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingPage(recipeId: widget.recipe['id']),
      ),
    );
    if (result == true) {
      // Oylama sonrası tarifi yeniden yükle
      setState(() {
        fetchRecipeDetails();
      });
    }
  }

  void fetchRecipeDetails() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipe['id'])
        .get();

    setState(() {
      widget.recipe['ratingPoint'] = docSnapshot['ratingPoint'];
      widget.recipe['userCount'] = docSnapshot['userCount'];
    });
  }

  void shareRecipe() {
    final recipeName = widget.recipe['name'];
    final recipeDetails = widget.recipe['details'].join("\n");
    final shareText = 'Şu tarife bir göz at! : $recipeName\n\n$recipeDetails';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final preparationSteps = widget.recipe['preparation'] as List<dynamic>;
    double averageRating = (widget.recipe['ratingPoint'] ?? 0) / (widget.recipe['userCount'] ?? 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tariflere Dön', style: TextStyle(color: Colors.black,)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: setFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            color: Colors.amber,
            onPressed: navigateToRatingPage,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            color: Colors.black,
            onPressed: shareRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.recipe['image'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.recipe['image'],
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Resim yüklenemedi', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'TCCEB'));
                    },
                  ),
                ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe['name'],
                          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: 'Exo2'),
                          softWrap: true,
                        ),
                        Text(
                          widget.recipe['category'] ?? "Kategori bilgisi yok.",
                          style: const TextStyle(fontSize: 16.0, color: Colors.grey,),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0), // Add some space between the columns
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.star, color: Colors.amber),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoBox(
                    title: 'PORSİYON:',
                    content: preparationSteps.isNotEmpty ? preparationSteps[0] : '',
                    //fontFamily: 'TCCEB',
                  ),
                  InfoBox(
                    title: 'HAZIRLAMA SÜRESİ:',
                    content: preparationSteps.length > 1 ? preparationSteps[1] : '',
                    //fontFamily: 'TCCEB',
                  ),
                  InfoBox(
                    title: 'PİŞİRME SÜRESİ:',
                    content: preparationSteps.length > 2 ? preparationSteps[2] : '',
                    //fontFamily: 'TCCEB',
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Malzemeler:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Exo2'),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (widget.recipe['ingredients'] as List<dynamic>).length,
                itemBuilder: (context, index) {
                  return Text(
                    "• " + (widget.recipe['ingredients'] as List<dynamic>)[index],
                    style: const TextStyle(fontSize: 16.0,),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Hazırlanışı:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Exo2'),
              ),
              const SizedBox(height: 10),
              Text(
                (widget.recipe['details'] as List<dynamic>).join("\n"),
                style: const TextStyle(fontSize: 16.0,),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}


