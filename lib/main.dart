import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Start screen// Start screen// Start screen// Start screen// Start screen// Start screen// Start screen// Start screen// Start screen
      home: LoginScreen(),

      // (optional future use for navigation system)
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}