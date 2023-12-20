import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Database2 {
  Database? mydatabase;
  Future<Database?> checkdata() async {
    if (mydatabase == null) {
      mydatabase = await creating();
      return mydatabase;
    } else {
      return mydatabase;
    }
  }

  int Version = 2;
  creating() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'user.db');
    print("Database path: $mypath");
    Database mydb = await openDatabase(mypath, version: Version, onCreate: (db, version) {
      print("Creating table...");
      db.execute('''CREATE TABLE IF NOT EXISTS 'USERS'(
 'UID' TEXT NOT NULL PRIMARY KEY ,
 'FNAME' TEXT NOT NULL,
 'LNAME' TEXT NOT NULL,
 'Mobile' TEXT NOT NULL)''');
      print("Table created.");
    });
// Print table schema
    List<Map<String, dynamic>> tableInfo =
    await mydb.rawQuery("PRAGMA table_info('USERS')");
    print("Table Schema: $tableInfo");
    print("Database opened.");
    return mydb;
  }
  isexist() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'user.db');
    await databaseExists(mypath) ? print("it exists") : print("not exist");
  }
  reseting() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'user.db');
    await deleteDatabase(mypath);
  }
  reading(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawQuery(sql);
    return myesponse;
  }
  update(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawUpdate(sql);
    return myesponse;
  }
  write(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawInsert(sql);
    return myesponse;
  }
  delete(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawDelete(sql);
    return myesponse;
  }
}
