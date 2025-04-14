import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/history_model.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'calculator_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calculation TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
      ''');
  }

  // Insert a history entry into the database
  Future<int> insertHistory(HistoryEntry entry) async {
    Database db = await database;
    // Insert the HistoryEntry into the correct table.
    // We specify the conflictAlgorithm to use in case the same entry is inserted twice.
    // In this case, replace any previous data.
    return await db.insert(
      'history',
      entry.toMap()..remove('id'), // Remove id as it's auto-incremented
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all history entries from the database, ordered by timestamp descending
  Future<List<HistoryEntry>> getHistory() async {
    Database db = await database;
    // Query the table for all The History Entries, ordered by timestamp descending.
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: 'timestamp DESC', // Order by timestamp, newest first
    );

    // Convert the List<Map<String, dynamic> into a List<HistoryEntry>.
    return List.generate(maps.length, (i) {
      return HistoryEntry(
        id: maps[i]['id'],
        calculation: maps[i]['calculation'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

   // Clear all history entries
  Future<void> clearHistory() async {
    Database db = await database;
    await db.delete('history');
  }
}