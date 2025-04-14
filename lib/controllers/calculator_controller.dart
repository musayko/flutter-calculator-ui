// lib/controllers/calculator_controller.dart
import '../models/calculator_model.dart';
import '../models/history_model.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class CalculatorController {
  final CalculatorModel model = CalculatorModel();
  final void Function(String) updateDisplay;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  CalculatorController(this.updateDisplay) {
     // Initialize display on creation
     updateDisplay(model.displayValue);
  }

  Future<void> handleButtonPress(String buttonText) async {
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
        model.evaluateExpression();
        String? calculation = model.lastCalculation; // Get from the new model structure
        if (calculation != null && model.displayValue != "Error") {
          String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
          HistoryEntry entry = HistoryEntry(calculation: calculation, timestamp: timestamp);
          await _dbHelper.insertHistory(entry);
        }
        break;
      case '.':
        model.appendDecimal();
        break;
      default: // Number buttons
        model.appendNumber(buttonText);
    }

    // Update UI with the current display value from the model
    updateDisplay(model.displayValue);
  }
}