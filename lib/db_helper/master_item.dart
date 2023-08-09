import 'package:zebra_scanner_final/model/productList_model.dart';
import '../model/offline_product_model.dart';
import 'database_helper.dart';

class MasterItems{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  ///Insert into Master table
  Future<int> insertToMasterTable(OfflineProductModel offlineProductModel) async {
    var dbClient = await conn.db;
    int result = 0;
    try {
      result = await dbClient!
          .insert(DBHelper.masterTable, offlineProductModel.toJson());
    } catch (e) {
      print('There are some issues: $e');
    }
    print('the items are: $result');
    return result;
  }

  //get territory list
  Future<List> getMasterItem() async {
    var dbClient = await conn.db;
    List allProducts = [];
    try {
      List<Map<String, dynamic>> maps = await dbClient!.query(DBHelper.masterTable);
      for (var products in maps) {
        allProducts.add(products);
      }
    } catch (e) {
      print("There are some issues getting products : $e");
    }
    return allProducts;
  }

  Future<void> deleteFromTerritoryTable() async {
    try {
      var dbClient = await conn.db;
      dbClient!.delete(DBHelper.masterTable);
      print("Table deleted successfully");
    } catch (e) {
      print('Something went wrong when deleting Item: $e');
    }
  }

  ///insert to result table/scanner table
  Future<int> insertToScanner(String itemCode) async {
    var dbClient = await conn.db;
    int result = 0;
    int codeLength = itemCode.length;
    try {
      if(codeLength == 6){
        var existingRow = await dbClient!.rawQuery('SELECT TOP 1 xitem FROM ${DBHelper.masterTable} WHERE xtheircode = $itemCode');

      }else if(codeLength >= 13){
        var existingRow = await dbClient!.rawQuery('SELECT TOP 1 xitem FROM product WHERE xbodycode = $itemCode');

      }else if(codeLength >= 7 && codeLength <= 10){
        var existingRow = await dbClient!.rawQuery('SELECT TOP 1 xitem FROM product WHERE xitem = $itemCode');

      }else {
        return 0;
      }


      //result = await dbClient!.insert();
    } catch (e) {
      print('There are some issues: $e');
    }
    print('the items are: $result');
    return result;
  }

}