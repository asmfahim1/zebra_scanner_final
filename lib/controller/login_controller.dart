import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/constants/const_colors.dart';
import '../model/login_model.dart';
import '../view/mode_selector_screen.dart';
import '../widgets/reusable_alert.dart';

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
  late LoginModel loginModel;
  RxString userId = ''.obs;

  Future<void> loginMethod(
      String deviceId, String ipAddress, BuildContext context) async {
    try{
      isLoading(true);
      var response = await http.get(Uri.parse(
          'http://$ipAddress/unistock/zebra/login.php?zemail=${user.text}&xpassword=${pass.text}'));
      if (response.statusCode == 200) {
        loginModel = loginModelFromJson(response.body);
        if(user.text == loginModel.zemail && pass.text == loginModel.xpassword){
          isLoading(false);
          userId.value = loginModel.xposition.toString();
          Get.to(() => const ModeSelect());
          Get.snackbar('Success!', "Successfully logged in",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: ConstantColors.comColor.withOpacity(0.4),
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
          );
        }else{
          isLoading(false);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => ReusableAlerDialogue(
              headTitle: "Warning!",
              message: "Invalid user name or password",
              btnText: "Back",
            ),
          );
        }
      } else if (response.statusCode == 404) {
        isLoading(false);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => ReusableAlerDialogue(
            headTitle: "Warning!",
            message: "Invalid userid or password",
            btnText: "Back",
          ),
        );
      }
    }catch(e){
      isLoading(false);
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

  //for exit the app
  Future<bool?> showWarningContext(BuildContext context) async => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Exit',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text(
              'Do you want to exit the app?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ConstantColors.uniGreen.withOpacity(0.5),
          ),
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "No",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ConstantColors.comColor.withOpacity(0.5),
          ),
          onPressed: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
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
