import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'medicine.dart';

class DB {
  static Database _db;
  static const String SERIAL = 'serial';
  static const String NOMBRE = 'nombre';
  static const String LABORATORIO = 'laboratorio';
  static const String FECHA = 'fecha';
  static const String TIPO = 'tipo';
  static const String TABLE = 'Medicine';
  static const String DB_NAME = 'medicine.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($SERIAL INTEGER PRIMARY KEY, $NOMBRE TEXT, $LABORATORIO TEXT, $FECHA TEXT, $TIPO TEXT)");
  }

  Future<Medicine> save(Medicine medicine) async {
    var dbClient = await db;
    medicine.serial = await dbClient.insert(TABLE, medicine.toMap());
    return medicine;
  }

  Future<List<Medicine>> getMedicines() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [SERIAL, NOMBRE, LABORATORIO, FECHA, TIPO]);
    List<Medicine> medicines = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        medicines.add(Medicine.fromMap(maps[i]));
      }
    }
    return medicines;
  }

  Future<int> delete(int serial) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE, where: '$SERIAL = ?', whereArgs: [serial]);
  }

  Future<int> update(Medicine medicine) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, medicine.toMap(),
        where: '$SERIAL = ?', whereArgs: [medicine.serial]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
