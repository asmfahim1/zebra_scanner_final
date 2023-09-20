import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:zebra_scanner_final/controller/added_product_list_model.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import '../model/automatic_added_product_model.dart';
import '../model/last_added_item_model.dart';
import '../constants/const_colors.dart';
import '../model/last_auto_added_product_model.dart';
import '../widgets/reusable_alert.dart';

class OnlineController extends GetxController {
  LoginController login = Get.find<LoginController>();
  RxString scannerStatus = "Scanner status".obs;
  RxString lastCode = ''.obs;
  TextEditingController qtyCon = TextEditingController();
  static const double fillPercent = 52;
  static const double fillStop = (100 - fillPercent) / 95;
  final List<double> stops = [
    fillStop,
    fillStop,
  ];

  ConstantColors colors = ConstantColors();

  //API for ProductList
  //RxBool haveProduct = false.obs;
  // RxBool postProduct = false.obs;
  // List<MasterItemsModel> products = [];
  RxString tagNumber = ''.obs;
  RxString ipAdd = ''.obs;
  RxString user = ''.obs;
  RxString storeID = ''.obs;

  /*Future<void> productList(String tagNum, String ipAddress, String store) async {
    try{
      tagNumber.value = tagNum;
      ipAdd.value = ipAddress;
      storeID.value = store;
      haveProduct(true);
      var response = await http.get(Uri.parse(
          "http://$ipAddress/unistock/zebra/productlist_tag_device.php?tag_no=$tagNum&userID=${login.userId.value}"));
      if (response.statusCode == 200) {
        haveProduct(false);
        products = masterItemsModelFromJson(response.body);
      } else {
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage = responseBody['error'] as String;
        haveProduct(false);
        Get.snackbar('Warning!', errorMessage,
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP);
        products = [];
      }
    }catch(e){
      print('Error: $e');
      haveProduct(false);
      Get.snackbar('Warning!', 'Failed to connect server',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
    }
  }*/

/*  TextEditingController searchByName = TextEditingController();
  //search mechanism for any name
  RxString searchQuery = ''.obs;

  // Filter suppliers based on search query
  List get filteredProductList {
    if (searchQuery.value.isEmpty) {
      return products.toList();
    } else {
      return products.where((addedProducts) {
        final lowerCaseQuery = searchQuery.value.toLowerCase();
        return addedProducts.itemCode!.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }
  }*/

  // Set the search query
/*  void search(String query) {
    searchQuery.value = query;
  }*/

  void clearValue() {
    tagNumber.close();
    ipAdd.close();
    user.close();
    storeID.close();
  }

  //addItem(automatically)
  RxBool postProduct = false.obs;
  List<AddedProductList> productList = [];
  Future<void> addItem(
      String ipAddress,
      String itemCode,
      String tagNum,
      String storeId,
      String deviceID) async {
    try{
      tagNumber.value = tagNum;
      ipAdd.value = ipAddress;
      storeID.value = storeId;
      postProduct(true);
      var response = await http.post(
          Uri.parse("http://$ipAddress/unistock/zebra/add_item.php"),
          body: jsonEncode(<String, dynamic>{
            "item": itemCode,
            "user_id": login.userId.value,
            "qty": 1.0,
            "tag_no": tagNum,
            "store": storeId,
            "device": deviceID
          }));
      if(response.statusCode == 200){
        postProduct(false);
        productList = addedProductListFromJson(response.body);
      }else if(response.statusCode == 406){
        postProduct(false);
        Get.snackbar('Error', 'Invalid item code length.',
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP
        );
        productList = addedProductListFromJson(response.body);
      }else if(response.statusCode == 400){
        postProduct(false);
        Get.snackbar('Error', 'Direct Supplier code cannot be scanned.',
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP
        );
        productList = addedProductListFromJson(response.body);
      }else{
        postProduct(false);
        Get.snackbar('Error', 'Invalid product code',
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP
        );
        productList = addedProductListFromJson(response.body);
      }
    }catch(e){
      print('Error: $e');
      postProduct(false);
      Get.snackbar('Warning!', 'Failed to connect server',
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
  RxBool isUpdate = false.obs;
  Future<void> updateQty(
      String ipAddress,
      String itemCode,
      String tagNum,
      String storeId,
      String deviceID) async {
    try{
      isUpdate(true);
      BotToast.showLoading();
      if (qtyCon.text.isEmpty) {
        qtyCon.text = quantity.value.toString();
        var response = await http.post(
            Uri.parse("http://$ipAddress/unistock/zebra/update.php"),
            body: jsonEncode(<String, dynamic>{
              "item": itemCode,
              "user_id": login.userId.value,
              "qty": qtyCon.text.toString(),
              "device": deviceID,
              "tag_no": tagNum
            },
          ),
        );
      } else {
        var response = await http.post(
            Uri.parse("http://$ipAddress/unistock/zebra/update.php"),
            body: jsonEncode(<String, dynamic>{
              "item": itemCode,
              "user_id": login.userId.value,
              "qty": qtyCon.text.toString(),
              "device": deviceID,
              "tag_no": tagNum
            },
          ),
        );
      }
      isUpdate(false);
      BotToast.closeAllLoading();
      qtyCon.clear();
      quantity.value = 0;
    }catch(e){
      isUpdate(false);
      BotToast.closeAllLoading();
      Get.snackbar('Warning!', 'Failed to connect server',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
      );
    }
  }

  //adjustment quantity
  Future<void> adjustmentQty(
      context,
      double totalQty,
      String ipAddress,
      String itemCode,
      String tagNum,
      String storeId,
      String deviceID,
      ) async {
    try{
      if (double.parse(qtyCon.text) > totalQty) {
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
          var response = await http.post(
              Uri.parse("https://$ipAddress/unistock/zebra/adjustment.php"),
              body: jsonEncode(<String, dynamic>{
                "item": itemCode,
                "user_id": login.userId.value,
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
              snackPosition: SnackPosition.TOP);
          Navigator.pop(context);
        } else {
          var response = await http.post(
              Uri.parse("http://$ipAddress/unistock/zebra/adjustment.php"),
              body: jsonEncode(<String, dynamic>{
                "item": itemCode,
                "user_id": login.userId.value,
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
    }catch(e){
      Get.snackbar('Warning!', 'Failed to connect server',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
    }
  }

  //make the active and di-active function
  RxBool isEnabled = true.obs;

  void enableButton(bool value) {
    FlutterDataWedge.enableScanner(value);
    isEnabled.value = value;
  }

  //increment function
  RxDouble quantity = 0.0.obs;
  //making textField iterable update the value of both textController and quantity
  void updateTQ(String value) {
    qtyCon.text = value;
    quantity.value = double.parse(value);
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

  ///for update auto scan field in the auto scan edit screen
  TextEditingController automaticProductCode = TextEditingController();
  TextEditingController automaticQty = TextEditingController();
  AutomaticAddedProductModel? automaticAddedProductModel;
  RxBool isAutoUpdate = false.obs;
  RxBool isAutoFieldEmpty = false.obs;
  LastAutoAddedProductModel? lastAutoAddedProductModel;
  Future<String> updateAutomaticScanned(BuildContext context, String ipAddress, String deviceID, String userId, String tagNum, String storeId, String itemCode) async {
    BotToast.showLoading();
    if (automaticProductCode.text.isEmpty || automaticQty.text.isEmpty) {
      isAutoUpdate(false);
      BotToast.closeAllLoading();
      isAutoFieldEmpty(true);
      Get.snackbar(
        'Warning!',
        'Please fill up all the fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return 'Fail';
    }
    try {
      if(automaticQty.text.startsWith('-')) {
        isAutoUpdate(true);
        final response = await http.post(
          Uri.parse("http://$ipAddress/unistock/zebra/autoScanUpdate.php"),
          body: jsonEncode(<String, dynamic>{
            "xitem": itemCode,
            "user_id": userId,
            "qty": automaticQty.text,
            "tag_no": tagNum,
            "store": storeId,
            "device": deviceID,
          }),
        );
        if (response.statusCode == 200) {
          clearAutoEditScreenTextField();
          lastAutoAddedProductModel =
              lastAutoAddedProductModelFromJson(response.body);
          Get.snackbar(
            'Success',
            'Product updated successfully',
            backgroundColor: ConstantColors.uniGreen,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          isAutoUpdate(false);
          isAutoFieldEmpty(false);
          BotToast.closeAllLoading();
          return 'Success';
        } else {
          isAutoUpdate(false);
          isAutoFieldEmpty(false);
          BotToast.closeAllLoading();
          if (context.mounted) {
            final responseBody = json.decode(response.body) as Map<String, dynamic>;
            final errorMessage = responseBody['error'] as String;
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  ReusableAlerDialogue(
                    headTitle: "Warning!",
                    message: errorMessage,
                    btnText: "Back",
                  ),
            );
            return 'Fail';
          }
        }
      }else{
        isAutoUpdate(false);
        isAutoFieldEmpty(true);
        BotToast.closeAllLoading();
        Get.snackbar(
          'Warning!',
          'Quantity must be negative',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return 'Fail';
      }
    } catch (e) {
      print('Error occured :$e ');
      isAutoUpdate(false);
      isAutoFieldEmpty(false);
      BotToast.closeAllLoading();
      Get.snackbar(
        'Warning!',
        'Failed to connect to the server',
        borderWidth: 1.5,
        borderColor: Colors.black54,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
    return '';
  }

  Future<String> getSearchedAutomaticProduct(String tagNum, String itemCode) async {
    isAutoUpdate(true);
    try {
      print('itemCode for post: $itemCode');
      final response = await http.get(
        Uri.parse('http://${login.serverIp.value}/unistock/zebra/autoSearchedProduct.php?tag_no=$tagNum&userID=${login.userId.value}&device=${login.deviceID.value}&xitem=$itemCode'),
      );

      if (response.statusCode == 200) {
        automaticAddedProductModel = automaticAddedProductModelFromJson(response.body);
        print('Return item code: ${automaticAddedProductModel!.itemCode} && Description: ${automaticAddedProductModel!.itemDesc}');
        return 'Success';
      } else {
        automaticAddedProductModel = null;
        return 'Fail';
      }
    } catch (e) {
      automaticAddedProductModel = null;
      return 'Fail';
    } finally {
      isAutoUpdate(false);
    }
  }

  void clearAutoEditScreenTextField(){
    automaticProductCode.clear();
    automaticAddedProductModel = null;
    automaticQty.clear();
  }

  void releaseAutoEditScreenVariables(){
    isAutoUpdate.value = false;
    isAutoFieldEmpty.value = false;
    automaticProductCode.clear();
    automaticQty.clear();
    automaticAddedProductModel = null;
    lastAutoAddedProductModel = null;
  }
}
