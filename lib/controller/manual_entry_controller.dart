import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/controller/login_controller.dart';
import '../constants/const_colors.dart';
import '../widgets/reusable_alert.dart';

class ManualController extends GetxController {
  LoginController login = Get.find<LoginController>();
  //manual entry functionality
  TextEditingController productCode = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  RxBool entryDone = false.obs;
  RxBool isEmptyField = false.obs;

  Future<void> addItemManually(BuildContext context, String idAddress,String deviceID,String userId,String tagNum,String storeId) async {
      entryDone(true);
      if(productCode.text.isEmpty || qtyController.text.isEmpty){
        print("If statement enter");
        entryDone(false);
        isEmptyField(true);
        Get.snackbar('Warning!',
            'Please fill up all the field',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }else{
        try{
          print('qty controller : ${qtyController.text}');
          var response = await http.post(
              Uri.parse("http://$idAddress/unistock/zebra/manual_Add.php"),
              body: jsonEncode(<String, dynamic>{
                "item": productCode.text,
                "user_id": login.userId.value,
                "qty": qtyController.text,
                "tag_no": tagNum,
                "store": storeId,
                "device": deviceID
              }));
          if(response.statusCode == 200){
            entryDone(false);
            isEmptyField(false);
            clearTextField();
            Get.snackbar('Success', 'Product added',
              backgroundColor: ConstantColors.uniGreen,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }else{
            entryDone(false);
            isEmptyField(false);
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => ReusableAlerDialogue(
                headTitle: "Warning!",
                message: "Invalid item code",
                btnText: "Back",
              ),
            );
            print('Error posting value: ${response.statusCode}');
          }
        }catch(e){
          entryDone(false);
          isEmptyField(false);
          Get.snackbar('Error', 'Something went wrong',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          print('Exception : $e');
        }
      }
  }


  Future<void> addManuallyOffline(BuildContext context) async {
    entryDone(true);
    if(productCode.text.isEmpty || qtyController.text.isEmpty){
      print("If statement enter");
      entryDone(false);
      isEmptyField(true);
      Get.snackbar('Warning!',
          'Please fill up all the field',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }else{
      try{
        //insert into scanner table
      }catch(e){
        entryDone(false);
        isEmptyField(false);
        Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        print('Exception : $e');
      }
    }
  }


  void clearTextField(){
    productCode.clear();
    qtyController.clear();
  }
}