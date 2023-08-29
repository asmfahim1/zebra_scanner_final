// To parse this JSON data, do
//
//     final lastAddedProductModel = lastAddedProductModelFromJson(jsonString);

import 'dart:convert';

LastAddedProductModel lastAddedProductModelFromJson(String str) => LastAddedProductModel.fromJson(json.decode(str));

String lastAddedProductModelToJson(LastAddedProductModel data) => json.encode(data.toJson());

class LastAddedProductModel {
  String? xitem;
  String? xdesc;
  double? scanQty;
  double? autoQty;
  double? manualQty;
  String? xunit;

  LastAddedProductModel({
    this.xitem,
    this.xdesc,
    this.scanQty,
    this.autoQty,
    this.manualQty,
    this.xunit,
  });

  factory LastAddedProductModel.fromJson(Map<String, dynamic> json) => LastAddedProductModel(
    xitem: json["xitem"],
    xdesc: json["xdesc"],
    scanQty: json["scan_qty"]?.toDouble(),
    autoQty: json["auto_qty"]?.toDouble(),
    manualQty: json["manual_qty"]?.toDouble(),
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
