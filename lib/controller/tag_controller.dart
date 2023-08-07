import 'dart:io' show Platform, exit;
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
    isLoading(true);
    var response = await http
        .get(Uri.parse('http://$serverIp/unistock/zebra/tag_select.php'));
    if (response.statusCode == 200) {
      isLoading(false);
      tagList = tagListModelFromJson(response.body);
    } else {
      isLoading(false);
      tagList = [];
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
