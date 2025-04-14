import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import 'widgets/calculator_buttons.dart';


class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = "0";
  late CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller with callback to update display
    _controller = CalculatorController((value) {
      // Ensure updates happen on the main thread if controllers run async
      if (mounted) { // Check if the widget is still in the tree
         setState(() {
            _displayValue = value;
         });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculator'),
        actions: [
           // History Button
           IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Calculation History',
            onPressed: () {
              Navigator.pushNamed(context, '/history'); // Navigate using named route
            },
          ),
          // Converter Button (Keep if needed)
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Km to Mile Converter',
            onPressed: () {
              Navigator.pushNamed(context, '/converter');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjusted padding
              child: SingleChildScrollView( // Allow scrolling for long numbers
                 scrollDirection: Axis.horizontal,
                 reverse: true, // Show end of number first
                 child: Text(
                    _displayValue,
                    style: const TextStyle(color: Colors.white, fontSize: 60), // Increased font size
                    textAlign: TextAlign.right,
                     maxLines: 1, // Ensure it stays on one line
                  ),
                )
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 26, 26, 26),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              // Pass the async controller method
              child: CalculatorButtons(onButtonPressed: (buttonText) {
                 _controller.handleButtonPress(buttonText); // Call the async handler
              }),
            ),
          )
        ],
      ),
    );
  }
}