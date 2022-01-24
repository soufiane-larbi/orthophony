import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

String path = File("database.sqlite3").absolute.path;
var db;
Future initDatabase() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  db = await databaseFactory.openDatabase(path);
}

Future<dynamic> getResult({query, close = true}) async {
  if (!db.isOpen) await initDatabase();
  try {
    return await db.rawQuery(query);
  } catch (e) {
    return 'Error: ' + e.toString();
  }
}

Future<dynamic> insertRow({required table, required values}) async {
  if (!db.isOpen) await initDatabase();
  try {
    return await db.insert(
      table,
      values,
    );
  } catch (e) {
    return 'Error: ' + e.toString();
  }
}

Future<dynamic> updateRows({required table, required values, whereArgs, where}) async {
  if (!db.isOpen) await initDatabase();
  try {
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  } catch (e) {
    return 'Error: ' + e.toString();
  }
}

Future<dynamic> insertBlob({required id, required File bilan}) async {
  if (!db.isOpen) await initDatabase();
  try {
    return await db.insert(
      'bilan',
      {
        'patientId': id,
        'name': bilan.path.split("\\").last,
        'bilan': await bilan.readAsBytes(),
      },
    );
  } catch (e) {
    return 'Error: ' + e.toString();
  }
}
