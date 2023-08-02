import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/db_helper/offline_repo.dart';
import '../model/productList_model.dart';
import '../model/supplier_model.dart';
import '../model/taglist_model.dart';
import '../widgets/const_colors.dart';

class OfflineController extends GetxController {
  //list of open tags
  RxBool isLoading = false.obs;
  RxList offlineTags = <TagListModel>[].obs;
  Future<void> listOfTags(String serverIp) async {
    try{
      isLoading(true);
      var response = await http
          .get(Uri.parse('http://$serverIp/unistock/zebra/tag_select.php'));
      if (response.statusCode == 200) {
        isLoading(false);
        var tags = tagListModelFromJson(response.body);
        offlineTags.assignAll(tags);
      } else {
        isLoading(false);
        offlineTags.value = [];
        print('response is : ${response.statusCode}');
      }
    }catch(e){
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print("Something went wrong while submit data $e");
    }
  }

  //gradient calculation
  static const double fillPercent = 52;
  // fills 56.23% for container from bottom
  static const double fillStop = (100 - fillPercent) / 95;
  final List<double> stops = [
    fillStop,
    fillStop,
  ];

  /// for supplier list search mechanism

  //supplier list fetching
  RxBool isSupLoaded = false.obs;
  RxList supList = <SuppListModel>[].obs;
  //List<Map<String, dynamic>> supList = [];
  Future<void> listOfSuppliers(String serverIp) async {
    try{
      isSupLoaded(true);
      var response = await http
          .get(Uri.parse('http://$serverIp/unistock/supllierList.php'));
      if (response.statusCode == 200) {
        isSupLoaded(false);
        var suppliers = suppListModelFromJson(response.body);
        supList.assignAll(suppliers);
      } else {
        isSupLoaded(false);
        supList.value = [];
        print('response is : ${response.statusCode}');
      }
    }catch(e){
      isSupLoaded(false);
      Get.snackbar('Error', 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print("Something went wrong while submit data $e");
    }
  }

  //search mechanism for any name
  RxString searchQuery = ''.obs;

  // Filter suppliers based on search query
  List get filteredSupList {
    if (searchQuery.value.isEmpty) {
      return supList.toList();
    } else {
      return supList
          .where((supplier) => supplier.xcus.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Set the search query
  void search(String query) {
    searchQuery.value = query;
  }

  ///scan operation sector
  RxString scannerStatus = "Scanner status".obs;
  RxString lastCode = ''.obs;
  TextEditingController qtyCon = TextEditingController();
  RxBool haveProduct = false.obs;
  RxBool postProduct = false.obs;
  List<MasterItemsModel> products = [];

  //for getting cart_List from cart table
  List listCartHeader = [];
  RxBool productLoaded = false.obs;

  Future getScannerTable() async {
    try {
      productLoaded(true);
      listCartHeader = await OfflineRepo().getScannedProducts();
      productLoaded(false);
    } catch (error) {
      print('There are some issue getting cart header list: $error');
    }
  }

  //addItem(automatically)
  Future<void> addItem(
      String ipAddress,
      String itemCode,
      String userId,
      String tagNum,
      String outlet,
      String storeId,
      String deviceID) async {
    try{
      postProduct(true);
      Map<String, dynamic> scannedProduct = {
        'itemcode': itemCode,
        'itemdesc': 'description',
        'scanqty': 1,
        'adjustqty': 0,
        'autoqty': 0,
        'manualqty': 0,
        'xcus': 'sup-001'
      };
      OfflineRepo().insertToScannerTable(scannedProduct);
    }catch(e){
      print('error occurred inserting into scan table $e');
    }
  }

  //manual entry quantity
  Future<void> updateQty(
      String ipAddress,
      String itemCode,
      String userId,
      String tagNum,
      String outlet,
      String storeId,
      String deviceID) async {
    if (qtyCon.text.isEmpty) {
      qtyCon.text = quantity.value.toString();
      print('=========${qtyCon.text}');
      var response = await http.post(
          Uri.parse("http://$ipAddress/unistock/zebra/update.php"),
          body: jsonEncode(<String, dynamic>{
            "item": itemCode,
            "user_id": "010340",
            "qty": qtyCon.text.toString(),
            "device": deviceID,
            "tag_no": tagNum
          }));
      print("==========${response.body}");
      print("==========$ipAddress");
      print("==========$deviceID");
    } else {
      print('=========${qtyCon.text}');
      var response = await http.post(
          Uri.parse("http://$ipAddress/unistock/zebra/update.php"),
          body: jsonEncode(<String, dynamic>{
            "item": itemCode,
            "user_id": "010340",
            "qty": qtyCon.text.toString(),
            "device": deviceID,
            "tag_no": tagNum
          }));
      print("==========${response.body}");
      print("==========$ipAddress");
      print("==========$deviceID");
    }
    qtyCon.clear();
    quantity.value = 0;
  }

  //adjustment quantity
  Future<void> adjustmentQty(
      context,
      int totalQty,
      String ipAddress,
      String itemCode,
      String userId,
      String tagNum,
      String outlet,
      String storeId,
      String deviceID) async {
    if (int.parse(qtyCon.text) > totalQty) {
      Get.snackbar(
          'Warning!', "Quantity must be less than or equal total quantity",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: ConstantColors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      if (qtyCon.text.isEmpty) {
        qtyCon.text = '0';
        print('=========${qtyCon.text}');
        var response = await http.post(
            Uri.parse("http://$ipAddress/unistock/zebra/adjustment.php"),
            body: jsonEncode(<String, dynamic>{
              "item": itemCode,
              "user_id": "010340",
              "qty": qtyCon.text.toString(),
              "device": deviceID,
              "tag_no": tagNum
            }));
        Get.snackbar('Warning!!', "Product isn't adjusted successfully",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.4),
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM);
        print("==========${response.body}");
        print("==========$ipAddress");
        print("==========$deviceID");
      } else {
        print('=========${qtyCon.text}');
        var response = await http.post(
            Uri.parse("http://$ipAddress/unistock/zebra/adjustment.php"),
            body: jsonEncode(<String, dynamic>{
              "item": itemCode,
              "user_id": "010340",
              "qty": qtyCon.text.toString(),
              "device": deviceID,
              "tag_no": tagNum
            }));
        Get.snackbar('Success!', "Product adjust successfully",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.black,
          backgroundColor: Colors.white.withOpacity(0.8),
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
        );
        Navigator.pop(context);
      }
    }
    qtyCon.clear();
    quantity.value = 0;
  }

  //increment function
  RxInt quantity = 0.obs;

  //making textField iterable update the value of both textController and quantity
  void updateTQ(String value) {
    qtyCon.text = value;
    quantity.value = int.parse(value);
    print('update first quantity with the total amount : ${quantity.value}');
    print('update first textController with the total amount : ${qtyCon.text}');
  }

  void incrementQuantity() {
    quantity.value = quantity.value + 1;
    qtyCon.text = quantity.value.toString();
    print('--------${qtyCon.text}==========${quantity.value}');
  }

  void decrementQuantity() {
    if (quantity.value <= 0) {
      Get.snackbar('Warning!', "You do not have quantity for decrement");
    } else {
      quantity.value = quantity.value - 1;
      qtyCon.text = quantity.value.toString();
      print('--------${qtyCon.text}==========${quantity.value}');
    }
  }

}