import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import '../model/login_model.dart';
import '../view/mode_selector_screen.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginKey = GlobalKey();
  ConstantColors colors = ConstantColors();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  var obscureText = true.obs;

  void toggle() {
    obscureText.value = !obscureText.value;
  }

  RxBool isChecked = false.obs;
  //login method
  RxBool isLoading = false.obs;
  late LoginModel loginModel;
  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString serverIp = ''.obs;
  RxString deviceID = ''.obs;
  RxString accessToken = ''.obs;

  Future<void> loginMethod(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading(true);
    serverIp.value = prefs.getString('ipAddress')!;
    deviceID.value = prefs.getString('deviceId')!;
    try {
      if(user.text.isEmpty && pass.text.isEmpty){
        Get.defaultDialog(
          title: "Warning!",
          middleText: 'User id or Password can not be empty',
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text("Back"),
          ),
        );
      }else{
        final response = await http.get(
          Uri.parse(
              'http://${serverIp.value}/unistock/zebra/login.php?zemail=${user.text}&xpassword=${pass.text}&device=${deviceID.value.toString()}'),
        );

        final responseBody = json.decode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 200) {
          loginModel = loginModelFromJson(response.body);
          await prefs.setString('accessToken', loginModel.xaccess.toString());
          await prefs.setString('userName', loginModel.name.toString());
          await prefs.setString('userID', loginModel.xposition.toString());
          accessToken.value = prefs.getString('accessToken')!;
          userId.value = prefs.getString('userID')!;
          userName.value = prefs.getString('userName')!;
          Get.to(() => const ModeSelect());
          Get.snackbar(
            'Success!',
            "Successfully logged in",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: ConstantColors.comColor.withOpacity(0.6),
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
          );
        } else {
          final errorMessage = responseBody['error'] as String;
          Get.defaultDialog(
            title: "Warning!",
            middleText: errorMessage,
            confirm: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Back"),
            ),
          );
        }
      }
    } catch (e) {
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
    } finally {
      isLoading(false);
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
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
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

  //clear cache memory
  Future<void> clearCache() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      print('Preferences are removed');
      /*await prefs.remove('ipAddress');
      await prefs.remove('deviceId');*/
      await prefs.remove('accessToken');
      await prefs.remove('userName');
      await prefs.remove('userId');
    }catch(e){
      log("Failed to clear cache");
    }

  }
}
