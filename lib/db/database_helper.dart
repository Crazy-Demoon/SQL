import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HotelDatabaseHelper {
  static final HotelDatabaseHelper instance = HotelDatabaseHelper._init();
  static Database? _database;

  HotelDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hotels.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hotels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hotel_name TEXT NOT NULL,
        location TEXT NOT NULL,
        owner_email TEXT NOT NULL UNIQUE,
        contact_number TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertHotel(String hotelName, String location, String ownerEmail,
      String contactNumber) async {
    final db = await database;

    try {
      return await db.insert('hotels', {
        'hotel_name': hotelName,
        'location': location,
        'owner_email': ownerEmail,
        'contact_number': contactNumber,
      });
    } catch (e) {
      return -1; // Si el email ya está registrado
    }
  }

  Future<Map<String, dynamic>?> getHotel(String ownerEmail) async {
    final db = await database;
    final result = await db.query(
      'hotels',
      where: 'owner_email = ?',
      whereArgs: [ownerEmail],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> hotelExists(String ownerEmail) async {
    final db = await database;
    final result = await db.query(
      'hotels',
      where: 'owner_email = ?',
      whereArgs: [ownerEmail],
    );
    return result.isNotEmpty;
  }
}
