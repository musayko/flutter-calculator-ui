// lib/controllers/calculator_controller.dart
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../models/calculator_model.dart';
// import '../models/history_model.dart'; // History model might not be needed directly here
import '../services/firestore_service.dart'; // Import Firestore Service
// import '../services/database_helper.dart'; // Remove SQLite helper import
// import 'package:intl/intl.dart'; // Not needed for timestamp here

class CalculatorController {
  // Model for calculations
  final CalculatorModel model = CalculatorModel();
  // Callback to update the UI display
  final void Function(String) updateDisplay;
  // Service for Firestore interactions
  final FirestoreService _firestoreService = FirestoreService();
  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Constructor: initializes display
  CalculatorController(this.updateDisplay) {
     updateDisplay(model.displayValue);
  }

  // Handles button presses from the UI
  Future<void> handleButtonPress(String buttonText) async {
    // Get the currently signed-in user
    // It might be null briefly if the app starts before sign-in completes
    User? currentUser = _auth.currentUser;

    // Process button press based on its text
    switch (buttonText) {
      case 'C':
        model.clear();
        break;
      case '⌫':
        model.delete();
        break;
      case '+':
      case '-':
      case '×': // Use the display symbol
      case '÷': // Use the display symbol
      case '%':
        model.appendOperator(buttonText);
        break;
      case '=':
        // Perform the calculation using the model
        model.evaluateExpression();
        // Get the formatted calculation string (e.g., "5+6/2 = 8")
        String? calculation = model.lastCalculation;

        // Check if calculation was successful and produced a result string
        if (calculation != null && model.displayValue != "Error") {
          // --- Save to Firestore ---
          // Check if a user is actually signed in
          if (currentUser != null) {
             // Call the Firestore service to add the entry
             // Pass the calculation string and the user's unique ID (currentUser.uid)
             await _firestoreService.addHistoryEntry(calculation, currentUser.uid);
          } else {
            // Handle the case where the user isn't signed in (shouldn't happen with auto anonymous sign-in)
            print("Error: User not signed in. Cannot save history.");
            // Optionally show an error message to the user via the UI callback
          }
          // --- End Save to Firestore ---
        }
        break;
      case '.':
        model.appendDecimal();
        break;
      default: // Number buttons
        model.appendNumber(buttonText);
    }
   
    // Update the UI display with the latest value from the model
    updateDisplay(model.displayValue);
  }
}
