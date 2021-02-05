import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';

class DatabaseHelper {
  static final String _dbName = "demo.db";
  static final int _dbVersion = 1;
  static Database _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initiateDatabase();
    return _database;
  }

  Future<Database> _initiateDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);
    print("Database pasth is : $path");
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    // await db.transaction((txn) async {
    //   int id = await txn.rawInsert(
    //       'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
    // });
    int id = await db.insert("Test", row);
    print('inserted: $id');
    return id;
  }

  Future<List<Map<String, dynamic>>> rowsdisplayAll() async {
    Database db = await instance.database;
    return await db.query("Test");
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    //returns numbre of rows updated
    int oldId = row['id'];
    int id = await db.update("Test", row, where: "id = ?", whereArgs: [oldId]);
    print('updated: $id');
    return id;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    //returns numbre of rows updated
    int idDel = await db.delete("Test", where: "id = ?", whereArgs: [id]);
    print('deleted: $id');
    return idDel;
  }
}
