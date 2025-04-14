import '../models/calculator_model.dart';
import '../models/history_model.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class CalculatorController {
  final CalculatorModel model = CalculatorModel();
  final void Function(String) updateDisplay;
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Instantiate DatabaseHelper

  CalculatorController(this.updateDisplay);

  Future<void> handleButtonPress(String buttonText) async { // Make async
    bool shouldUpdateDisplay = true; // Flag to control display update

    switch (buttonText) {
      case 'C':
        model.clear();
        break;
      case '⌫':
        model.delete();
        break;
      case '+':
      case '-':
      case '×':
      case '÷':
      case '%':
        model.setOperation(buttonText);
        break;
      case '=':
        model.calculate(); // Calculate the result
        String? calculation = model.lastCalculation; // Get the formatted calculation string
        if (calculation != null && model.displayValue != "Error") {
           // Save to database if calculation is valid
           String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
           HistoryEntry entry = HistoryEntry(calculation: calculation, timestamp: timestamp);
           await _dbHelper.insertHistory(entry); // Save asynchronously
           // Optionally clear last calculation from model after saving
           // model.clearLastCalculation(); // You'd need to add this method to the model
        }
        break;
      case '.':
        model.appendDecimal();
        break;
      default:
        // Handle number buttons
        model.appendNumber(buttonText);
    }

    // Update UI with the current display value if needed
    if (shouldUpdateDisplay) {
       updateDisplay(model.displayValue);
    }
  }
}