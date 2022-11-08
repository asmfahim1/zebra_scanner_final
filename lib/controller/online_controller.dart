import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/controller/server_controller.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import '../model/productList_model.dart';
import '../widgets/const_colors.dart';

class OnlineController extends GetxController {
  RxString scannerStatus = "Scanner status".obs;
  RxString lastCode = ''.obs;
  TextEditingController qtyCon = TextEditingController();
  ConstantColors colors = ConstantColors();

  ServerController serverController = Get.put(ServerController());

  @override
  void onInit() {
    // TODO: implement onInit
    print("++++++++++++++++${serverController.deviceID}");
    productList();
    super.onInit();
  }

  //API for ProductList
  RxBool haveProduct = false.obs;
  RxBool postProduct = false.obs;
  List<ProductListModel> products = [];
  Future<void> productList() async {
    haveProduct(true);
    var response = await http.get(Uri.parse(
        "http://172.20.20.69/sina/unistock/zebra/productlist_device.php"));
    /*body: <String, dynamic>{"device": serverController.deviceID});*/
    if (response.statusCode == 200) {
      print(response.body);
      haveProduct(false);
      products = productListModelFromJson(response.body);
    } else {
      haveProduct(false);
      products = [];
    }
  }

  //update quantity
  Future<void> updateQty(String amt, String item) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/update_item.php"),
        body: jsonEncode(<String, dynamic>{"item": item, "qty": amt}));
    print("=======$response");
  }

  //addItem(automatically)
  Future<void> addItem(String itemCode, String userId, String tagNum,
      String adminId, String outlet, String storeId) async {
    postProduct(true);
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/zebra/add_item.php"),
        body: jsonEncode(<String, dynamic>{
          "item": itemCode,
          "user_id": "010340",
          "qty": 1,
          "tag_no": tagNum,
          "admin_id": adminId,
          "outlet": outlet,
          "store": storeId,
          "device": serverController.deviceID
        }));
    print("==========${response.body}");
    postProduct(false);
    productList();
  }

  //make the active and di-active function
  RxBool isEnabled = true.obs;
  void enableButton() {
    FlutterDataWedge.enableScanner(!isEnabled.value);
    isEnabled.value = !isEnabled.value;
  }
}
