import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/db_helper/offline_repo.dart';
import 'package:zebra_scanner_final/model/last_added_item_model.dart';
import '../constants/const_colors.dart';
import '../model/manual_added_product_model.dart';
import '../widgets/reusable_alert.dart';

class ManualController extends GetxController {
  LoginController login = Get.find<LoginController>();
  TextEditingController productCode = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  RxString lastCode = ''.obs;
  RxBool isEmptyField = false.obs;
  LastAddedProductModel? lastAddedItem;

  Future<void> addItemManually(BuildContext context, String idAddress, String deviceID, String userId, String tagNum, String storeId) async {
    BotToast.showLoading();
    if (productCode.text.isEmpty || qtyController.text.isEmpty) {
      entryDone(false);
      BotToast.closeAllLoading();
      isEmptyField(true);
      Get.snackbar(
        'Warning!',
        'Please fill up all the fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    try {
      entryDone(true);
      final response = await http.post(
        Uri.parse("http://$idAddress/unistock/zebra/manual_Add.php"),
        body: jsonEncode(<String, dynamic>{
          "item": productCode.text,
          "user_id": userId,
          "qty": qtyController.text,
          "tag_no": tagNum,
          "store": storeId,
          "device": deviceID,
        }),
      );
      if (response.statusCode == 200) {
        clearTextField();
        lastAddedItem = lastAddedProductModelFromJson(response.body);
        Get.snackbar(
          'Success',
          'Product added successfully',
          backgroundColor: ConstantColors.uniGreen,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        entryDone(false);
        isEmptyField(false);
        BotToast.closeAllLoading();
      } else {
        entryDone(false);
        isEmptyField(false);
        if (context.mounted) {
          BotToast.closeAllLoading();
          final responseBody = json.decode(response.body) as Map<String, dynamic>;
          final errorMessage = responseBody['error'] as String;
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => ReusableAlerDialogue(
              headTitle: "Warning!",
              message: errorMessage,
              btnText: "Back",
            ),
          );
        }
      }
    } catch (e) {
      entryDone(false);
      isEmptyField(false);
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
  }

  //for manual add in online mode
  ManualAddedProductModel? manualAddedProduct;
  RxBool entryDone = false.obs;
  Future<String> getManualAddedProduct(String tagNum, String itemCode) async {
    entryDone(true);
    try {
      final response = await http.get(
        Uri.parse('http://${login.serverIp.value}/unistock/zebra/searchedProduct.php?tag_no=$tagNum&userID=${login.userId.value}&device=${login.deviceID.value}&item=$itemCode'),
      );

      if (response.statusCode == 200) {
        manualAddedProduct = manualAddedProductModelFromJson(response.body);
        return 'Success';
      } else {
        manualAddedProduct = null;
        return 'Fail';
      }
    } catch (e) {
      manualAddedProduct = null;
      return 'Fail';
    } finally {
      entryDone(false);
    }
  }




  Future<void> addManuallyOffline(BuildContext context) async {
    entryDone(true);
    BotToast.showLoading();
    if(productCode.text.isEmpty || qtyController.text.isEmpty){
      entryDone(false);
      isEmptyField(true);
      BotToast.closeAllLoading();
      Get.snackbar('Warning!',
          'Please fill up all the field',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }else{
      try{
        int result = await OfflineRepo().manualEntry(productCode.text, qtyController.text, login.deviceID.value, login.userId.value);
        if(result == 0){
          clearTextField();
          Get.snackbar('Success', 'Product added',
            backgroundColor: ConstantColors.uniGreen,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }else{
          Get.snackbar(
              'Warning!', "Invalid code",
              borderWidth: 1.5,
              borderColor: Colors.black54,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.TOP);
        }
        entryDone(false);
        isEmptyField(false);
        BotToast.closeAllLoading();
      }catch(e){
        entryDone(false);
        isEmptyField(false);
        BotToast.closeAllLoading();
        Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  //for manual add in offline mode
  List singleAddedProducts = [];
  Future<String> getSingleScannedProduct() async{
    try {
      entryDone(true);
      singleAddedProducts = await OfflineRepo().getManualAddedProduct(productCode.text);
      entryDone(false);
      if(singleAddedProducts.isEmpty){
        return 'Fail';
      }else{
        return 'Success';
      }
    } catch (error) {
      entryDone(false);
      singleAddedProducts = [];
      return 'Fail';
    }
  }

  void clearTextField(){
    productCode.clear();
    manualAddedProduct = null;
    singleAddedProducts = [];
    qtyController.clear();
  }

  void releaseVariables(String mode){
    entryDone.value = false;
    isEmptyField.value = false;
    productCode.clear();
    qtyController.clear();
    if(mode == 'Online'){
      manualAddedProduct = null;
      lastAddedItem = null;
    }else{
      singleAddedProducts = [];
    }
  }
}