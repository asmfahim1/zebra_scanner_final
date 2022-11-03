import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

class ServerController extends GetxController {
  RxBool isLoading = false.obs;
  String deviceName = '', deviceId = '', normalId = '';
  TextEditingController server = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    getDeviceDetails();
    //initPlatformState();
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
        print('=========${build.id}===========${build.tags}');*/
      }
    } catch (e) {
      print("Something occurs $e");
    }
    isLoading(false);
  }
/*  String _udid = 'Unknown';
  Future<void> initPlatformState() async {
    isLoading(true);
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }
    _udid = udid;
    print(_udid);
    isLoading(false);
  }*/
}
