import 'package:flutter/material.dart';
import 'views/calculator_screen.dart';
import 'views/history_screen.dart';    
import 'views/converter_screen.dart'; 

void main() {
  // Ensure Flutter bindings are initialized if using plugins before runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Use initialRoute instead of home
      initialRoute: '/',
      // Define the routes for named navigation
      routes: {
        '/': (context) => CalculatorScreen(),    // Calculator screen is the home route
        '/history': (context) => HistoryScreen(),    
        '/converter': (context) => ConverterScreen(),  
      },
      
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
