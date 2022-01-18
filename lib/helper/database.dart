import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<dynamic> getResult({query}) async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase("database.sqlite3");
  try {
    return await db.rawQuery(query);
  } catch (e) {
    return e.toString();
  } finally {
    await db.close();
  }
}
