import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/model/productList_model.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import '../constants/app_constants.dart';
import '../db_helper/master_item.dart';
import '../view/mode_selector_screen.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginKey = GlobalKey();
  ConstantColors colors = ConstantColors();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  var obscureText = true.obs;

  void toggle() {
    print('$obscureText');
    obscureText.value = !obscureText.value;
    print('$obscureText');
  }

  RxBool isChecked = false.obs;
  //login method
  RxBool isLoading = false.obs;

  Future<void> loginMethod(
      String deviceId, String ipAddress, BuildContext context) async {
    isLoading(true);
    var response = await http.get(Uri.parse(
        'http://$ipAddress/unistock/zebra/login.php?user=${user.text}&password=${pass.text}'));
    if (response.statusCode == 200) {
      isLoading(false);
      Get.to(() => const ModeSelect());
      Get.snackbar('Success!', "Successfully logged in",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: ConstantColors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
      );
    } else if (response.statusCode == 404) {
      isLoading(false);
      Get.snackbar('Warning!', "Invalid IP Address",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: ConstantColors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
      );
    }
  }

  //load master data
  RxBool isFetched = false.obs;
  List<MasterItemsModel>? masterModel;

  Future<Object> fetchMasterItemsList() async {
    try {
      isFetched(true);
      var responseMaster = await http.get(Uri.parse('http://${AppConstants.baseurl}/unistock/masterItem.php?xcus=SUP-070000'));
      if (responseMaster.statusCode == 200) {
        //masterModel = productListModelFromJson(responseMaster.body);
        //await dropTerritoryTable();
        print("Master item List = ${responseMaster.body}");
        (json.decode(responseMaster.body) as List).map((territoryList) {
          MasterItems().insertToMasterTable(MasterItemsModel.fromJson(territoryList));
        }).toList();
        isFetched(false);
        Get.snackbar('Success', 'Data Fetched successfully',
            backgroundColor: Colors.white,
            duration: const Duration(seconds: 1));
        return 'Territory list fetched Successfully';
      } else {
        Get.snackbar('Error', 'Something went wrong',
            backgroundColor: Colors.red, duration: const Duration(seconds: 1));
        print('Error occurred: ${responseMaster.statusCode}');
        isFetched(false);
        return 'Error in fetching data';
      }
    } catch (error) {
      print('There is a issue occured when territory fetching: $error');
      isFetched(false);
      return 'Error in the method';
    }
  }
}

/*showDialog(
context: context,
builder: (context) {
return AlertDialog(
title: const Text(
'Warning!',
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.w800,
color: Colors.black54),
),
content: const Text(
'Invalid username or password',
style: TextStyle(fontSize: 30, color: Colors.black),
),
actions: [
TextButton(
style: TextButton.styleFrom(
backgroundColor: Colors.blue.shade400,
),
onPressed: () async {
Get.back();
},
child: Text(
"Ok",
style: GoogleFonts.urbanist(
color: Colors.black,
fontWeight: FontWeight.w600,
),
),
),
],
scrollable: true,
);
});*/
