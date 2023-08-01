import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'database_helper.dart';

class ItemsRepo {
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();
  //create database table
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
    CREATE TABLE listItems(
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     item_code TEXT,
     item_quantity TEXT,
     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
     )
      """);
  }

//initialize db
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'item.db',
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  //create user
  static Future<int> createUser(String item_code, String? item_quantity) async {
    final db = await ItemsRepo.db();

    final data = {'item_code': item_code, 'item_quantity': item_quantity};
    final id = await db.insert('listItems', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // all users list
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await ItemsRepo.db();
    return db.query('listItems');
  }

  static Future<List<Map<String, dynamic>>> checkItem(String item_code) async {
    final db = await ItemsRepo.db();
    return db.query('listItems');
  }

  //update quantity
  static Future<int> updateUser(int id, String? item_quantity) async {
    final db = await ItemsRepo.db();

    final data = {
      'item_quantity': item_quantity,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('listItems', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteUser(int id) async {
    final db = await ItemsRepo.db();
    try {
      await db.delete("listItems", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> dropTable() async {
    final db = await ItemsRepo.db();
    db.delete('listItems');
    print("table deleted successfully");
  }
}
