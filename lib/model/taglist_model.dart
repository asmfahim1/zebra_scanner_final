// To parse this JSON data, do
//
//     final tagListModel = tagListModelFromJson(jsonString);

import 'dart:convert';

List<TagListModel> tagListModelFromJson(String str) => List<TagListModel>.from(json.decode(str).map((x) => TagListModel.fromJson(x)));

String tagListModelToJson(List<TagListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TagListModel {
  String ztime;
  String zutime;
  int zid;
  String zauserid;
  String zuuserid;
  String xtagnum;
  String xlong;
  String xref;
  String xwh;
  String xstatustag;
  String date;
  String datecom;

  TagListModel({
    required this.ztime,
    required this.zutime,
    required this.zid,
    required this.zauserid,
    required this.zuuserid,
    required this.xtagnum,
    required this.xlong,
    required this.xref,
    required this.xwh,
    required this.xstatustag,
    required this.date,
    required this.datecom,
  });

  factory TagListModel.fromJson(Map<String, dynamic> json) => TagListModel(
    ztime: json["ztime"],
    zutime: json["zutime"],
    zid: json["zid"],
    zauserid: json["zauserid"],
    zuuserid: json["zuuserid"],
    xtagnum: json["xtagnum"],
    xlong: json["xlong"],
    xref: json["xref"],
    xwh: json["xwh"],
    xstatustag: json["xstatustag"],
    date: json["date"],
    datecom: json["datecom"],
  );

  Map<String, dynamic> toJson() => {
    "ztime": ztime,
    "zutime": zutime,
    "zid": zid,
    "zauserid": zauserid,
    "zuuserid": zuuserid,
    "xtagnum": xtagnum,
    "xlong": xlong,
    "xref": xref,
    "xwh": xwh,
    "xstatustag": xstatustag,
    "date": date,
    "datecom": datecom,
  };
}
