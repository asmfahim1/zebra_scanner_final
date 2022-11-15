import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/view/tag_selection.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

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

  //login method
  RxBool isLoading = false.obs;

  Future<void> loginMethod(
      String deviceId, String ipAddress, BuildContext context) async {
    isLoading(true);
    var response = await http.get(Uri.parse(
        'http://$ipAddress/sina/unistock/zebra/login.php?user=${user.text}&password=${pass.text}'));
    if (response.statusCode == 200) {
      isLoading(false);
      Get.to(() => const TagSelectScreen());
      Get.snackbar('Success!', "Successfully logged in",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: colors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1));
    } else if (response.statusCode == 404) {
      isLoading(false);
      Get.snackbar('Warning!', "Invalid IP Address",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: colors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM);
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
