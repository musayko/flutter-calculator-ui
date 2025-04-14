class CalculatorModel {
  String _input = "0";
  String _previousInput = "";
  String _operation = "";
  bool _shouldResetInput = false;

  String? _lastCalculation;
  String? get lastCalculation => _lastCalculation;

  String get displayValue => _input;

  void clear() {
    _input = "0";
    _previousInput = "";
    _operation = "";
    _shouldResetInput = false;
    _lastCalculation = null; // Reset last calculation
  }

  void delete() {
    if (_input.length > 1) {
      _input = _input.substring(0, _input.length - 1);
    } else {
      _input = "0";
    }
  }

  void appendNumber(String number) {
    if (_input == "0" || _shouldResetInput) {
      _input = number;
      _shouldResetInput = false;
    } else {
       // Prevent excessively long inputs (optional)
      if (_input.length < 15) {
         _input = _input + number;
      }
    }
  }

  void appendDecimal() {
    if (_shouldResetInput) {
      _input = "0.";
      _shouldResetInput = false;
      return;
    }
    
    if (!_input.contains(".")) {
       if (_input.length < 15) { // Prevent excessively long inputs 
         _input = _input + ".";
       }
    }
  }

  void setOperation(String operation) {
    // Allow changing operation if reset flag is already set
    if (_shouldResetInput) {
       _operation = operation;
       return;
    }
    // Calculate if there's a pending operation
    if (_previousInput.isNotEmpty) {
      calculate(saveHistory: false); // Calculate intermediate result without saving
    }

    _operation = operation;
    _previousInput = _input;
    _shouldResetInput = true;
    _lastCalculation = null; // Clear last calculation until '=' is pressed
  }

  void calculate({bool saveHistory = true}) { // Add optional parameter
    if (_operation.isEmpty || _previousInput.isEmpty) return;

    double num1 = double.tryParse(_previousInput) ?? 0.0;
    double num2 = double.tryParse(_input) ?? 0.0;
    double result = 0;
    String calculationString = "$_previousInput $_operation $_input"; // Store original calculation parts

    switch (_operation) {
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
      case "×":
        result = num1 * num2;
        break;
      case "÷":
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          _input = "Error";
          _previousInput = "";
          _operation = "";
          _shouldResetInput = true;
          _lastCalculation = null;
          return;
        }
        break;
      case "%":
         if (num2 != 0) {
          result = num1 % num2;
        } else {
           _input = "Error";
           _previousInput = "";
           _operation = "";
           _shouldResetInput = true;
           _lastCalculation = null;
           return;
         }
        break;
    }

    String resultString;
    // Handle integer results to avoid displaying .0
    if (result == result.toInt()) {
      resultString = result.toInt().toString();
    } else {
      // Format to a reasonable number of decimal places
      resultString = result.toStringAsFixed(5);
      // Remove trailing zeros and potentially the decimal point
      resultString = resultString.replaceAll(RegExp(r'0+$'), '');
      if(resultString.endsWith('.')) {
        resultString = resultString.substring(0, resultString.length - 1);
      }
    }

    // Limit result length (optional)
     if (resultString.length > 15) {
       resultString = result.toStringAsExponential(9); // Use scientific notation
     }

    _input = resultString;

    if (saveHistory) {
        _lastCalculation = "$calculationString = $resultString"; // Store full calculation string
    } else {
        _lastCalculation = null; // Don't store intermediate calculations
    }

    // Prepare for next input
    _previousInput = _input; // Store result as previous input for chained operations
    _operation = ""; // Clear operation after calculation
    _shouldResetInput = true; // Next number should reset the display
  }
}