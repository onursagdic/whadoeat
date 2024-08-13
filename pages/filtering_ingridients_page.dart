import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whadoeat/components/recipe_list.dart';
//import 'package:whadoeat/components/bottom_appbar.dart';

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  // Arama metni için TextEditingController oluşturuyoruz
  final _searchController = TextEditingController();

  // Arama sonuçlarını ve önbellekteki verileri tutmak için listeler tanımlıyoruz
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _cachedData = [];

  // Bilgilendirme mesajı için SnackBar oluşturuyoruz
  final _snackBar = const SnackBar(
    content: Text('Elinizdeki malzemeleri "tavuk göğüs, haşlanmış patates, soğan, sıvı yağ, ..." gibi virgülle ayırarak yazın.'),
    duration: Duration(seconds: 10), // SnackBar'ın gösterim süresini belirliyoruz
  );

  @override
  void initState() {
    super.initState();
    fetchData(); // Sayfa yüklendiğinde veri çekme fonksiyonunu çağırıyoruz
    // Sayfa yüklendiğinde sadece bir kez SnackBar'ı göstermek için
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    // });
  }

  // Firestore'dan tarif verilerini çeken fonksiyon
  void fetchData() {
    FirebaseFirestore.instance
        .collection("recipes")
        .limit(500) // En fazla 50 tarif çekiyoruz
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _cachedData.clear(); // Önbellekteki verileri temizliyoruz
        querySnapshot.docs.forEach((doc) {
          _cachedData.add({
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
        });
      });
    });
  }

  // Arama kutusuna girilen malzemelere göre verileri filtreleyen fonksiyon
  void veriGetir() {
    var searchIngredients = _searchController.text.split(',')
        .map((item) => item.trim().toLowerCase()) // Kullanıcı girdisini temizle ve küçük harfe çevir.
        .where((item) => item.isNotEmpty) // Boş girdileri kaldır.
        .toList();

    setState(() {
      if (searchIngredients.isNotEmpty) {
        _searchResults.clear(); // Arama sonuçlarını temizliyoruz
        for (var recipe in _cachedData) {
          var ingredientNames = List<String>.from(recipe['ingredientNames'])
              .map((name) => name.toLowerCase())
              .toList();

          // Tüm arama malzemelerinin tarifin içeriğinde olup olmadığını kontrol ediyoruz
          bool containsAllIngredients = searchIngredients.every(
                  (ingredient) => ingredientNames.any((name) => name.contains(ingredient))
          );
          if (containsAllIngredients) {
            _searchResults.add(recipe); // Malzemeleri içeren tarifleri arama sonuçlarına ekliyoruz
          }
        }
        _searchResults = _searchResults.take(20).toList(); // Sonuç sayısını sınırla
      } else {
        _searchResults.clear();  // Arama metni boş ise sonuçları temizle
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Malzemelerini Gir!",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(_snackBar); // Bilgilendirme mesajını göster
            },
            icon: const Icon(Icons.info),
            tooltip: 'Bilgi', // Tooltip bilgisi
          ),
        ],
      ),
      body: _cachedData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController, // Arama metni denetleyicisi
                decoration: const InputDecoration(
                  hintText: 'Elinizdeki malzemeleri girin.', // Placeholder text
                  border: OutlineInputBorder(), // Kenarlık stili
                ),
                onChanged: (text) => veriGetir(), // TextField değiştiğinde aramayı tetikle
              ),
            ),
            RecipeList(recipes: _searchResults),
          ],
        ),
      ),

      // BOTTOM NAV
      //bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
