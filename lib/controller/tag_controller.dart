import 'dart:io' show Platform, exit;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'dart:io';
import '../model/taglist_model.dart';

class TagController extends GetxController {

  ConstantColors colors = ConstantColors();

  //list of open tags
  RxBool isLoading = false.obs;
  List<TagListModel> tagList = [];

  Future<void> listOfTags(String serverIp) async {
    try {
      isLoading(true);
      var response = await http
          .get(Uri.parse('http://$serverIp/unistock/zebra/tag_select.php'));
      if (response.statusCode == 200) {
        isLoading(false);
        tagList = tagListModelFromJson(response.body);
      } else {
        isLoading(false);
        Get.snackbar('Warning!', 'Something went wrong',
            borderWidth: 1.5,
            borderColor: Colors.black54,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP);
        tagList = [];
      }
      isLoading(false);
    } catch (e) {
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

  //gradient calculation
  static const double fillPercent = 52;
  // fills 56.23% for container from bottom
  static const double fillStop = (100 - fillPercent) / 95;
  final List<double> stops = [
    fillStop,
    fillStop,
  ];
}
