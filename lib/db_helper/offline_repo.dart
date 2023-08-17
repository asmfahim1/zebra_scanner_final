import 'database_helper.dart';

class OfflineRepo{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  //insert into scanned products
  ///insert to result table/scanner table
  Future<int> insertToScanner(String itemCode,String deviceID,String userID) async {
    var dbClient = await conn.db;
    int success = 0;
    int result = 0;
    int codeLength = itemCode.length;
    try {
      String? itemDesc = '';
      String? xcus = '';
      String? tag_no = '';
      String? mainItem = '';
      if (codeLength == 6) {
        print('Inside CodeLength 6');
        var existingRow = await dbClient!.rawQuery(
            'SELECT xitem,xdesc, xcus, tag_no  FROM ${DBHelper.masterTable} WHERE xtheircode = ? LIMIT 1',
            [itemCode]);
        if(existingRow.isNotEmpty){
          var scanningRow = await dbClient.rawQuery(
              'SELECT itemcode FROM ${DBHelper.scannerTable} WHERE itemcode = ? LIMIT 1',
              [itemCode]);

          itemDesc = existingRow.first['xdesc'] as String?;
          xcus = existingRow.first['xcus'] as String?;
          tag_no = existingRow.first['tag_no'] as String?;
          if (scanningRow.isNotEmpty) {
            // Item exists, perform an update using raw SQL query
            result = await dbClient.rawUpdate(
              'UPDATE ${DBHelper.scannerTable} '
                  'SET scanqty = scanqty + 1, autoqty = autoqty + 1 '
                  'WHERE scanned_code = ?',
              [itemCode],
            );
          } else {
            print('description: ${itemDesc}');
            print('description: ${xcus}');
            print('description: ${tag_no}');
            // Item doesn't exist, perform an insert using raw SQL query
            result = await dbClient.rawInsert(
              'INSERT INTO ${DBHelper.scannerTable} '
                  '(scanned_code, itemcode, itemdesc, scanqty, adjustqty, autoqty, manualqty, xcus, device_id, store_id, tag_num, user_id) '
                  'VALUES (?, ?, ?, "1.0", "0.0", "1.0", "0.0", ?, ?, "77", ?, ?)',
              [itemCode, itemCode, itemDesc, xcus, deviceID, tag_no, userID],
            );

          }


        }
        else{
          success = 1;
          return success;
        }

      } else if (codeLength >= 13) {
        print('Inside CodeLength 13');
        var existingRow = await dbClient!.rawQuery(
            'SELECT xitem,xdesc, xcus, tag_no  FROM ${DBHelper.masterTable} WHERE xbodycode = ? LIMIT 1',
            [itemCode]);
        print('existingRow: $existingRow');
        if(existingRow.isNotEmpty){
          mainItem = existingRow.first['xitem'] as String?;
          itemDesc = existingRow.first['xdesc'] as String?;
          xcus = existingRow.first['xcus'] as String?;
          tag_no = existingRow.first['tag_no'] as String?;
          var scanningRow = await dbClient.rawQuery(
              'SELECT itemcode FROM ${DBHelper.scannerTable} WHERE itemcode = ? LIMIT 1',
              [mainItem]);
          print('existingRow: $existingRow');

          if (scanningRow.isNotEmpty) {
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
                  '(scanned_code, itemcode, itemdesc, scanqty, adjustqty, autoqty, manualqty, xcus, device_id, store_id, tag_num, user_id) '
                  'VALUES (?, ?, ?, "1.0", "0.0", "1.0", "0.0", ?, ?, "77", ?, ?)',
              [itemCode, mainItem, itemDesc, xcus, deviceID, tag_no, userID],
            );

          }


        }
        else{
          success = 1;
          return success;
        }


        // Similar logic for xbodycode
      } else if (codeLength >= 7 && codeLength <= 10) {
        print('Inside CodeLength 7-10');
        String extractedItemCode = itemCode.substring(itemCode.length - 7);
        var existingRow = await dbClient!.rawQuery(
            'SELECT xitem,xdesc, xcus, tag_no  FROM ${DBHelper.masterTable} WHERE xitem = ? LIMIT 1',
            [extractedItemCode]);
        if(existingRow.isNotEmpty){
          var scanningRow = await dbClient.rawQuery(
              'SELECT itemcode FROM ${DBHelper.scannerTable} WHERE itemcode = ? LIMIT 1',
              [extractedItemCode]);
          print('existingRow: $existingRow');
          mainItem = existingRow.first['xitem'] as String?;
          itemDesc = existingRow.first['xdesc'] as String?;
          xcus = existingRow.first['xcus'] as String?;
          tag_no = existingRow.first['tag_no'] as String?;

          // print('Sub String: ${extractedItemCode}');
          // print('MainItem: ${mainItem}');


          if (scanningRow.isNotEmpty) {
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
                  '(scanned_code, itemcode, itemdesc, scanqty, adjustqty, autoqty, manualqty, xcus, device_id, store_id, tag_num, user_id) '
                  'VALUES (?, ?, ?, "1.0", "0.0", "1.0", "0.0", ?, ?, "77", ?, ?)',
              [itemCode, mainItem, itemDesc, xcus, deviceID, tag_no, userID],
            );

          }


        }
        else{
          success = 1;
          return success;
        }


        // Similar logic for xbodycode

      } else {
        success = 1;
        return success;
      }
    } catch (e) {

      print('There are some issues: $e');
      success = 1;
      return success;
    }
    print('the items are: $result');
    return success;
  }

  //Manual Add
  Future<int> manualEntry(String itemCode,String qty,String deviceID,String userID) async {
    var dbClient = await conn.db;
    int success = 0;
    int result = 0;
    int codeLength = itemCode.length;
    try {
      String? itemDesc = '';
      String? xcus = '';
      String? tag_no = '';
      //String? mainItem = '';
      if (codeLength == 5 || codeLength == 7) {
        print('Inside CodeLength 5-7');
        var existingRow = await dbClient!.rawQuery(
            'SELECT xitem,xdesc, xcus, tag_no  FROM ${DBHelper.masterTable} WHERE xitem = ? LIMIT 1',
            [itemCode]);
        if(existingRow.isNotEmpty){
          print('Inside existingRow');
          var scanningRow = await dbClient.rawQuery(
              'SELECT itemcode FROM ${DBHelper.scannerTable} WHERE itemcode = ? LIMIT 1',
              [itemCode]);

          itemDesc = existingRow.first['xdesc'] as String?;
          xcus = existingRow.first['xcus'] as String?;
          tag_no = existingRow.first['tag_no'] as String?;
          if (scanningRow.isNotEmpty) {
            // Item exists, perform an update using raw SQL query
            result = await dbClient.rawUpdate(
              'UPDATE ${DBHelper.scannerTable} '
                  'SET scanqty = scanqty + ? , autoqty = autoqty + 1 '
                  'WHERE scanned_code = ?',
              [qty,itemCode],
            );
          } else {
            print('description: ${itemDesc}');
            print('description: ${xcus}');
            print('description: ${tag_no}');
            // Item doesn't exist, perform an insert using raw SQL query
            result = await dbClient.rawInsert(
              'INSERT INTO ${DBHelper.scannerTable} '
                  '(scanned_code, itemcode, itemdesc, scanqty, adjustqty, autoqty, manualqty, xcus, device_id, store_id, tag_num, user_id) '
                  'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, "77", ?, ?)',
              [itemCode, itemCode, itemDesc, qty, qty, qty, qty, xcus, deviceID, tag_no, userID],
            );

          }

        }
        else{
          success = 1;
          return success;
        }

      } else {
        success = 1;
        return success;
      }
    } catch (e) {
      print('There are some issues: $e');
      success = 1;
      return success;
    }
    print('the items are: $result');
    return success;
  }


  //Updating the Qty
  Future<void> updateQuantity(String item, String qty) async {
    try {
      var dbClient = await conn.db;

      if (qty == "0.0" || qty == '0') {
        String deleteSql = '''
        DELETE FROM ${DBHelper.scannerTable}
        WHERE itemcode = ?
      ''';

        await dbClient?.rawDelete(deleteSql, [item]);

        print('Item deleted successfully');
      } else {
        String updateSql = '''
        UPDATE ${DBHelper.scannerTable} 
        SET scanqty = ?, manualqty = ?, autoqty = ?, createdAt = CURRENT_TIMESTAMP
        WHERE itemcode = ?
      ''';

        await dbClient?.rawUpdate(updateSql, [qty, qty, qty, item]);

        print('Quantity updated successfully');
      }
    } catch (e) {
      print('There are some issues: $e');
    }
  }

  //Adjust Quantity
  Future<void> adjustQuantity(String item, String qty) async {
    try {
      var dbClient = await conn.db;

      if (qty == "0.0" || qty == '0') {
        String deleteSql = '''
        DELETE FROM ${DBHelper.scannerTable}
        WHERE itemcode = ?
      ''';

        await dbClient?.rawDelete(deleteSql, [item]);

        print('Item deleted successfully');
      } else {
        String updateSql = '''
        UPDATE ${DBHelper.scannerTable} 
        SET scanqty = scanqty - ?, adjustqty = ?, autoqty = ?, createdAt = CURRENT_TIMESTAMP
        WHERE itemcode = ?
      ''';

        await dbClient?.rawUpdate(updateSql, [qty, qty, qty, item]);

        print('Quantity adjusted successfully');
      }
    } catch (e) {
      print('There are some issues: $e');
    }
  }

  // Future<void> adjustQuantity(String item, String qty) async {
  //   try {
  //     var dbClient = await conn.db;
  //     print('Qty ${qty}');
  //     String sql = '''
  //     UPDATE ${DBHelper.scannerTable}
  //     SET scanqty = scanqty - ?, adjustqty = ?, autoqty = ?,  createdAt = CURRENT_TIMESTAMP
  //     WHERE itemcode = ? ''';
  //
  //     await dbClient?.rawUpdate(sql, [qty, qty, qty, item]);
  //
  //     print('Quantity adjusted successfully');
  //   } catch (e) {
  //     print('There are some issues: $e');
  //   }
  // }



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

  Future<void> itemWiseDelete(String itemcode) async{
    try {
    var dbClient = await conn.db;
    dbClient!.rawQuery('DELETE FROM ${DBHelper.scannerTable} WHERE itemcode = ?', [itemcode]);
    print("Row deleted successfully");
    } catch (e) {
    print('Something went wrong when deleting Item: $e');
    }
  }

}