import 'database_helper.dart';

class OfflineRepo{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  //insert into scanned products
  Future<int> insertToScannerTable(Map<String, dynamic> data ) async{
    var dbClient = await conn.db;
    int result = 0;
    try{
      result = await dbClient!.insert(DBHelper.scannerTable, data);
      print("Inserted Successfully in scannerTable table: -------------$result");
    }catch(e){
      print('There are some issues inserting scannerTable: $e');
    }
    return result;
  }


  //get scanned products
  Future getScannedProducts() async {
    var dbClient = await conn.db;
    List scannedProducts = [];
    try {
      List<Map<String, dynamic>> maps = await dbClient!.rawQuery(
          "SELECT * FROM ${DBHelper.scannerTable}");
      for (var products in maps) {
        scannedProducts.add(products);
      }
    } catch (e) {
      print("There are some issues getting products : $e");
    }
    // print("All cart product from Header: $cartList");
    return scannedProducts;
  }

}