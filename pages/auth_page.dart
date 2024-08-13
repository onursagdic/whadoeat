import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whadoeat/pages/home_page.dart';
import 'package:whadoeat/pages/login_or_register_page.dart';
import 'package:whadoeat/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if(snapshot.hasData){
            return HomePage();
          }
          else {
            return LoginOrRegisterPage();
          }//user logged out
        },
      ),
    );
  }
}
