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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  //API for ProductList
  RxBool haveProduct = false.obs;
  RxBool postProduct = false.obs;
  List<ProductListModel> products = [];

  Future<void> productList(String tagNum, String ipAddress) async {
    print(ipAddress);
    haveProduct(true);
    var response = await http.get(Uri.parse(
        "http://$ipAddress/sina/unistock/zebra/productlist_tag_device.php?tag_no=$tagNum"));
    if (response.statusCode == 200) {
      print(response.body);
      print("++++++++++++++++$tagNum");
      print("++++++++++++++++$ipAddress");
      haveProduct(false);
      products = productListModelFromJson(response.body);
    } else {
      haveProduct(false);
      print(response.body);
      print("++++++++++++++++$tagNum");
      print("++++++++++++++++$ipAddress");
      products = [];
    }
  }

  //addItem(automatically)
  Future<void> addItem(
      String ipAddress,
      String itemCode,
      String userId,
      String tagNum,
      String adminId,
      String outlet,
      String storeId,
      String deviceID) async {
    postProduct(true);
    var response = await http.post(
        Uri.parse("http://$ipAddress/sina/unistock/zebra/add_item.php"),
        body: jsonEncode(<String, dynamic>{
          "item": itemCode,
          "user_id": "010340",
          "qty": 1,
          "tag_no": tagNum,
          "admin_id": adminId,
          "outlet": outlet,
          "store": storeId,
          "device": deviceID
        }));
    print("==========${response.body}");
    print("==========$ipAddress");
    print("==========$deviceID");
    postProduct(false);
  }

  //update quantity
  Future<void> updateQty(
      String ipAddress,
      String itemCode,
      String userId,
      String tagNum,
      String adminId,
      String outlet,
      String storeId,
      String deviceID) async {
    if (qtyCon.text.isEmpty) {
      qtyCon.text = quantity.value.toString();
      print('=========${qtyCon.text}');
      var response = await http.post(
          Uri.parse("http://$ipAddress/sina/unistock/zebra/update.php"),
          body: jsonEncode(<String, dynamic>{
            "item": itemCode,
            "user_id": "010340",
            "qty": qtyCon.text.toString(),
            "device": deviceID
          }));
      print("==========${response.body}");
      print("==========$ipAddress");
      print("==========$deviceID");
    } else {
      print('=========${qtyCon.text}');
      var response = await http.post(
          Uri.parse("http://$ipAddress/sina/unistock/zebra/update.php"),
          body: jsonEncode(<String, dynamic>{
            "item": itemCode,
            "user_id": "010340",
            "qty": qtyCon.text.toString(),
            "device": deviceID
          }));
      print("==========${response.body}");
      print("==========$ipAddress");
      print("==========$deviceID");
    }
    qtyCon.clear();
    quantity.value = 0;
  }

  //make the active and di-active function
  RxBool isEnabled = true.obs;

  void enableButton(bool value) {
    FlutterDataWedge.enableScanner(value);
    isEnabled.value = value;
  }

  //increment function
  RxInt quantity = 0.obs;

  //making textField iterable update the value of both textController and quantity
  void updateTQ(String value) {
    qtyCon.text = value;
    quantity.value = int.parse(value);
    print('update first quantity with the total amount : ${quantity.value}');
    print('update first textController with the total amount : ${qtyCon.text}');
  }

  void incrementQuantity() {
    quantity.value = quantity.value + 1;
    qtyCon.text = quantity.value.toString();
    print('--------${qtyCon.text}==========${quantity.value}');
  }

  void decrementQuantity() {
    if (quantity.value <= 0) {
      Get.snackbar('Warning!', "You do not have quantity for decrement");
    } else {
      quantity.value = quantity.value - 1;
      qtyCon.text = quantity.value.toString();
      print('--------${qtyCon.text}==========${quantity.value}');
    }
  }
}
