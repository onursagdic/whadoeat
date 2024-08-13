import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingPage extends StatefulWidget {
  final String recipeId;

  RatingPage({required this.recipeId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _rating = 0;
  bool hasRated = false;

  @override
  void initState() {
    super.initState();
    checkIfRated();
  }

  void checkIfRated() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('ratedRecipes')
          .where('recipeId', isEqualTo: widget.recipeId)
          .get();
      setState(() {
        hasRated = querySnapshot.docs.isNotEmpty;
      });
    }
  }

  void submitRating() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && _rating > 0) {
      var recipeRef = FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        var snapshot = await transaction.get(recipeRef);

        if (snapshot.exists) {
          int currentRating = snapshot['ratingPoint'] ?? 0;
          int userCount = snapshot['userCount'] ?? 0;

          transaction.update(recipeRef, {
            'ratingPoint': currentRating + _rating,
            'userCount': userCount + 1,
          });

          var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
          transaction.set(userRef.collection('ratedRecipes').doc(), {
            'recipeId': widget.recipeId,
          });
        }
      }).then((_) {
        Navigator.pop(context, true);
      }).catchError((error) {
        print("Error submitting rating: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifi Oyla'),
      ),
      body: hasRated
          ? Center(child: Text('Bu tarife zaten oy verdiniz.'))
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Tarifi Oylayın', style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: submitRating,
            child: Text('Oy Ver'),
          ),
        ],
      ),
    );
  }
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingPage extends StatefulWidget {
  final String recipeId;

  RatingPage({required this.recipeId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _rating = 0;
  bool hasRated = false;

  @override
  void initState() {
    super.initState();
    checkIfRated();
  }

  void checkIfRated() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('ratedRecipes')
          .where('recipeId', isEqualTo: widget.recipeId)
          .get();
      setState(() {
        hasRated = querySnapshot.docs.isNotEmpty;
      });
    }
  }

  void submitRating() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && _rating > 0) {
      var recipeRef = FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        var snapshot = await transaction.get(recipeRef);

        if (snapshot.exists) {
          int currentRating = snapshot['ratingPoint'] ?? 0;
          int userCount = snapshot['userCount'] ?? 0;

          transaction.update(recipeRef, {
            'ratingPoint': currentRating + _rating,
            'userCount': userCount + 1,
          });

          var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
          transaction.set(userRef.collection('ratedRecipes').doc(widget.recipeId), {
            'recipeId': widget.recipeId,
            'rating': _rating,
          });
        }
      }).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        print("Error submitting rating: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifi Oyla'),
      ),
      body: hasRated
          ? Center(child: Text('Bu tarife zaten oy verdiniz.'))
          : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text('Tarifi Oylayın', style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: submitRating,
            child: Text('Oy Ver'),
          ),
        ],
      ),
    );
  }
}
*/
