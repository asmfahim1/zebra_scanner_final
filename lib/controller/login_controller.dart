import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/server_controller.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/view/tag_selection.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginKey = GlobalKey();
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
      Get.snackbar('Success', 'Successfully logged in');
    } else if (response.statusCode == 404) {
      isLoading(false);
      showDialog(
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
          });
    }
  }
}
