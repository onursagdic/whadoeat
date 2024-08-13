import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:whadoeat/pages/home_page.dart';
import 'package:whadoeat/pages/favorites.dart';
import 'package:whadoeat/pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.purple,
            color: Colors.black,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Ana Sayfa',
                onPressed: () {
                  if (currentIndex != 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favoriler',
                onPressed: () {
                  if (currentIndex != 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesPage()),
                    );
                  }
                },
              ),
              GButton(
                icon: Icons.person,
                text: 'Profil',
                onPressed: () {
                  if (currentIndex != 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  }
                },
              ),
            ],
            selectedIndex: currentIndex,
          ),
        ),
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:whadoeat/pages/home_page.dart';
import 'package:whadoeat/pages/favorites.dart';
import 'package:whadoeat/pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // BottomAppBar yüksekliğini ayarlamak için burayı değiştirin
      child: BottomAppBar(
        //color: Colors.orangeAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, size: 25,),
              color: currentIndex == 0 ? Colors.blue : Colors.black,
              onPressed: () {
                if (currentIndex != 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite, size: 25,),
              color: currentIndex == 1 ? Colors.blue : Colors.black,
              onPressed: () {
                if (currentIndex != 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.person, size: 25,),
              color: currentIndex == 2 ? Colors.blue : Colors.black,
              onPressed: () {
                if (currentIndex != 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
