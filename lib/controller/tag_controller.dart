import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, exit;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import 'dart:io';
import '../model/taglist_model.dart';

class TagController extends GetxController {
  RxBool isLoading = false.obs;
  List<TagListModel> tagList = [];
  ConstantColors colors = ConstantColors();

/*  @override
  void onInit() {
    // TODO: implement onInit
    listOfTags();
    super.onInit();
  }*/

  //for exit the app
  Future<bool?> showWarningContext(BuildContext context) async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Exit',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Do you want to exit the app?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: colors.uniGreen.withOpacity(0.5),
              ),
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: colors.comColor.withOpacity(0.5),
              ),
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );

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
