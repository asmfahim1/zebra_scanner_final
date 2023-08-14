import 'database_helper.dart';

class OfflineRepo{
  final conn = DBHelper.dbHelper;
  DBHelper dbHelper = DBHelper();

  //insert into scanned products
  ///insert to result table/scanner table
  Future<int> insertToScanner(String itemCode,String deviceID,String userID) async {
    var dbClient = await conn.db;
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
                  'VALUES (?, ?, ?, "1", "0", "1", "0", ?, ?, "77", ?, ?)',
              [itemCode, itemCode, itemDesc, xcus, deviceID, tag_no, userID],
            );

          }


        }
        else{

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
                  'VALUES (?, ?, ?, "1", "0", "1", "0", ?, ?, "77", ?, ?)',
              [itemCode, mainItem, itemDesc, xcus, deviceID, tag_no, userID],
            );

          }


        }
        else{

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
                  'VALUES (?, ?, ?, "1", "0", "1", "0", ?, ?, "77", ?, ?)',
              [itemCode, mainItem, itemDesc, xcus, deviceID, tag_no, userID],
            );

          }


        }
        else{

        }


        // Similar logic for xbodycode

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