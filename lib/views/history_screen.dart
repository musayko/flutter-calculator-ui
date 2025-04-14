// lib/views/history_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'package:intl/intl.dart'; // Import intl for date formatting
import '../services/firestore_service.dart'; // Import Firestore Service

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Instance of our Firestore service
  final FirestoreService _firestoreService = FirestoreService();
  // Instance of Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Variable to hold the current user
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // Get the currently signed-in user when the screen initializes
    _currentUser = _auth.currentUser;
  }

  // Function to call the Firestore service to clear history for the current user
  void _clearHistory() async {
    if (_currentUser != null) {
      await _firestoreService.clearHistory(_currentUser!.uid);
      // The StreamBuilder will automatically reflect the changes, no setState needed
      print("Clear history initiated for user: ${_currentUser!.uid}");
    } else {
       print("Error: User not signed in. Cannot clear history.");
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error: Could not clear history. User not signed in.')),
       );
    }
  }

  // Shows the confirmation dialog before clearing history
   void _showClearConfirmationDialog() {
    // Keep the confirmation dialog logic as before
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 40, 40, 40),
          title: Text("Clear History?", style: TextStyle(color: Colors.white)),
          content: Text("Are you sure you want to delete all calculation history from the cloud?", style: TextStyle(color: Colors.white70)),
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
                Navigator.of(context).pop(); // Close the dialog first
                _clearHistory(); // Call the updated clear method
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // Handle cases where user might be null (e.g., sign-in failed during startup)
    if (_currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
           backgroundColor: Colors.black,
           title: const Text('Calculation History'),
        ),
        body: const Center(
          child: Text(
            'Please sign in to view history.', // Or show a loading indicator/error
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
        ),
      );
    }

    // Main Scaffold for displaying history
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Calculation History'),
         actions: [
          // Button to trigger clearing history
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Clear History',
            onPressed: _showClearConfirmationDialog, // Show confirmation before clearing
          ),
        ],
      ),
      // Use StreamBuilder to listen for real-time updates from Firestore
      body: StreamBuilder<QuerySnapshot>(
        // Get the history stream for the current user from FirestoreService
        stream: _firestoreService.getHistoryStream(_currentUser!.uid),
        builder: (context, snapshot) {
          // --- Handle different stream states ---
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Show error message if stream encounters an error
          if (snapshot.hasError) {
            print("Firestore Stream Error: ${snapshot.error}"); // Log the error
            return Center(child: Text('Error loading history: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          }
          // Show message if there's no data or the history is empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No history yet.',
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            );
          }
          // --- Data is available, build the list ---
          final historyDocs = snapshot.data!.docs; // Get the list of documents

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              // Get the data map from the current document snapshot
              final doc = historyDocs[index];
              // Use `as Map<String, dynamic>?` for safer casting
              final data = doc.data() as Map<String, dynamic>?;

              // Safely access fields with null checks or provide default values
              final calculation = data?['calculation'] as String? ?? 'No calculation data';
              // Get the Firestore Timestamp object
              final timestamp = data?['timestamp'] as Timestamp?;

              // Format the Firestore Timestamp to a readable string
              // Check if timestamp is not null before formatting
              final formattedTime = timestamp != null
                  ? DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate()) // Convert Timestamp to DateTime then format
                  : 'No timestamp data';

              // Build the list tile for each history entry
              return ListTile(
                title: Text(
                  calculation,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                   overflow: TextOverflow.ellipsis, // Prevent long text overflow
                   maxLines: 1,
                ),
                subtitle: Text(
                  formattedTime, // Display the formatted timestamp
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                 contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
                  // Optional: Add a subtle border between items
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[800]!, width: 0.5),
                  ),
              );
            },
          );
        },
      ),
    );
  }
}
