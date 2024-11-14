import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

  // Initialize the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserDatabase.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        title TEXT,
        profilePic BLOB
      )
    ''');
  }

  // Insert a new user with only the username
  Future<int> createUser(String username) async {
    final db = await database;
    return await db.insert(
      'User',
      {
        'username': username,
        'title': null,       // Leave title as null
        'profilePic': null,  // Leave profilePic as null
      },
    );
  }

  // Update the title for the single user
  Future<int> updateTitle(String title) async {
    final db = await database;
    return await db.update(
      'User',
      {'title': title},
      where: 'id = 1', // Assuming the single user has ID 1
    );
  }

  // Update the profile picture for the single user
  Future<int> updateProfilePic(Uint8List profilePic) async {
    final db = await database;
    return await db.update(
      'User',
      {'profilePic': profilePic},
      where: 'id = 1', // Assuming the single user has ID 1
    );
  }

  // Get all user information
  Future<List<Map<String, dynamic>>> getUserInfo() async {
    final db = await database;
    return await db.query('User');
  }
}
