class HistoryEntry {
  final int? id; // Nullable for database insertion
  final String calculation;
  final String timestamp;

  HistoryEntry({this.id, required this.calculation, required this.timestamp});

  // Convert a HistoryEntry into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calculation': calculation,
      'timestamp': timestamp,
    };
  }

  
  @override
  String toString() {
    return 'HistoryEntry{id: $id, calculation: $calculation, timestamp: $timestamp}';
  }
}