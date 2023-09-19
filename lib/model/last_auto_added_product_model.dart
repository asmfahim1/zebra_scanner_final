// To parse this JSON data, do
//
//     final lastAutoAddedProductModel = lastAutoAddedProductModelFromJson(jsonString);

import 'dart:convert';

LastAutoAddedProductModel lastAutoAddedProductModelFromJson(String str) => LastAutoAddedProductModel.fromJson(json.decode(str));

String lastAutoAddedProductModelToJson(LastAutoAddedProductModel data) => json.encode(data.toJson());

class LastAutoAddedProductModel {
  String itemCode;
  String itemDesc;
  double scanQty;
  double autoQty;
  double manualQty;

  LastAutoAddedProductModel({
    required this.itemCode,
    required this.itemDesc,
    required this.scanQty,
    required this.autoQty,
    required this.manualQty,
  });

  factory LastAutoAddedProductModel.fromJson(Map<String, dynamic> json) => LastAutoAddedProductModel(
    itemCode: json["item_code"],
    itemDesc: json["item_desc"],
    scanQty: json["scan_qty"]?.toDouble(),
    autoQty: json["auto_qty"]?.toDouble(),
    manualQty: json["manual_qty"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "item_code": itemCode,
    "item_desc": itemDesc,
    "scan_qty": scanQty,
    "auto_qty": autoQty,
    "manual_qty": manualQty,
  };
}
