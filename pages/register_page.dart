import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whadoeat/components/my_button.dart';
import 'package:whadoeat/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController(); // Add controller for name field

  // sign user up method
  Future<void> signUserUp() async {
    //try creating the user
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // You can update the user's display name with the provided name
      await userCredential.user!.updateDisplayName(nameController.text);

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text,
        'email': emailController.text,
        // Add other user-specific fields as needed
      });
      print(userCredential.user!.uid);
      // Check if passwords match
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Optionally, you can also save the user's name to Firestore or any other database
        String userName = nameController.text;
        print('User name: $userName');
      }

      else {
        //if not then show error
        const snackBar = SnackBar(
          content: Text('Şifreleriniz uyuşmuyor.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // Handle sign-in errors here
      // Show a SnackBar with the error message
      const snackBar = SnackBar(
        content: Text('Giriş yapılamadı. Lütfen e-mail ve şifrenizi kontrol edin.'),
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
                  'Bilgilerinle bu sayfadan kayıt olabilirsin!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Georgia",
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: nameController,
                  hintText: 'Adınız',
                  obscureText: false,
                ),
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
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Şifreni Onayla',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Kayit Ol",
                  onTap: signUserUp,
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
                      const SizedBox(height: 20),
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
                      'Zaten Üye Misin?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Giriş Ekranına Dön',
                        style: TextStyle(
                          color: Colors.red,
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



/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whadoeat/components/my_button.dart';
import 'package:whadoeat/components/my_textfield.dart';
//import 'package:whadoeat/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {


    //try creating the user
    try {
      //password matches?
        if(passwordController.text == confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
          );
        }
        else {
          //if not then show error
          const snackBar = SnackBar(
          content: Text('Şifreleriniz uyuşmuyor.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
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
                  'Bilgilerinle bu sayfadan kayıt olabilirsin!',
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
                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Şifreni Onayla',
                  obscureText: true,
                ),



                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: "Kayit Ol",
                  onTap: signUserUp,
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
                      const SizedBox(height: 20),
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
                      'Zaten Üye Misin?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Giriş Ekranına Dön',
                        style: TextStyle(
                          color: Colors.red,
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
*/
