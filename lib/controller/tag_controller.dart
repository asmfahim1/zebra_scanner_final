import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/controller/server_controller.dart';
import 'package:zebra_scanner_final/remote_services.dart';
import 'dart:convert';

import '../model/taglist_model.dart';

class TagController extends GetxController {
  RxBool isLoading = false.obs;
  List<TagListModel> tagList = [];

/*  @override
  void onInit() {
    // TODO: implement onInit
    listOfTags();
    super.onInit();
  }*/

  //list of open tags
  Future<void> listOfTags(String serverIp) async {
    isLoading(true);
    var response = await http
        .get(Uri.parse('http://$serverIp/sina/unistock/zebra/tag_select.php'));
    if (response.statusCode == 200) {
      isLoading(false);
      tagList = tagListModelFromJson(response.body);
      print(response.body);
      print('Server IP of open tag list: $serverIp');
    } else {
      isLoading(false);
      tagList = [];
      print(response.body);
      print('Server IP of open tag list: $serverIp');
    }
    isLoading(false);
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
