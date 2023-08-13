import 'database_helper.dart';

class OfflineRepo{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  //insert into scanned products
  ///insert to result table/scanner table
  Future<int> insertToScanner(String itemCode) async {
    var dbClient = await conn.db;
    int result = 0;
    int codeLength = itemCode.length;
    try {
      String? itemDesc = '';
      if (codeLength == 7) {
        var existingRow = await dbClient!.rawQuery(
            'SELECT xitem,xdesc  FROM ${DBHelper.masterTable} WHERE xitem = ? LIMIT 1',
            [itemCode]);
        var scanningRow = await dbClient.rawQuery(
            'SELECT itemcode FROM ${DBHelper.scannerTable} WHERE itemcode = ? LIMIT 1',
            [itemCode]);
        print('existingRow: $existingRow');
        if (scanningRow.isNotEmpty) {
          itemDesc = existingRow.first['xdesc'] as String?;
          print('description: ${existingRow.first['xdesc']}');
          // Item exists, perform an update using raw SQL query
          result = await dbClient.rawUpdate(
            'UPDATE ${DBHelper.scannerTable} '
                'SET scanqty = scanqty + 1, autoqty = autoqty + 1 '
                'WHERE scanned_code = ?',
            [itemCode],
          );
        } else {
          // Item doesn't exist, perform an insert using raw SQL query
          result = await dbClient.rawInsert(
            'INSERT INTO ${DBHelper.scannerTable} '
                '(scanned_code, itemcode, itemdesc, scanqty, autoqty) '
                'VALUES (?, ?, ?, "1", "1")',
            [itemCode, itemCode, itemDesc],
          );
        }
      } else if (codeLength >= 13) {
        // Similar logic for xbodycode
      } else if (codeLength >= 7 && codeLength <= 10) {
        // Similar logic for xitem
      } else {
        return 0;
      }
    } catch (e) {
      print('There are some issues: $e');
    }
    print('the items are: $result');
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