// To parse this JSON data, do
//
//     final manualAddedProductModel = manualAddedProductModelFromJson(jsonString);

import 'dart:convert';

AutomaticAddedProductModel automaticAddedProductModelFromJson(String str) => AutomaticAddedProductModel.fromJson(json.decode(str));

String automaticAddedProductModelToJson(AutomaticAddedProductModel data) => json.encode(data.toJson());

class AutomaticAddedProductModel {
  String itemCode;
  String itemDesc;
  double scanQty;
  double autoQty;
  double manualQty;

  AutomaticAddedProductModel({
    required this.itemCode,
    required this.itemDesc,
    required this.scanQty,
    required this.autoQty,
    required this.manualQty,
  });

  factory AutomaticAddedProductModel.fromJson(Map<String, dynamic> json) => AutomaticAddedProductModel(
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
