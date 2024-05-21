import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'locations.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE locations ('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'status INTEGER, '
      'address TEXT, '
      'remark TEXT, '
      'status_name TEXT, '
      'created_at TEXT, '
      'updated_at TEXT'
      ')',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the missing columns in version 2
      await db.execute('ALTER TABLE locations ADD COLUMN status_name TEXT');
      await db.execute('ALTER TABLE locations ADD COLUMN created_at TEXT');
      await db.execute('ALTER TABLE locations ADD COLUMN updated_at TEXT');
    }
  }

  Future<void> insertLocation(Map<String, dynamic> location) async {
    final db = await database;
    await db.insert('locations', location);
  }

  Future<List<Map<String, dynamic>>> fetchLocations() async {
    final db = await database;
    return await db.query('locations');
  }

  Future<void> deleteAllLocations() async {
    final db = await database;
    await db.delete('locations');
  }
}
