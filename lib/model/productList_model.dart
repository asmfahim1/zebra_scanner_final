// To parse this JSON data, do
//
//     final masterItemsModel = masterItemsModelFromJson(jsonString);

import 'dart:convert';

List<MasterItemsModel> masterItemsModelFromJson(String str) => List<MasterItemsModel>.from(json.decode(str).map((x) => MasterItemsModel.fromJson(x)));

String masterItemsModelToJson(List<MasterItemsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MasterItemsModel {
  int id;
  int zid;
  String ztime;
  String zutime;
  String tagNo;
  String itemCode;
  String itemDesc;
  double scanQty;
  double adjQty;
  double autoQty;
  double manualQty;
  String xcus;
  String device;
  String store;
  int zactive;
  String zuuserid;
  String zauserid;

  MasterItemsModel({
    required this.id,
    required this.zid,
    required this.ztime,
    required this.zutime,
    required this.tagNo,
    required this.itemCode,
    required this.itemDesc,
    required this.scanQty,
    required this.adjQty,
    required this.autoQty,
    required this.manualQty,
    required this.xcus,
    required this.device,
    required this.store,
    required this.zactive,
    required this.zuuserid,
    required this.zauserid,
  });

  factory MasterItemsModel.fromJson(Map<String, dynamic> json) => MasterItemsModel(
    id: json["id"],
    zid: json["zid"],
    ztime: json["ztime"],
    zutime: json["zutime"],
    tagNo: json["tag_no"],
    itemCode: json["item_code"],
    itemDesc: json["item_desc"],
    scanQty: json["scan_qty"]?.toDouble(),
    adjQty: json["adj_qty"]?.toDouble(),
    autoQty: json["auto_qty"]?.toDouble(),
    manualQty: json["manual_qty"]?.toDouble(),
    xcus: json["xcus"],
    device: json["device"],
    store: json["store"],
    zactive: json["zactive"],
    zuuserid: json["zuuserid"],
    zauserid: json["zauserid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "zid": zid,
    "ztime": ztime,
    "zutime": zutime,
    "tag_no": tagNo,
    "item_code": itemCode,
    "item_desc": itemDesc,
    "scan_qty": scanQty,
    "adj_qty": adjQty,
    "auto_qty": autoQty,
    "manual_qty": manualQty,
    "xcus": xcus,
    "device": device,
    "store": store,
    "zactive": zactive,
    "zuuserid": zuuserid,
    "zauserid": zauserid,
  };
}
