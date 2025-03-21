import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Asegúrate de tener esta línea

class DatabaseHelper {
  static final _databaseName = "myApp.db";
  static final _databaseVersion = 1;
  static final table = 'users';

  // Columnas de la tabla
  static final columnId = '_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  static final columnIsAdmin = 'isAdmin';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Inicializar base de datos
    _database = await _initDatabase();
    return _database!;
  }

  // Abre la base de datos y la crea si no existe
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Crea la tabla de usuarios
  Future _onCreate(Database db, int version) async {
    // Crear la tabla de usuarios
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnEmail TEXT NOT NULL UNIQUE,
            $columnPassword TEXT NOT NULL,
            $columnIsAdmin INTEGER NOT NULL
          )
          ''');

    // Insertar el admin por defecto
    await db.insert(table, {
      columnEmail: 'admin@myapp.com',
      columnPassword:
          'admin123', // Es recomendable cifrar la contraseña en producción
      columnIsAdmin: 1, // 1 para admin
    });
  }

  // Insertar un usuario
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Consultar un usuario por correo y contraseña
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Database db = await instance.database;
    List<Map> results = await db.query(table,
        where: "$columnEmail = ? AND $columnPassword = ?",
        whereArgs: [email, password]);
    if (results.length > 0) {
      return results.first as Map<String, dynamic>;
    }
    return null;
  }

  // Obtener usuario por correo
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    final result = await db.query(table);
    return result;
  }

  // Actualizar un usuario
  Future<int> updateUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Eliminar un usuario
  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
