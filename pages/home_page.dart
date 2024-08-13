import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whadoeat/pages/auth_page.dart';
import 'recipes_page.dart';
import 'filtering_ingridients_page.dart';
import 'recommend_by_items.dart';
import 'package:whadoeat/components/bottom_appbar.dart';
import 'package:whadoeat/components/custom_buildpage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: const Text(
          'HOŞ GELDİN!', // Change the text here
          style:
          //GoogleFonts.montserrat(),
          TextStyle(
            fontFamily: 'sans-serif', // Replace with your font family name
            fontSize: 20.0, // Adjust font size as needed
            color: Colors.black, // Set the text color
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signUserOut,
            color: Colors.black,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
              );
            }),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                CustomPage(
                  imagePath: 'lib/images/gorsel1.png',
                  subtitle: "500'DEN FAZLA TARİF!",
                  title: "BUGÜN NE YEMEK İSTERSİN?",
                  buttonText: "TARİFLERE GİT",
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RecipesPage()),
                    );
                  },
                  subtitleFontFamily: 'Akrobat-Black', // Özel yazı tipi ailesi adı
                  titleFontFamily: 'Akrobat-Black',       // Özel yazı tipi ailesi adı
                ),
                CustomPage(
                  imagePath: 'lib/images/gorsel2.png',
                  subtitle: "MUTFAĞINDA HANGİ MALZEMELER VAR?",
                  title: "NE PİŞİREBİLECEĞİNE BAKALIM!",
                  buttonText: "MALZEMELERİNİ GİR",
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IngredientsPage()),
                    );
                  },
                  subtitleFontFamily: 'Akrobat-Black', // Özel yazı tipi ailesi adı
                  titleFontFamily: 'Akrobat-Black',
                ),
                CustomPage(
                  imagePath: 'lib/images/gorsel3.png',
                  subtitle: "KARAR VEREMEDİN Mİ?",
                  title: "TERCİHLERİNE GÖRE BİZ ÖNERELİM!",
                  buttonText: "BANA TARİF ÖNER!",
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecommendByItems()),
                    );
                  },
                  subtitleFontFamily: 'Akrobat-Black', // Özel yazı tipi ailesi adı
                  titleFontFamily: 'Akrobat-Black',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}








