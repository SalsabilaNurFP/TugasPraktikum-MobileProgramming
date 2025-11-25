import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<void> init() async {
    final path = join(await getDatabasesPath(), 'app_data.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users (id INTEGER PRIMARY KEY, user TEXT, pass TEXT)',
        );
        await db.insert('users', {'user': 'admin', 'pass': '1234'});
      },
    );
  }

  static Future<bool> login(String user, String pass) async {
    if (_db == null) await init();

    final res = await _db!.query(
      'users',
      where: 'user = ? AND pass = ?',
      whereArgs: [user, pass],
    );
    return res.isNotEmpty;
  }
}
