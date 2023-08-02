import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper.internal();

  static final DBHelper dbHelper = DBHelper.internal();

  factory DBHelper() => dbHelper;
  static const masterTable = 'masterTable';
  static const scannerTable = 'scannerTable';
  static const listItems = 'listItems';
  static final _version = 1;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'unistock.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute("""
        CREATE TABLE $masterTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          ztime VARCHAR(150), 
          xitem VARCHAR(150), 
          xdesc VARCHAR(150),
          xunit VARCHAR(20),
          xcus VARCHAR(50),
          xbodycode VARCHAR(50),
          xtheircode VARCHAR(50),
          xpaymenttype VARCHAR(50)
          )""");
      await db.execute("""
        CREATE TABLE $scannerTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itemcode VARCHAR(150), 
          itemdesc VARCHAR(150), 
          scanqty VARCHAR(150),
          adjustqty VARCHAR(20),
          autoqty VARCHAR(50),
          manualqty VARCHAR(50),
          xcus VARCHAR(50),
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          )""");
      await db.execute("""
        CREATE TABLE listItems(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         item_code TEXT,
         item_quantity TEXT,
         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
         )""");
    }, onUpgrade: (Database db, int oldversion, int newversion) async {
      if (oldversion < newversion) {
        print("Version Upgrade");
      }
    });
    return openDb;
  }
}
