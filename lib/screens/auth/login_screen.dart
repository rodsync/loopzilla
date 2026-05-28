import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'signup_screen.dart';
import '../onboarding/question_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 40),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Login to continue your habit journey.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 50),

              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  hintText: "Email",

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(20),

                    borderSide: BorderSide.none,
                  ),

                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "Password",

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(20),

                    borderSide: BorderSide.none,
                  ),

                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () async {
                    final email =
                    emailController.text.trim();

                    final password =
                    passwordController.text.trim();

                    if (email.isEmpty ||
                        password.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please fill all fields"),
                        ),
                      );

                      return;
                    }

                    try {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      String uid =
                          FirebaseAuth.instance
                              .currentUser!
                              .uid;

                      DocumentSnapshot userDoc =
                      await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(uid)
                          .get();

                      bool onboardingDone =
                          userDoc['onboardingDone']
                              ?? false;

                      if (onboardingDone) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuestionScreen(),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      String message = "Login failed";

                      if (e.code == 'user-not-found') {
                        message = "No account found with this email";
                      }

                      else if (e.code == 'wrong-password') {
                        message = "Incorrect password";
                      }

                      else if (e.code == 'invalid-email') {
                        message = "Invalid email address";
                      }

                      else if (e.code == 'invalid-credential') {
                        message = "Incorrect email or password";
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF5E8748),

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text(
                    "Login",

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Center(
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Text(
                      "Don't have an account?",
                    ),

                    TextButton(
                      onPressed: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const SignupScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Sign Up",

                        style: TextStyle(
                          color:
                          Color(0xFF5E8748),

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}