import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late Database _db;
  DBHelper() {
    _initDB();
  }

  Future<void> _initDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');
    _db = await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    await _initDB();
    return await _db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers(int limit) async {
    await _initDB();
    return await _db.query('users', limit: limit);
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    await _initDB();
    return await _db.update('users', user,
        where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> deleteUser(int id) async {
    await _initDB();
    return await _db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
