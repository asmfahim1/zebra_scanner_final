import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
    getDeviceDetails();
    super.onInit();
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
        print('======$deviceName=========$deviceId=========$normalId');
      }
    } catch (e) {
      print("Something occurs $e");
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
        server.text = '172.20.20.96';
        Get.snackbar(
          'Error!',
          "Field is empty",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: ConstantColors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1),
        );
      } else {
        if (server.text == '172.20.20.96' ||
            server.text == '192.168.28.179' ||
            server.text == '138.22.20.36') {
          print("Successfully Connected");
          isLoading1(false);
          var response = await http.post(
              Uri.parse('http://${server.text}/unistock/zebra/server_config.php'),
              body: <String, dynamic>{
                "device": deviceId,
                "ip_add": server.text,
              });
          if(response.statusCode == 200){
            isLoading1(false);
            saveValue(server.text.toString());
            Get.to(() => const LoginScreen());
          }else{
            isLoading1(false);
            print('Something went wrong: ${response.statusCode}');
          }
        } else {
          isLoading1(false);
          Get.snackbar(
            'Warning!',
            "Invalid IP address",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: ConstantColors.comColor.withOpacity(0.4),
            duration: const Duration(seconds: 1),
          );
        }
      }
    }catch(e){
      isLoading1(false);
      print('Server error: $e');
    }
  }

  //saving data for further use
  RxString deviceID = ''.obs;
  RxString ipAddress = ''.obs;

  void saveValue(String serverIP) {
    deviceID.value = deviceId;
    ipAddress.value = serverIP;
  }
}
