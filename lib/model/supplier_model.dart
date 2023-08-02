// To parse this JSON data, do
//
//     final suppListModel = suppListModelFromJson(jsonString);

import 'dart:convert';

List<SuppListModel> suppListModelFromJson(String str) => List<SuppListModel>.from(json.decode(str).map((x) => SuppListModel.fromJson(x)));

String suppListModelToJson(List<SuppListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuppListModel {
  String xcus;
  String xcusname;

  SuppListModel({
    required this.xcus,
    required this.xcusname,
  });

  factory SuppListModel.fromJson(Map<String, dynamic> json) => SuppListModel(
    xcus: json["xcus"],
    xcusname: json["xcusname"],
  );

  Map<String, dynamic> toJson() => {
    "xcus": xcus,
    "xcusname": xcusname,
  };
}
