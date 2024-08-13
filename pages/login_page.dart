import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whadoeat/main.dart';
import 'package:whadoeat/pages/home_page.dart';
import 'package:whadoeat/pages/profile_page.dart';
import 'register_page.dart';
import 'package:whadoeat/components/my_button.dart';
import 'package:whadoeat/components/my_textfield.dart';
//import 'package:whadoeat/components/square_tile.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //final nameController = TextEditingController(); // Add controller for name field

  Future<void> signUserIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      if (userCredential.user != null) {
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Navigate to the user profile page
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
        else {
          const snackBar = SnackBar(
            content:
            Text('Sign in failed. Please check your email and password.'),
          );

          // Find the Scaffold in the widget tree and use it to show a SnackBar
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text(
            'Giriş yapılamadı. Lütfen e-mail ve şifrenizi kontrol edin.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.lime[200],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'WHADOEAT!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Georgia",
                    ),
                  ),
                  const Text(
                    'Hoşgeldin, Hadi Giriş Yap!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Georgia",
                    ),
                  ),
                  const SizedBox(height: 25),

                  const SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: 'E-mail',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Şifre',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    text: "Giriş Yap",
                    onTap: signUserIn,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Üye değil misin?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Kayıt Ol!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }



/*class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      //pop the loading circle
    }  catch (e) {
      // Handle sign-in errors here
      // Show a SnackBar with the error message
      const snackBar = SnackBar(
        content: Text('Giriş yapılamadı. Lütfen e-mail ve şifrenizi kontrol edin.'),
      );

      // Find the Scaffold in the widget tree and use it to show a SnackBar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lime[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo


                const SizedBox(height: 30),

                // welcome back, you've been missed!
                const Text(
                  'WHADOEAT!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Georgia",
                  ),
                ),

                const Text(
                  'Hoşgeldin, Hadi Giriş Yap!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Georgia",
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Şifre',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Şifreni mi unuttun?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: "Giriş Yap",
                  onTap: signUserIn,
                ),

                const SizedBox(height: 20),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // google + apple sign in buttons


                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Üye değil misin?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Kayıt Ol!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
