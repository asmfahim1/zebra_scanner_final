import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/db_helper/offline_repo.dart';
import '../constants/const_colors.dart';
import '../model/manual_added_product_model.dart';
import '../widgets/reusable_alert.dart';

class ManualController extends GetxController {
  LoginController login = Get.find<LoginController>();
  TextEditingController productCode = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  RxString lastCode = ''.obs;
  RxBool isEmptyField = false.obs;

  Future<void> addItemManually(BuildContext context, String idAddress,String deviceID,String userId,String tagNum,String storeId) async {
      BotToast.showLoading();
      if(productCode.text.isEmpty || qtyController.text.isEmpty){
        //entryDone(false);
        BotToast.closeAllLoading();
        isEmptyField(true);
        Get.snackbar('Warning!',
            'Please fill up all the field',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }else{
        try{
          //entryDone(true);
          var response = await http.post(
              Uri.parse("http://$idAddress/unistock/zebra/manual_Add.php"),
              body: jsonEncode(<String, dynamic>{
                "item": productCode.text,
                "user_id": userId,
                "qty": qtyController.text,
                "tag_no": tagNum,
                "store": storeId,
                "device": deviceID
              }));
          if(response.statusCode == 200){
            clearTextField();
            //await getManualAddedProduct(tagNum,userId);
            Get.snackbar('Success', 'Product added',
              backgroundColor: ConstantColors.uniGreen,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            //entryDone(false);
            isEmptyField(false);
            BotToast.closeAllLoading();
          }else{
            //entryDone(false);
            isEmptyField(false);
            BotToast.closeAllLoading();
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => ReusableAlerDialogue(
                headTitle: "Warning!",
                message: "Invalid item code",
                btnText: "Back",
              ),
            );
          }
        }catch(e){
          //entryDone(false);
          isEmptyField(false);
          BotToast.closeAllLoading();
          Get.snackbar('Warning!', 'Failed to connect server',
              borderWidth: 1.5,
              borderColor: Colors.black54,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.TOP
          );
        }
      }
  }

  //for manual add in online mode
  ManualAddedProductModel? manualAddedProduct;
  RxBool entryDone = false.obs;
  Future<void> getManualAddedProduct(String tagNum,String itemCode,) async{
    try {
      entryDone(true);
      var response = await http
          .get(Uri.parse('http://${login.serverIp.value}/unistock/zebra/searchedProduct.php?tag_no=$tagNum&userID=${login.userId.value}&device=${login.deviceID.value}&item=$itemCode'));
      if (response.statusCode == 200) {
        entryDone(false);
        manualAddedProduct = manualAddedProductModelFromJson(response.body);
      } else {
        entryDone(false);
        manualAddedProduct =null;
        /*Get.snackbar('Warning!', 'Invalid code',
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP);*/
      }
      entryDone(false);
    } catch (e) {
      entryDone(false);
      manualAddedProduct = null;
      print('There is a issue connecting to internet: $e');
    }
  }




  Future<void> addManuallyOffline(BuildContext context) async {
    entryDone(true);
    if(productCode.text.isEmpty || qtyController.text.isEmpty){
      entryDone(false);
      isEmptyField(true);
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
      }catch(e){
        entryDone(false);
        isEmptyField(false);
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
  Future<void> getSingleScannedProduct() async{
    try {
      entryDone(true);
      singleAddedProducts = await OfflineRepo().getManualAddedProduct();
      entryDone(false);
    } catch (error) {
      entryDone(false);
      print('There are some issue getting cart header list: $error');
    }
  }

  void clearTextField(){
    productCode.clear();
    qtyController.clear();
  }

  void releaseVariables(){
    // Clear the fields and variables within the manual controller
    productCode.clear(); // Clear the TextEditingController
    qtyController.clear(); // Clear the TextEditingController
    // Reset other variables or states within the manual controller if needed
   entryDone.value = false;
   manualAddedProduct = null;
  }
}