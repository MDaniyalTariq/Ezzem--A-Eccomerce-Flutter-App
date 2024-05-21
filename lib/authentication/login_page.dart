import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezzem/components/custome_components/my_buttom.dart';
import 'package:ezzem/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ezzem/components/custome_components/my_textfield.dart';
import 'package:ezzem/components/custome_components/square_tile.dart';
import 'package:ezzem/services/auth_services.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  LoginPage({Key? key, required this.onTap})
      : super(key: key); 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      saveUserDataToFirestore(); 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainWidget()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      genericErrorMessage(context, e.code);
    }
  }

  void saveUserDataToFirestore() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      String? userId = FirebaseAuth.instance.currentUser?.uid; 
      if (userEmail != null && userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': userEmail,
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .doc('dummy')
            .set({}); 
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('history')
            .doc('dummy')
            .set({}); 

        print('User data saved successfully to Firestore');
      }
    } catch (e) {
      print('Error saving user data to Firestore: $e');
    }
  }

  void genericErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                const Icon(
                  Icons.lock_person,
                  size: 150,
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome back you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Username or email',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 15),
                MyButton(
                  onTap: () => signUserIn(context), 
                  text: 'Sign In',
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot your login details? ',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Text(
                        'Get help logging in.',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/icons/google.svg',
                      height: 70,
                    ),
                    SizedBox(width: 20),
                    SquareTile(
                      onTap: () {},
                      imagePath: 'lib/icons/Vector.svg',
                      height: 70,
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
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
