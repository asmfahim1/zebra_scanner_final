import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import '../model/login_model.dart';
import '../view/login_screen.dart';
import '../view/mode_selector_screen.dart';
import '../widgets/reusable_alert.dart';

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
  //RxBool isLoading = false.obs;
  late LoginModel loginModel;
  RxString userId = ''.obs;
  RxString serverIp = ''.obs;
  RxString deviceID = ''.obs;
  RxString accessToken = ''.obs;

  Future<void> loginMethod(BuildContext context) async {
    try{
      //isLoading(true);
      BotToast.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      serverIp.value = prefs.getString('ipAddress')!;
      deviceID.value = prefs.getString('deviceId')!;
      var response = await http.get(Uri.parse(
          'http://${serverIp.value}/unistock/zebra/login.php?zemail=${user.text}&xpassword=${pass.text}'));
      if (response.statusCode == 200) {
        loginModel = loginModelFromJson(response.body);
        if(user.text == loginModel.zemail && pass.text == loginModel.xpassword){
          //isLoading(false);
          BotToast.closeAllLoading();
          userId.value = loginModel.xposition.toString();
          await prefs.setString('accessToken', loginModel.xaccess.toString());
          accessToken.value = prefs.getString('accessToken')!;
          Get.to(() => const ModeSelect());
          print('serverIp : $serverIp=========deviceId: $deviceID=============accessToken: $accessToken');
          Get.snackbar('Success!', "Successfully logged in",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: ConstantColors.comColor.withOpacity(0.4),
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
          );
        }else{
          //isLoading(false);
          BotToast.closeAllLoading();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => ReusableAlerDialogue(
              headTitle: "Warning!",
              message: "Invalid user name or password",
              btnText: "Back",
            ),
          );
        }
      }else if(response.statusCode == 403){
        //isLoading(false);
        BotToast.closeAllLoading();
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => ReusableAlerDialogue(
            headTitle: "Warning!",
            message: "User is already logged in from another device.",
            btnText: "Back",
          ),
        );
      }else if (response.statusCode == 404) {
        //isLoading(false);
        BotToast.closeAllLoading();
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
      //isLoading(false);
      BotToast.closeAllLoading();
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


  RxBool isLogout = false.obs;
  Future<void> loginOutMethod(BuildContext context) async {
    try{
      isLogout(true);
      BotToast.showLoading();
      var response = await http.post(Uri.parse('http://${serverIp.value}/unistock/login.php?zemail=${userId.value}'));
      print('userId: $userId');
      print('statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        isLogout(false);
        BotToast.closeAllLoading();
        Get.offAll(()=> const LoginScreen());
      }else{
        isLogout(false);
        BotToast.closeAllLoading();
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => ReusableAlerDialogue(
            headTitle: "Warning!",
            message: "Failed to connect server",
            btnText: "Back",
          ),
        );
      }
    }catch(e){
      isLogout(false);
      Get.snackbar('Warning!', 'Failed to connect server',
          borderWidth: 1.5,
          borderColor: Colors.black54,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
    }
  }
}
