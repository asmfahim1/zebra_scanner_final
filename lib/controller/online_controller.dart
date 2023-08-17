import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import '../model/productList_model.dart';
import '../constants/const_colors.dart';

class OnlineController extends GetxController {
  LoginController login = Get.find<LoginController>();
  RxString scannerStatus = "Scanner status".obs;
  RxString lastCode = ''.obs;
  TextEditingController qtyCon = TextEditingController();
  ConstantColors colors = ConstantColors();

  //API for ProductList
  RxBool haveProduct = false.obs;
  RxBool postProduct = false.obs;
  List<MasterItemsModel> products = [];
  RxString tagNumber = ''.obs;
  RxString ipAdd = ''.obs;
  RxString user = ''.obs;
  RxString storeID = ''.obs;

  Future<void> productList(String tagNum, String ipAddress, String store) async {
    try{
      tagNumber.value = tagNum;
      ipAdd.value = ipAddress;
      storeID.value = store;
      haveProduct(true);
      var response = await http.get(Uri.parse(
          "http://$ipAddress/unistock/zebra/productlist_tag_device.php?tag_no=$tagNum&userID=${login.userId.value}"));
      if (response.statusCode == 200) {
        //print(response.body);
        haveProduct(false);
        products = masterItemsModelFromJson(response.body);
      } else {
        haveProduct(false);
        Get.snackbar('Warning!', 'Failed to fetch products',
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP);
        products = [];
      }
    }catch(e){
      haveProduct(false);
      Get.snackbar('Warning!', 'Failed to connect server',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
      print('There is a issue connecting to internet: $e');
    }
  }

  void clearValue() {
    tagNumber.close();
    ipAdd.close();
    user.close();
    storeID.close();
  }

  //addItem(automatically)
  Future<void> addItem(
      String ipAddress,
      String itemCode,
      String tagNum,
      String storeId,
      String deviceID) async {
    try{
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
        print('response : ${response.statusCode}');
        postProduct(false);
      } else{
        print('response : ${response.statusCode}');
        postProduct(false);
        Get.snackbar('Error', 'Invalid item code',
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
        );
        print('Error occurred: ${response.statusCode}');
      }
    }catch(e){
      postProduct(false);
      Get.snackbar('Warning!', 'Failed to connect server',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
      print('There is a issue connecting to internet: $e');
    }
  }

  //manual entry quantity
  Future<void> updateQty(
      String ipAddress,
      String itemCode,
      String tagNum,
      String outlet,
      String storeId,
      String deviceID) async {
    try{
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
            }));
        print('manual response: ${response.statusCode}');
      } else {
        var response = await http.post(
            Uri.parse("http://$ipAddress/unistock/zebra/update.php"),
            body: jsonEncode(<String, dynamic>{
              "item": itemCode,
              "user_id": login.userId.value,
              "qty": qtyCon.text.toString(),
              "device": deviceID,
              "tag_no": tagNum
            }));
        print('manual response: ${response.statusCode}');
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
      print('Somthing went wrong manual: $e');
    }
  }

  //adjustment quantity
  Future<void> adjustmentQty(
      context,
      double totalQty,
      String ipAddress,
      String itemCode,
      String tagNum,
      String outlet,
      String storeId,
      String deviceID) async {
    try{
      print('item: $itemCode');
      print('user: ${login.userId.value}');
      print('qty: ${qtyCon.text.toString()}');
      print('deviceId: $deviceID');
      print('tagnum: $tagNum');
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
          print("==========${response.statusCode}");
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
          print("==========${response.statusCode}");
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
      print('Somthing went wrong : $e');
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
    print('update first quantity with the total amount : ${quantity.value}');
    print('update first textController with the total amount : ${qtyCon.text}');
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
}
