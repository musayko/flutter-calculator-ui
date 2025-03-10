import 'package:flutter/material.dart';
import '../controllers/converter_controller.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _kilometerController = TextEditingController();
  final TextEditingController _mileController = TextEditingController();
  late ConverterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConverterController();
    
    // Add listeners to update the other field when one changes
    _kilometerController.addListener(_onKilometerChanged);
    _mileController.addListener(_onMileChanged);
  }

  void _onKilometerChanged() {
    if (_kilometerController.text.isNotEmpty) {
      // Prevent recursive calls when updating fields
      _mileController.removeListener(_onMileChanged);
      
      String kmText = _kilometerController.text;
      if (kmText.isNotEmpty) {
        try {
          double km = double.parse(kmText);
          _mileController.text = _controller.kilometersToMiles(km).toStringAsFixed(2);
        } catch (e) {
          _mileController.text = '';
        }
      } else {
        _mileController.text = '';
      }
      
      _mileController.addListener(_onMileChanged);
    }
  }

  void _onMileChanged() {
    if (_mileController.text.isNotEmpty) {
      // Prevent recursive calls when updating fields
      _kilometerController.removeListener(_onKilometerChanged);
      
      String mileText = _mileController.text;
      if (mileText.isNotEmpty) {
        try {
          double miles = double.parse(mileText);
          _kilometerController.text = _controller.milesToKilometers(miles).toStringAsFixed(2);
        } catch (e) {
          _kilometerController.text = '';
        }
      } else {
        _kilometerController.text = '';
      }
      
      _kilometerController.addListener(_onKilometerChanged);
    }
  }

  @override
  void dispose() {
    _kilometerController.dispose();
    _mileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Km to Mile Converter'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kilometer input field
            TextField(
              controller: _kilometerController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Kilometers',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Conversion icon
            const Icon(
              Icons.compare_arrows,
              size: 40,
              color: Colors.blue,
            ),
            
            const SizedBox(height: 30),
            
            // Mile input field
            TextField(
              controller: _mileController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Miles',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Conversion formula explanation
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversion Formula:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1 Kilometer = 0.621371 Miles',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '1 Mile = 1.60934 Kilometers',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}