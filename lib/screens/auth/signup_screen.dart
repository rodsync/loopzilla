import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../onboarding/question_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {

  final TextEditingController
  usernameController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  final TextEditingController
  confirmPasswordController =
  TextEditingController();

  @override
  void dispose() {

    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 40),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Start your productivity journey.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),

                TextField(
                  controller:
                  usernameController,

                  decoration: InputDecoration(
                    hintText: "Username",

                    filled: true,
                    fillColor:
                    Colors.grey.shade100,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20),

                      borderSide:
                      BorderSide.none,
                    ),

                    contentPadding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller:
                  emailController,

                  decoration: InputDecoration(
                    hintText: "Email",

                    filled: true,
                    fillColor:
                    Colors.grey.shade100,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20),

                      borderSide:
                      BorderSide.none,
                    ),

                    contentPadding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller:
                  passwordController,

                  obscureText: true,

                  decoration: InputDecoration(
                    hintText: "Password",

                    filled: true,
                    fillColor:
                    Colors.grey.shade100,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20),

                      borderSide:
                      BorderSide.none,
                    ),

                    contentPadding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller:
                  confirmPasswordController,

                  obscureText: true,

                  decoration: InputDecoration(
                    hintText:
                    "Confirm Password",

                    filled: true,
                    fillColor:
                    Colors.grey.shade100,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          20),

                      borderSide:
                      BorderSide.none,
                    ),

                    contentPadding:
                    const EdgeInsets
                        .symmetric(
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

                      final username =
                      usernameController
                          .text
                          .trim();

                      final email =
                      emailController.text
                          .trim();

                      final password =
                      passwordController
                          .text
                          .trim();

                      final confirmPassword =
                      confirmPasswordController
                          .text
                          .trim();

                      if (username.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword
                              .isEmpty) {

                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please fill all fields",
                            ),
                          ),
                        );

                        return;
                      }

                      if (password !=
                          confirmPassword) {

                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Passwords do not match",
                            ),
                          ),
                        );

                        return;
                      }

                      try {

                        final usernameCheck =
                        await FirebaseFirestore
                            .instance
                            .collection(
                            'users')
                            .where(
                          'username',
                          isEqualTo:
                          username,
                        )
                            .get();

                        if (usernameCheck
                            .docs
                            .isNotEmpty) {

                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Username already exists",
                              ),
                            ),
                          );

                          return;
                        }

                        UserCredential
                        userCredential =
                        await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password:
                          password,
                        );

                        String uid =
                            userCredential
                                .user!
                                .uid;

                        await FirebaseFirestore
                            .instance
                            .collection(
                            'users')
                            .doc(uid)
                            .set({

                          'uid': uid,

                          'username':
                          username,

                          'email': email,

                          'onboardingDone':
                          false,

                          'createdAt':
                          Timestamp.now(),
                        });

                        if (!context.mounted)
                          return;

                        Navigator
                            .pushReplacement(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                QuestionScreen(),
                          ),
                        );

                      } on FirebaseAuthException
                      catch (e) {

                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              e.message ??
                                  "Signup failed",
                            ),
                          ),
                        );

                      } catch (e) {

                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
                    },

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                          0xFF5E8748),

                      padding:
                      const EdgeInsets
                          .symmetric(
                        vertical: 18,
                      ),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(20),
                      ),
                    ),

                    child: const Text(
                      "Create Account",

                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () {

                      Navigator.pop(
                          context);
                    },

                    child: const Text(
                      "Already have an account? Login",

                      style: TextStyle(
                        color: Color(
                            0xFF5E8748),

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}