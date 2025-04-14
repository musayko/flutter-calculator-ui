// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart'; // Import generated options

import 'views/calculator_screen.dart';
import 'views/history_screen.dart';
import 'views/converter_screen.dart';

// Make main async to use await
void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated options file
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Sign in anonymously for this example.
  // This gives us a temporary user ID needed for Firestore rules.
  // In a real app, you'd likely have a proper login screen/flow.
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    // You can optionally print the user ID for debugging:
    print("Signed in anonymously with user: ${userCredential.user?.uid}");
  } catch (e) {
    print("Error signing in anonymously: $e");
    // Consider showing an error message to the user if sign-in fails
  }

  // Run the Flutter app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CalculatorScreen(),
        '/history': (context) => HistoryScreen(),
        '/converter': (context) => ConverterScreen(),
      },
      // Apply your theme
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
    );
  }
}
