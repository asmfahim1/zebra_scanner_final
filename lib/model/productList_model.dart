// To parse this JSON data, do
//
//     final productList = productListFromJson(jsonString);

import 'dart:convert';

List<ProductList> productListFromJson(String str) => List<ProductList>.from(
    json.decode(str).map((x) => ProductList.fromJson(x)));

String productListToJson(List<ProductList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductList {
  ProductList({
    required this.xitem,
    required this.xdesc,
    required this.xcount,
    required this.lastqty,
    required this.xcus,
    required this.xcusname,
    required this.xbodycode,
    required this.xoldcode,
  });

  String xitem;
  String xdesc;
  int xcount;
  int lastqty;
  String xcus;
  String xcusname;
  String xbodycode;
  String xoldcode;

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        xitem: json["xitem"],
        xdesc: json["xdesc"],
        xcount: json["xcount"],
        lastqty: json["lastqty"],
        xcus: json["xcus"],
        xcusname: json["xcusname"],
        xbodycode: json["xbodycode"],
        xoldcode: json["xoldcode"],
      );

  Map<String, dynamic> toJson() => {
        "xitem": xitem,
        "xdesc": xdesc,
        "xcount": xcount,
        "lastqty": lastqty,
        "xcus": xcus,
        "xcusname": xcusname,
        "xbodycode": xbodycode,
        "xoldcode": xoldcode,
      };
}
