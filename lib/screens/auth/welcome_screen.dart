// ===========================
// welcome_screen.dart
// ===========================

import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import '../widgets/social_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [
              const Text(
                "Let's Get Started!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Let's dive into your account",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 60),

              SocialButton(
                icon: Icons.g_mobiledata,
                text: "Continue with Google",
                onTap: () {},
              ),

              const SizedBox(height: 16),

              SocialButton(
                icon: Icons.apple,
                text: "Continue with Apple",
                onTap: () {},
              ),

              const SizedBox(height: 16),

              SocialButton(
                icon: Icons.facebook,
                text: "Continue with Facebook",
                onTap: () {},
              ),

              const SizedBox(height: 16),

              SocialButton(
                icon: Icons.flutter_dash,
                text: "Continue with Twitter",
                onTap: () {},
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SignupScreen(),
                      ),
                    );
                  },

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFF4F2DD),

                    foregroundColor:
                    const Color(0xFF5E8748),

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text("Sign Up"),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const LoginScreen(),
                      ),
                    );
                  },

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFF4F2DD),

                    foregroundColor:
                    const Color(0xFF5E8748),

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text("Sign In"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}