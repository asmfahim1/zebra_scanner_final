import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
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
/*        print('=========$deviceName===========$deviceId');
        print('=========${build.board}===========${build.bootloader}');
        print('=========${build.device}===========${build.display}');
        print('=========${build.androidId}===========${build.fingerprint}');
        print('=========${build.host}===========${build.manufacturer}');
        print('=========${build.product}===========${build.version}');
        print('=========${build.type}===========${build.tags}');
        print('=========${build.id}===========${build.tags}');
*/
      }
    } catch (e) {
      print("Something occurs $e");
    }
    isLoading(false);
    update();
  }

  //need to refine
  Future<void> serverSetup() async {
    isLoading1(true);
    if (server.text.isEmpty) {
      isLoading1(false);
      server.text = '172.20.20.69';
      Get.snackbar(
        'Error!',
        "Field is empty",
        borderWidth: 1.5,
        borderColor: Colors.black54,
        colorText: Colors.white,
        backgroundColor: colors.comColor.withOpacity(0.4),
        duration: const Duration(seconds: 1),
      );
    } else {
      //'http://${server.text}/sina/unistock/zebra/server_config.php'
      //server er ip address gula static kore na dile asole connection check disturb hoy
      if (server.text == '172.20.20.69' ||
          server.text == '192.168.28.179' ||
          server.text == '138.22.20.36') {
        //for checking connectivity
        Socket.connect(server.text, 8080, timeout: const Duration(seconds: 1))
            .then((socket) async {
          print("Successfully Connected");
          isLoading1(false);
          var response = await http.post(
              Uri.parse(
                  'http://${server.text}/sina/unistock/zebra/server_config.php'),
              body: <String, dynamic>{
                "device": deviceId,
                "ip_add": server.text,
              });
          print(
              "Connection Established----$deviceId-----${server.text}======${response.statusCode}");
          saveValue(server.text.toString());
          socket.destroy();
          Get.to(() => const LoginScreen());
        }).catchError((error) {
          isLoading1(false);
          Get.snackbar(
            'Warning!',
            "Connection Failed",
            borderWidth: 1.5,
            borderColor: Colors.black54,
            colorText: Colors.white,
            backgroundColor: colors.comColor.withOpacity(0.4),
            duration: const Duration(seconds: 1),
          );
          print("Exception on Socket: $error");
        });
      } else {
        isLoading1(false);
        Get.snackbar(
          'Warning!',
          "Invalid IP address",
          borderWidth: 1.5,
          borderColor: Colors.black54,
          colorText: Colors.white,
          backgroundColor: colors.comColor.withOpacity(0.4),
          duration: const Duration(seconds: 1),
        );
      }
    }
  }

  //saving data for further use
  RxString deviceID = ''.obs;
  RxString ipAddress = ''.obs;

  void saveValue(String serverIP) {
    deviceID.value = deviceId;
    ipAddress.value = serverIP;
    update();
    print('-----------------$deviceID');
    print('=================$ipAddress');
  }
}
