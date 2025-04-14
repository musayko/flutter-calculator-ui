// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting in history screen

class FirestoreService {
  // Get reference to the 'history' collection in Firestore
  final CollectionReference _historyCollection =
      FirebaseFirestore.instance.collection('history');

  // Add a history entry for a specific user
  // Takes the calculation string (e.g., "5+2=7") and the user's unique ID
  Future<void> addHistoryEntry(String calculation, String userId) async {
    try {
      // Add a new document to the 'history' collection
      await _historyCollection.add({
        'userId': userId, // Store the user ID to know who this record belongs to
        'calculation': calculation, // Store the calculation string
        // Use a server-side timestamp for accurate and consistent ordering
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("History entry added for user: $userId");
    } catch (e) {
      // Log errors for debugging
      print("Error adding history to Firestore: $e");
      // In a real app, you might want to show a user-facing error message
    }
  }

  // Get a stream of history entries for a specific user, ordered by time
  // Returns a Stream that automatically updates when data changes in Firestore
  Stream<QuerySnapshot> getHistoryStream(String userId) {
    // Query the collection...
    return _historyCollection
        .where('userId', isEqualTo: userId) // ...filtering documents where 'userId' matches the provided ID
        .orderBy('timestamp', descending: true) // ...ordering them by timestamp, newest first
        .snapshots(); // ...and return a stream of snapshots
  }

  // Clear all history entries for a specific user
  Future<void> clearHistory(String userId) async {
    try {
      // 1. Find all documents belonging to the user
      // We use .get() here because we need to loop through them for deletion
      QuerySnapshot snapshot = await _historyCollection
          .where('userId', isEqualTo: userId)
          .get();

      // 2. Create a batch write operation for efficiency
      // Deleting many documents one by one can be slow and costly
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // 3. Add a delete operation to the batch for each document found
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      // 4. Commit the batch (perform all deletions at once)
      await batch.commit();
      print("History cleared from Firestore for user: $userId");

    } catch (e) {
      // Log errors for debugging
      print("Error clearing history from Firestore: $e");
      // Handle error appropriately
    }
  }
}
