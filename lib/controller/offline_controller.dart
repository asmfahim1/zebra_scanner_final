import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/db_helper/offline_repo.dart';
import 'package:zebra_scanner_final/widgets/special_alert.dart';
import '../db_helper/master_item.dart';
import '../model/offline_product_model.dart';
import '../model/productList_model.dart';
import '../model/supplier_model.dart';
import '../model/taglist_model.dart';

class OfflineController extends GetxController {
  LoginController loginController = Get.find<LoginController>();
  RxBool isLoading = false.obs;
  RxList offlineTags = <TagListModel>[].obs;
  Future<void> listOfTags(String serverIp) async {
    try {
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
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  //gradient calculation
  static const double fillPercent = 52;
  static const double fillStop = (100 - fillPercent) / 95;
  final List<double> stops = [
    fillStop,
    fillStop,
  ];

  /// for supplier list search mechanism

  //supplier list fetching
  RxBool isSupLoaded = false.obs;
  RxList supList = <SuppListModel>[].obs;
  Future<void> listOfSuppliers(String serverIp) async {
    try {
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
      }
    } catch (e) {
      isSupLoaded(false);
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  //search mechanism for any name
  TextEditingController name = TextEditingController();
  RxString searchQuery = ''.obs;

  // Filter suppliers based on search query
  List get filteredSupList {
    if (searchQuery.value.isEmpty) {
      return supList.toList();
    } else {
      return supList
          .where((supplier) => supplier.xcus
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()))
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
  List scannedProductList = [];
  RxBool productLoaded = false.obs;

  Future getScannerTable() async {
    try {
      productLoaded(true);
      scannedProductList = await OfflineRepo().getScannedProducts();
      productLoaded(false);
    } catch (error) {
      productLoaded(false);
    }
  }

  TextEditingController searchByName = TextEditingController();
  RxString filteredQuery = ''.obs;

  List get filteredProductList {
    if (filteredQuery.value.isEmpty) {
      return scannedProductList.toList();
    } else {
      return scannedProductList
          .where((addedProducts) => addedProducts["itemdesc"]
          .toLowerCase()
          .contains(filteredQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Set the search query
  void searchProduct(String query) {
    filteredQuery.value = query;
  }

  Future<void> addItem(String itemCode) async {
    try {
      postProduct(true);
      int result = await OfflineRepo().insertToScanner(itemCode,
          loginController.deviceID.value, loginController.userId.value);
      if (result == 0) {
        await getScannerTable();
      } else {
        Get.snackbar('Warning!', "Invalid code",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP);
      }
      postProduct(false);
    } catch (e) {
      postProduct(false);
      Get.snackbar(
        'Warning!',
        "Quantity must be less than or equal total quantity",
        borderWidth: 1.5,
        borderColor: Colors.black54,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  //manual entry quantity
  Future<void> updateQty(String itemCode) async {
    if (qtyCon.text.isEmpty) {
      qtyCon.text = quantity.value.toString();
      print('auto quantity is : ${qtyCon.text}');
    } else {
      await OfflineRepo().updateQuantity(itemCode, qtyCon.text);
      print('auto quantity is : ${qtyCon.text}');
    }
    qtyCon.clear();
    quantity.value = 0;
  }

  //adjustment quantity
  Future<void> adjustmentQty(context, double totalQty, String itemCode) async {
    if (double.parse(qtyCon.text) > totalQty) {
      Get.snackbar(
          'Warning!', "Quantity must be less than or equal total quantity",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
    } else {
      if (qtyCon.text.isEmpty) {
        qtyCon.text = '0';
        await OfflineRepo().adjustQuantity(itemCode, qtyCon.text);
      } else {
        await OfflineRepo().adjustQuantity(itemCode, qtyCon.text);
        Navigator.pop(context);
      }
    }
    qtyCon.clear();
    quantity.value = 0;
  }

  //increment function
  RxDouble quantity = 0.0.obs;

  //making textField iterable update the value of both textController and quantity
  void updateTQ(String value) {
    qtyCon.text = value;
    quantity.value = double.parse(qtyCon.text);
  }

  void incrementQuantity() {
    quantity.value = quantity.value + 1;
    qtyCon.text = quantity.value.toString();
  }

  void decrementQuantity() {
    if (quantity.value <= 0) {
      Get.snackbar('Warning!', "You do not have quantity for decrement");
    } else {
      quantity.value = quantity.value - 1;
      qtyCon.text = quantity.value.toString();
    }
  }

  //load master data
  RxString oTagNum = ''.obs;
  RxString storeId = ''.obs;
  RxString xCus = ''.obs;

  // save carrying need values reactively and manage routes
  void saveData(String tag, String store, String cus) async {
    try {
      isSupLoaded(true);
      oTagNum.value = tag;
      storeId.value = store;
      xCus.value = cus;
      isSupLoaded(false);
    } catch (e) {
      isSupLoaded(false);
    }
  }

  RxBool isFetched = false.obs;
  List<OfflineProductModel>? masterModel;

  Future<Object> fetchMasterItemsList(BuildContext context) async {
    try {
      isFetched(true);
      var responseMaster = await http.get(Uri.parse(
          'http://${loginController.serverIp.value}/unistock/masteritem.php?xcus=${xCus.value}&tag=${oTagNum.value}'));
      if (responseMaster.statusCode == 200) {
        await MasterItems().deleteFromTerritoryTable();
        (json.decode(responseMaster.body) as List).map((products) {
          MasterItems()
              .insertToMasterTable(OfflineProductModel.fromJson(products));
        }).toList();
        isFetched(false);
        if (context.mounted) {
          clearTextField();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => SpecialAlert(
              headTitle: "Successful!",
              message: "Data fetched successfully",
              btnText: "Back",
            ),
          );

        }
        return 'Product fetched Successfully';
      } else {
        isFetched(false);
        Get.snackbar(
          'Error',
          'Something went wrong',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        return 'Error in fetching data';
      }
    } catch (error) {
      isFetched(false);
      Get.snackbar(
        'Error',
        'Something went wrong',
        borderWidth: 1.5,
        borderColor: Colors.black54,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return 'Error in the method';
    }
  }

  void clearTextField(){
    name.clear();
    search('');
  }

  RxBool got = false.obs;
  List<Map<String, dynamic>> getAllData = [];
  Future<void> getAll() async {
    try {
      got(true);
      List<dynamic> products = await MasterItems().getMasterItem();
      getAllData = products.map((e) => e as Map<String, dynamic>).toList();
      got(false);
    } catch (e) {
      got(false);
    }
  }

  Future<void> deleteAllData() async {
    try {
      await MasterItems().deleteFromTerritoryTable();
      await getAll();
      Get.snackbar('Successful', 'Data deleted',
          backgroundColor: Colors.white, duration: const Duration(seconds: 1));
    } catch (e) {
      got(false);
    }
  }

  //RxBool uploaded = false.obs;
  List scannedData = [];
  Future<void> uploadToServer() async {
    scannedData = await OfflineRepo().getScannedProducts();
    if (scannedData.isEmpty) {
      Get.snackbar('Warning!', 'Your have no data to upload',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1));
    } else {
      try {
        productLoaded(true);
        for (int i = 0; i < scannedData.length; i++) {
          var responseBody = jsonEncode(<String, dynamic>{
            "scanned_code": scannedData[i]["scanned_code"],
            "xitem": scannedData[i]["itemcode"],
            "scanqty": scannedData[i]["scanqty"],
            "adjustqty": scannedData[i]["adjustqty"],
            "autoqty": scannedData[i]["autoqty"],
            "manualqty": scannedData[i]["manualqty"],
            "xcus": scannedData[i]["xcus"],
            "device": scannedData[i]["device_id"],
            "user_id": scannedData[i]["userIud"],
            "tag_no": scannedData[i]["tag_num"],
          });
          var response = await http.post(
              Uri.parse(
                  'http://${loginController.serverIp.value}/unistock/zebra/offlineUpload.php'),
              body: responseBody);
          if (response.statusCode == 200) {
            await OfflineRepo().itemWiseDelete(scannedData[i]["itemcode"]);
          } else {
            Get.snackbar(
              'Warning!',
              'Please check your internet connection',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 1),
            );
          }
        }
        await getScannerTable();
        productLoaded(false);
        Get.snackbar('Successful!', 'Uploaded to server successfully',
          backgroundColor: Colors.white,
          colorText: Colors.black,
          duration: const Duration(seconds: 1),
        );
      } catch (e) {
        productLoaded(false);
        Get.snackbar(
          'Warning!',
          'Upload Failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
    }
  }
}