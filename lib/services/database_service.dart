import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        name TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> createUser(String email, String name, String password) async {
    final db = await instance.database;
    return await db.insert('users', {
      'email': email,
      'name': name,
      'password': password, // En producción, usa hashing!
    });
  }

   Future<Map<String, dynamic>?> verifyUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password], // En producción, usa hashing!
      limit: 1,
    );
    
    return result.isNotEmpty ? result.first : null;
  }

  // Método para actualizar contraseña
  Future<int> updatePassword(String email, String newPassword) async {
    final db = await instance.database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
  final db = await instance.database;
  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
    limit: 1,
  );
  
  return result.isNotEmpty ? result.first : null;
}
}