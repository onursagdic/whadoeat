import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whadoeat/components/bottom_appbar.dart';
import 'package:whadoeat/components/pfp_build.dart';
import 'package:whadoeat/components/history_list.dart'; // HistoryList bileşenini import et

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  List<Map<String, dynamic>> recipeData = []; // Tarif verilerini tutmak için liste
  bool _historyLoaded = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    _user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  void _loadHistory() {
    if (_user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('history')
          .get()
          .then((QuerySnapshot historySnapshot) {
        List<String> ids = historySnapshot.docs.map((doc) => doc['recipeId'].toString()).toList();
        _getRecipesFromIds(ids);
      });
    }
  }

  void _getRecipesFromIds(List<String> ids) async {
    List<Map<String, dynamic>> recipes = [];
    for (String id in ids) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          recipes.add(documentSnapshot.data() as Map<String, dynamic>);
        }
      });
    }
    setState(() {
      recipeData = recipes;
      _historyLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profilim'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/images/cupek.jpg'), // Profil fotoğrafı burada güncellenmeli
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Fotoğrafı Düzenle',
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ReadOnlyTextField(label: 'Full name', value: _user?.displayName ?? ''),
              const SizedBox(height: 20),
              ReadOnlyTextField(label: 'Email', value: _user?.email ?? ''),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Şifreni Değiştir',
                      style: TextStyle(color: Colors.purple, fontSize: 18),
                    ),
                    Icon(Icons.arrow_right, color: Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loadHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // primary yerine backgroundColor kullanıldı
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Geçmişi Görüntüle',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _historyLoaded ? HistoryList(recipeData: recipeData) : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}





/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whadoeat/components/bottom_appbar.dart';
import 'package:whadoeat/components/pfp_build.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  List<Map<String, dynamic>> recipeData = []; // Tarif verilerini tutmak için liste
  bool _historyLoaded = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    _user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  void _loadHistory() {
    if (_user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('history')
          .get()
          .then((QuerySnapshot historySnapshot) {
        List<String> ids = historySnapshot.docs.map((doc) => doc['recipeId'].toString()).toList();
        _getRecipesFromIds(ids);
      });
    }
  }

  void _getRecipesFromIds(List<String> ids) async {
    List<Map<String, dynamic>> recipes = [];
    for (String id in ids) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          recipes.add(documentSnapshot.data() as Map<String, dynamic>);
        }
      });
    }
    setState(() {
      recipeData = recipes;
      _historyLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profilim'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/images/cupek.jpg'), // Profil fotoğrafı burada güncellenmeli
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Fotoğrafı Düzenle',
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ReadOnlyTextField(label: 'Full name', value: _user?.displayName ?? ''),
              const SizedBox(height: 20),
              ReadOnlyTextField(label: 'Email', value: _user?.email ?? ''),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Şifreni Değiştir',
                      style: TextStyle(color: Colors.purple, fontSize: 18),
                    ),
                    Icon(Icons.arrow_right, color: Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loadHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // primary yerine backgroundColor kullanıldı
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Geçmişi Görüntüle',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _historyLoaded ? HistoryList(recipeData: recipeData) : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}

*/

/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whadoeat/components/bottom_appbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  List<String> recipeNames = [];
  bool _historyLoaded = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    _user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  void _loadHistory() {
    if (_user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('history')
          .get()
          .then((QuerySnapshot historySnapshot) {
        List<String> ids = historySnapshot.docs.map((doc) => doc['recipeId'].toString()).toList();
        _getRecipesFromIds(ids);
      });
    }
  }

  void _getRecipesFromIds(List<String> ids) async {
    List<String> names = [];
    for (String id in ids) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          names.add(documentSnapshot['name']);
        }
      });
    }
    setState(() {
      recipeNames = names;
      _historyLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/images/cupek.jpg'), // Profil fotoğrafı burada güncellenmeli
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Fotoğrafı Düzenle',
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              _buildReadOnlyTextField(label: 'İsim', value: _user?.displayName ?? ''),
              SizedBox(height: 20),
              _buildReadOnlyTextField(label: 'Email', value: _user?.email ?? ''),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Şifre Değiştir',
                      style: TextStyle(color: Colors.purple, fontSize: 18),
                    ),
                    Icon(Icons.arrow_right, color: Colors.purple),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loadHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, //primary yerine backgroundColor kullanıldı
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                child: Text(
                  'Geçmişi Görüntüle',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              _historyLoaded ? _buildHistoryList() : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHistoryList() {
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
          itemCount: recipeNames.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(recipeNames[index], style: TextStyle(fontSize: 18.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyTextField({required String label, required String value}) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 22), // Yazı boyutu büyütüldü
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

extension StringExtensions on String {
  String capitalizeFirstLetter() {
    return this[0].toUpperCase() + this.substring(1);
  }
}*/




/*class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, User? user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();

  }
  void initState() {
    super.initState();
    _getUserInfo();
  }
  String _capitalizeFirstLetter(String? input) {
    if (input == null || input.isEmpty) {
      return input ?? "";
    }

    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
  Future<void> _getUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Hoş geldin!",
          style: TextStyle(
            color: Colors.black,
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
      body: user != null
          ? Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              'İsim:  ${user != null ? _capitalizeFirstLetter(user!.displayName) : "No name has been found."}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Text(
              'E-posta: ${user!.email ?? "Bilinmiyor"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Text(
              'Kullanıcı ID: ${user!.uid}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),

      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 9.0),
          child: GNav(

//backgroundColor: Colors.grey,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            gap: 8,
            padding: EdgeInsets.all(15),
            tabs: [
              GButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  text: "Ana Sayfa",
                  icon: Icons.home
              ),
              GButton(
                  text: "Beğendiklerim",
                  icon: Icons.favorite_border
              ),
              GButton(
                  onPressed: () {
                  },
                  text: "Profil",
                  icon: Icons.account_circle_rounded
              ),
              GButton(
                  text: "Ayarlar",
                  icon: Icons.settings
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/




/*class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CurrentUser? _currentUser; // Değişen tip

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _currentUser = CurrentUser(
              uid: user.uid,
              email: user.email ?? '',
              displayName: (documentSnapshot.data() as Map<String, dynamic>)['displayName'] ?? '',

            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sayfası'),
      ),
      body: Center(
        child: _currentUser != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Kullanıcı ID: ${_currentUser!.uid}'),
            Text('E-mail: ${_currentUser!.email}'),
            Text('Ad: ${_currentUser!.displayName}'),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }

}
*/









/*class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sayfası'),
      ),
      body: Center(
        child: _currentUser != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Kullanıcı ID: ${_currentUser!.uid}'),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var userData = snapshot.data as Map<String, dynamic>;
                return Column(
                  children: [
                    Text('E-mail: ${userData['email']}'),
                    Text('Ad: ${userData['displayName']}'),
                  ],
                );
              },
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),

      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 9.0),
          child: GNav(

//backgroundColor: Colors.grey,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            gap: 8,
            padding: EdgeInsets.all(15),
            tabs: [
              GButton(
                  text: "Ana Sayfa",
                  icon: Icons.home
              ),
              GButton(
                  text: "Beğendiklerim",
                  icon: Icons.favorite_border
              ),
              GButton(
                  onPressed: () {

                  },
                  text: "Profil",
                  icon: Icons.account_circle_rounded
              ),
              GButton(
                  text: "Ayarlar",
                  icon: Icons.settings
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/





/*class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Placeholder user information (replace with actual data fetching logic)
  String name = getNameFromFirestore();
  String email = "email@example.com";

  // Düzenleme modu için flag
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      // Bottom navigation bar
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
          child: GNav(
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            gap: 8,
            padding: const EdgeInsets.all(15),
            tabs: [
              GButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                text: "Ana Sayfa",
                icon: Icons.home,
              ),
              GButton(
                text: "Beğendiklerim",
                icon: Icons.favorite_border,
              ),
              GButton(
                text: "Profil",
                icon: Icons.account_circle_rounded,
              ),
              GButton(
                text: "Ayarlar",
                icon: Icons.settings,
              ),
            ],
          ),
        ),
      ),

      // App bar
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Profilim",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      // User information and edit button
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Profile picture (add your implementation here)

            // Username
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: 'İsim',
                  //initialValue: username,
                ),
              ),
            ),

            // Password (hidden)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: isEditing,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                ),
              ),
            ),

            // Email
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: isEditing,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  //initialValue: email,
                ),
              ),
            ),

            // Düzenle ve Kaydet butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  child: Text('Düzenle'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Bilgileri güncelleme işlemi
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: Text('Kaydet'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Future<String> getNameFromFirestore() async {
  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('your_collection').get();
    if (querySnapshot.docs.isNotEmpty) {
      // Firestore'dan alınan ilk belgenin 'name' alanını döndür
      return querySnapshot.docs.first['name'] as String;
    } else {
      return ''; // Firestore'da belge bulunamadıysa boş bir string döndür
    }
  } catch (e) {
    print('Error: $e');
    return ''; // Hata durumunda boş bir string döndür
  }
}*/


/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      //gbuttons on the bottom
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 9.0),
          child: GNav(

            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            gap: 8,
            padding: const EdgeInsets.all(15),
            tabs: [
              GButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  text: "Ana Sayfa",
                  icon: Icons.home
              ),
              GButton(
                  text: "Beğendiklerim",
                  icon: Icons.favorite_border
              ),
              GButton(
                  //onPressed: () {
                    //Navigator.pushReplacement(
                      //context,
                      //MaterialPageRoute(builder: (context) => const ProfilePage()),
                    //);
                  //}
                  text: "Profil",
                  icon: Icons.account_circle_rounded
              ),
              GButton(
                  text: "Ayarlar",
                  icon: Icons.settings
              ),
            ],
          ),
        ),
      ),


      //logout button and top bar
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          "Profilim",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      //center buttons
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {


              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Customize shape here
                ),
                minimumSize: Size(200, 100), // Customize size here
              ),
              child: const Text("TARİFLER"),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {


              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Customize shape here
                ),
                minimumSize: Size(200, 100), // Customize size here
              ),
              child: const Text("BUGÜN NE YESEM"),


            ),
          ],
        ),
      ),
    );
  }
}
*/
