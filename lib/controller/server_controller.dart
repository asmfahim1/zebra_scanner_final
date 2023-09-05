import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'dart:io';
import '../view/login_screen.dart';

class ServerController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  String deviceName = '', deviceId = '', normalId = '';
  TextEditingController server = TextEditingController();
  ConstantColors colors = ConstantColors();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDeviceDetails();
  }

  Future<void> getDeviceDetails() async {
    isLoading(true);
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceId = build.androidId;
        normalId = build.id;
      }
    } catch (e) {
      deviceName = '';
      deviceId = '';
      normalId = '';
    }
    isLoading(false);
    update();
  }

  //need to refine
  Future<void> serverSetup() async {
    try{
      isLoading1(true);
      if (server.text.isEmpty) {
        isLoading1(false);
        Get.snackbar(
          'Error!',
          "Field is empty",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('ipAddress', server.text,);
        prefs.setString('deviceId', deviceId,);
        var response = await http.post(
            Uri.parse('http://${server.text}/unistock/zebra/server_config.php'),
            body: <String, dynamic>{
              "device": deviceId,
              "ip_add": server.text,
            });
        if(response.statusCode == 200){
          isLoading1(false);
          Get.to(() => const LoginScreen());
        }else{
          isLoading1(false);
          Get.snackbar(
            'Error!',
            "Something went wrong",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          );
        }
      }
    }catch(e){
      isLoading1(false);
      Get.snackbar(
        'Error!',
        "Failed to connect server",
        borderWidth: 1.5,
        borderColor: Colors.black54,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      );
    }
  }
}
