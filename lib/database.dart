import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'medicine.dart';

class DB {
  static Database database;
  static const String SERIAL = 'serial';
  static const String NAME = 'name';
  static const String LABORATORY = 'laboratory';
  static const String DATE = 'date';
  static const String TYPE = 'type';
  static const String TABLE = 'Medicine';
  static const String DB_NAME = 'medicine.db';

  Future<Database> get db async {
    if (database != null) {
      return database;
    }
    database = await initDB();
    return database;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($SERIAL INTEGER PRIMARY KEY, $NAME TEXT, $LABORATORY TEXT, $DATE TEXT, $TYPE TEXT)");
  }

  Future<Medicine> save(Medicine medicine) async {
    var client = await db;
    medicine.serial = await client.insert(TABLE, medicine.toMap());
    return medicine;
  }

  Future<List<Medicine>> getMedicines() async {
    var client = await db;
    List<Map> maps = await client
        .query(TABLE, columns: [SERIAL, NAME, LABORATORY, DATE, TYPE]);
    List<Medicine> medicines = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        medicines.add(Medicine.fromMap(maps[i]));
      }
    }
    return medicines;
  }

  Future<int> delete(int serial) async {
    var client = await db;
    return await client
        .delete(TABLE, where: '$SERIAL = ?', whereArgs: [serial]);
  }

  Future<int> update(Medicine medicine) async {
    var client = await db;
    return await client.update(TABLE, medicine.toMap(),
        where: '$SERIAL = ?', whereArgs: [medicine.serial]);
  }

  Future close() async {
    var client = await db;
    client.close();
  }
}
