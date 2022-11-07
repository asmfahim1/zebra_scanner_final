// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

List<ProductListModel> productListModelFromJson(String str) =>
    List<ProductListModel>.from(
        json.decode(str).map((x) => ProductListModel.fromJson(x)));

String productListModelToJson(List<ProductListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductListModel {
  ProductListModel({
    required this.id,
    required this.zid,
    required this.ztime,
    required this.zutime,
    required this.tagNo,
    required this.itemCode,
    required this.itemDesc,
    required this.price,
    required this.scanQty,
    required this.adjQty,
    required this.autoQty,
    required this.manualQty,
    required this.xcus,
    required this.xorg,
    required this.device,
    required this.empid,
    required this.countingsetupId,
    required this.outlet,
    required this.store,
    required this.zactive,
    required this.zuuserid,
    required this.zauserid,
  });

  int id;
  int zid;
  String ztime;
  String zutime;
  String tagNo;
  String itemCode;
  String itemDesc;
  int price;
  int scanQty;
  int adjQty;
  int autoQty;
  int manualQty;
  String xcus;
  String xorg;
  String device;
  String empid;
  String countingsetupId;
  String outlet;
  String store;
  int zactive;
  String zuuserid;
  String zauserid;

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        id: json["id"],
        zid: json["zid"],
        ztime: json["ztime"],
        zutime: json["zutime"],
        tagNo: json["tag_no"],
        itemCode: json["item_code"],
        itemDesc: json["item_desc"],
        price: json["price"],
        scanQty: json["scan_qty"],
        adjQty: json["adj_qty"],
        autoQty: json["auto_qty"],
        manualQty: json["manual_qty"],
        xcus: json["xcus"],
        xorg: json["xorg"],
        device: json["device"],
        empid: json["empid"],
        countingsetupId: json["countingsetup_id"],
        outlet: json["outlet"],
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
        "price": price,
        "scan_qty": scanQty,
        "adj_qty": adjQty,
        "auto_qty": autoQty,
        "manual_qty": manualQty,
        "xcus": xcus,
        "xorg": xorg,
        "device": device,
        "empid": empid,
        "countingsetup_id": countingsetupId,
        "outlet": outlet,
        "store": store,
        "zactive": zactive,
        "zuuserid": zuuserid,
        "zauserid": zauserid,
      };
}
