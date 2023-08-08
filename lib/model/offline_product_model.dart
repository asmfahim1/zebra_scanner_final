// To parse this JSON data, do
//
//     final offlineProductModel = offlineProductModelFromJson(jsonString);

import 'dart:convert';

List<OfflineProductModel> offlineProductModelFromJson(String str) => List<OfflineProductModel>.from(json.decode(str).map((x) => OfflineProductModel.fromJson(x)));

String offlineProductModelToJson(List<OfflineProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfflineProductModel {
  String ztime;
  String xitem;
  String xdesc;
  String xunit;
  String xcus;
  String xbodycode;
  String xtheircode;
  String xpaymenttype;
  String tagNo;

  OfflineProductModel({
    required this.ztime,
    required this.xitem,
    required this.xdesc,
    required this.xunit,
    required this.xcus,
    required this.xbodycode,
    required this.xtheircode,
    required this.xpaymenttype,
    required this.tagNo,
  });

  factory OfflineProductModel.fromJson(Map<String, dynamic> json) => OfflineProductModel(
    ztime: json["ztime"],
    xitem: json["xitem"],
    xdesc: json["xdesc"],
    xunit: json["xunit"],
    xcus: json["xcus"],
    xbodycode: json["xbodycode"],
    xtheircode: json["xtheircode"],
    xpaymenttype: json["xpaymenttype"],
    tagNo: json["tag_no"],
  );

  Map<String, dynamic> toJson() => {
    "ztime": ztime,
    "xitem": xitem,
    "xdesc": xdesc,
    "xunit": xunit,
    "xcus": xcus,
    "xbodycode": xbodycode,
    "xtheircode": xtheircode,
    "xpaymenttype": xpaymenttype,
    "tag_no": tagNo,
  };
}
