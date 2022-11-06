import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/remote_services.dart';
import 'dart:convert';

import '../model/taglist_model.dart';

class TagController extends GetxController {
  RxBool isLoading = false.obs;
  List<TagListModel> tagList = [];
  ApiNameLink apiNameLink = ApiNameLink();

  @override
  void onInit() {
    // TODO: implement onInit
    listOfTags();
    super.onInit();
  }

  Future<void> listOfTags() async {
    isLoading(true);
    var response = await http.get(Uri.parse(apiNameLink.tagList));
    if (response.statusCode == 200) {
      isLoading(false);
      tagList = tagListModelFromJson(response.body);
      print(response.body);
    } else {
      isLoading(false);
      tagList = [];
    }
    isLoading(false);
  }
}
