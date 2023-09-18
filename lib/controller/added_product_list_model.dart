// To parse this JSON data, do
//
//     final addedProductList = addedProductListFromJson(jsonString);

import 'dart:convert';

List<AddedProductList> addedProductListFromJson(String str) => List<AddedProductList>.from(json.decode(str).map((x) => AddedProductList.fromJson(x)));

String addedProductListToJson(List<AddedProductList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddedProductList {
  String? itemCode;
  String? itemDesc;
  int? scanQty;
  int? autoQty;
  int? manualQty;

  AddedProductList({
    this.itemCode,
    this.itemDesc,
    this.scanQty,
    this.autoQty,
    this.manualQty,
  });

  factory AddedProductList.fromJson(Map<String, dynamic> json) => AddedProductList(
    itemCode: json["item_code"],
    itemDesc: json["item_desc"],
    scanQty: json["scan_qty"],
    autoQty: json["auto_qty"],
    manualQty: json["manual_qty"],
  );

  Map<String, dynamic> toJson() => {
    "item_code": itemCode,
    "item_desc": itemDesc,
    "scan_qty": scanQty,
    "auto_qty": autoQty,
    "manual_qty": manualQty,
  };
}
