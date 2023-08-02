import 'package:zebra_scanner_final/model/productList_model.dart';
import 'database_helper.dart';

class MasterItems{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  ///Insert into Master table
  Future<int> insertToMasterTable(MasterItemsModel masterItemsModel) async {
    var dbClient = await conn.db;
    int result = 0;
    try {
      result = await dbClient!
          .insert(DBHelper.masterTable, masterItemsModel.toJson());
    } catch (e) {
      print('There are some issues: $e');
    }
    print('the items are: $result');
    return result;
  }

  //get territory list
  Future<List> getTerritoryList() async {
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


}