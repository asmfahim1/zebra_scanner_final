// To parse this JSON data, do
//
//     final manualAddedProductModel = manualAddedProductModelFromJson(jsonString);

import 'dart:convert';

ManualAddedProductModel manualAddedProductModelFromJson(String str) => ManualAddedProductModel.fromJson(json.decode(str));

String manualAddedProductModelToJson(ManualAddedProductModel data) => json.encode(data.toJson());

class ManualAddedProductModel {
  int id;
  int zid;
  String ztime;
  String zutime;
  String tagNo;
  String itemCode;
  String itemDesc;
  int scanQty;
  int adjQty;
  int autoQty;
  int manualQty;
  String xcus;
  String device;
  String store;
  int zactive;
  String zuuserid;
  String zauserid;

  ManualAddedProductModel({
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

  factory ManualAddedProductModel.fromJson(Map<String, dynamic> json) => ManualAddedProductModel(
    id: json["id"],
    zid: json["zid"],
    ztime: json["ztime"],
    zutime: json["zutime"],
    tagNo: json["tag_no"],
    itemCode: json["item_code"],
    itemDesc: json["item_desc"],
    scanQty: json["scan_qty"],
    adjQty: json["adj_qty"],
    autoQty: json["auto_qty"],
    manualQty: json["manual_qty"],
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
