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
  RxBool isEnabled = true.obs;
  TextEditingController qtyCon = TextEditingController();
  ConstantColors colors = ConstantColors();
  //API for ProductList
  RxBool haveProduct = false.obs;
  List<ProductList> products = [];
  Future<void> productList() async {
    haveProduct(true);
    var response = await http
        .get(Uri.parse("http://172.20.20.69/sina/unistock/allProductList.php"));

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
  Future<void> autoScan(String lastCode) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/scan_only.php"),
        body: jsonEncode(<String, dynamic>{
          "item": lastCode,
          "xwh": "Sina",
          "prep_id": "6"
        }));
    print("==========${response.body}");
    productList();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    productList();
    initScanner();
    super.onInit();
  }

  void initScanner() async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) {
          lastCode = result.data;
          autoScan(lastCode);
        },
        onStatusUpdate: (result) {
          ScannerStatusType status = result.status;
          scannerStatus = status.toString().split('.')[1];
        });
  }
}
