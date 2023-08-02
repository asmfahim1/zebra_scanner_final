import 'database_helper.dart';

class OfflineRepo{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  //insert into scanned products
  Future insertToScannerTable() async{

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