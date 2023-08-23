// To parse this JSON data, do
//
//     final manualAddedProductModel = manualAddedProductModelFromJson(jsonString);

import 'dart:convert';

ManualAddedProductModel manualAddedProductModelFromJson(String str) => ManualAddedProductModel.fromJson(json.decode(str));

String manualAddedProductModelToJson(ManualAddedProductModel data) => json.encode(data.toJson());

class ManualAddedProductModel {
  String? xitem;
  String? xdesc;
  int? quantity;
  String? xunit;

  ManualAddedProductModel({
    this.xitem,
    this.xdesc,
    this.quantity,
    this.xunit,
  });

  factory ManualAddedProductModel.fromJson(Map<String, dynamic> json) => ManualAddedProductModel(
    xitem: json["xitem"],
    xdesc: json["xdesc"],
    quantity: json["quantity"],
    xunit: json["xunit"],
  );

  Map<String, dynamic> toJson() => {
    "xitem": xitem,
    "xdesc": xdesc,
    "quantity": quantity,
    "xunit": xunit,
  };
}
