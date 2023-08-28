// To parse this JSON data, do
//
//     final manualAddedProductModel = manualAddedProductModelFromJson(jsonString);

import 'dart:convert';

ManualAddedProductModel manualAddedProductModelFromJson(String str) => ManualAddedProductModel.fromJson(json.decode(str));

String manualAddedProductModelToJson(ManualAddedProductModel data) => json.encode(data.toJson());

class ManualAddedProductModel {
  String? xitem;
  String? xdesc;
  int? scanQty;
  int? autoQty;
  int? manualQty;
  String? xunit;

  ManualAddedProductModel({
    this.xitem,
    this.xdesc,
    this.scanQty,
    this.autoQty,
    this.manualQty,
    this.xunit,
  });

  factory ManualAddedProductModel.fromJson(Map<String, dynamic> json) => ManualAddedProductModel(
    xitem: json["xitem"],
    xdesc: json["xdesc"],
    scanQty: json["scan_qty"],
    autoQty: json["auto_qty"],
    manualQty: json["manual_qty"],
    xunit: json["xunit"],
  );

  Map<String, dynamic> toJson() => {
    "xitem": xitem,
    "xdesc": xdesc,
    "scan_qty": scanQty,
    "auto_qty": autoQty,
    "manual_qty": manualQty,
    "xunit": xunit,
  };
}
