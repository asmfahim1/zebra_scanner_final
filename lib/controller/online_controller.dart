import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/productList_model.dart';
import '../widgets/const_colors.dart';

class OnlineController extends GetxController {
  String scannerStatus = "Scanner status";
  String lastCode = '';
  TextEditingController qtyCon = TextEditingController();
  ConstantColors colors = ConstantColors();

  //API for ProductList
  RxBool haveProduct = false.obs;
  List<ProductList> products = [];
  Future<void> productList(String deviceId) async {
    haveProduct(true);
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/allProductList.php"),
        body: <String, dynamic>{"deviceId": deviceId});

    if (response.statusCode == 200) {
      products = productListFromJson(response.body);
      print(response.body);
    } else {
      products = [];
    }
    haveProduct(false);
  }

  //update quantity
  Future<void> updateQty(String amt, String item) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/update_item.php"),
        body: jsonEncode(<String, dynamic>{"item": item, "qty": amt}));
    print("=======$response");
  }

  //autoscann
  Future<void> autoScan(String tagNum, String adminId, String outlet,
      String storeId, String deviceId) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/scan_only.php"),
        body: jsonEncode(<String, dynamic>{
          "item": lastCode.toString(),
          "user_id": "010340",
          "qty": 1,
          "tag_no": "010340",
          "admin_id": "010340",
          "outlet": "010340",
          "store": "010340",
          "device": deviceId
        }));
    print("==========${response.body}");
    //productList();
  }
}
