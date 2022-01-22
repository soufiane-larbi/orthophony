import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

String path = "C:\\Users\\Soufiane\\Documents\\Projects\\Orthophonie\\code\\.dart_tool\\sqflite_common_ffi\\databases\\database.sqlite3";

Future<dynamic> getResult({query, close = true}) async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(path);
  try {
    return await db.rawQuery(query);
  } catch (e) {
    return 'Error: ' + e.toString();
  } finally {
    if (close) await db.close();
  }
}

Future<dynamic> insertRow({required table, required values}) async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(path);
  try {
    return await db.insert(
      table,
      values,
    );
  } catch (e) {
    return 'Error: ' + e.toString();
  } finally {
    await db.close();
  }
}

Future<dynamic> updateRows({required table, required values, whereArgs, where}) async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(path);
  try {
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  } catch (e) {
    return 'Error: ' + e.toString();
  } finally {
    await db.close();
  }
}

Future<dynamic> insertBlob({required id, required File bilan}) async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(path);
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
  } finally {
    await db.close();
  }
}
