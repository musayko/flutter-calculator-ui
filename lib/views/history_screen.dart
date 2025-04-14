// lib/views/history_screen.dart
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/history_model.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<HistoryEntry>> _historyList;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyList = _dbHelper.getHistory();
    });
  }

   void _clearHistory() async {
    await _dbHelper.clearHistory();
    _loadHistory(); // Refresh the list after clearing
  }

   void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 40, 40, 40),
          title: Text("Clear History?", style: TextStyle(color: Colors.white)),
          content: Text("Are you sure you want to delete all calculation history?", style: TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Clear", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _clearHistory(); // Proceed with clearing
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculation History'),
         actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Clear History',
            onPressed: _showClearConfirmationDialog, // Show confirmation dialog
          ),
        ],
      ),
      body: FutureBuilder<List<HistoryEntry>>(
        future: _historyList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading history: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No history yet.',
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            );
          } else {
            // Display the history list
            List<HistoryEntry> history = snapshot.data!;
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  title: Text(
                    entry.calculation,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                     overflow: TextOverflow.ellipsis, // Prevent long calculations from overflowing
                     maxLines: 1,
                  ),
                  subtitle: Text(
                    entry.timestamp,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                   contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add some padding
                    shape: RoundedRectangleBorder( // Optional: Add a subtle border
                      side: BorderSide(color: Colors.grey[800]!, width: 0.5),
                      // borderRadius: BorderRadius.circular(4), // Optional: rounded corners
                    ),
                );
              },
            );
          }
        },
      ),
    );
  }
}