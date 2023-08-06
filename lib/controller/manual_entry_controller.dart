import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/const_colors.dart';

class ManualController extends GetxController {

  //manual entry functionality
  TextEditingController productCode = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  RxBool entryDone = false.obs;
  RxBool isEmptyField = false.obs;
  //addItem(automatically)
  Future<void> addItemManually(String idAddress,String deviceID,String userId,String tagNum,String storeId) async {
      entryDone(true);
      print('${productCode.text}=========================${qtyController.text}');
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
        isEmptyField(false);
        print("Else statement enter");
        try{
          var response = await http.post(
              Uri.parse("http://$idAddress/unistock/zebra/add_item.php"),
              body: jsonEncode(<String, dynamic>{
                "item": productCode.text,
                "user_id": userId,
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

  void clearTextField(){
    productCode.clear();
    qtyController.clear();
  }
}