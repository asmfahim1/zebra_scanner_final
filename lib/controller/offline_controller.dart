import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/supplier_model.dart';
import '../model/taglist_model.dart';

class OfflineController extends GetxController {
  //list of open tags
  RxBool isLoading = false.obs;
  RxList offlineTags = <TagListModel>[].obs;
  Future<void> listOfTags(String serverIp) async {
    try{
      isLoading(true);
      var response = await http
          .get(Uri.parse('http://$serverIp/unistock/zebra/tag_select.php'));
      if (response.statusCode == 200) {
        isLoading(false);
        var tags = tagListModelFromJson(response.body);
        offlineTags.assignAll(tags);
      } else {
        isLoading(false);
        offlineTags.value = [];
        print('response is : ${response.statusCode}');
      }
    }catch(e){
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print("Something went wrong while submit data $e");
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

  /// for supplier list search mechanism

  //supplier list fetching
  RxBool isSupLoaded = false.obs;
  RxList supList = <SuppListModel>[].obs;
  //List<Map<String, dynamic>> supList = [];
  Future<void> listOfSuppliers(String serverIp) async {
    try{
      isSupLoaded(true);
      var response = await http
          .get(Uri.parse('http://$serverIp/unistock/supllierList.php'));
      if (response.statusCode == 200) {
        isSupLoaded(false);
        var suppliers = suppListModelFromJson(response.body);
        supList.assignAll(suppliers);
      } else {
        isSupLoaded(false);
        supList.value = [];
        print('response is : ${response.statusCode}');
      }
    }catch(e){
      isSupLoaded(false);
      Get.snackbar('Error', 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print("Something went wrong while submit data $e");
    }
  }

  //search mechanism for any name
  RxString searchQuery = ''.obs;

  // Filter suppliers based on search query
  List get filteredSupList {
    if (searchQuery.value.isEmpty) {
      return supList.toList();
    } else {
      return supList
          .where((supplier) => supplier.xcus.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Set the search query
  void search(String query) {
    searchQuery.value = query;
  }
}