// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? name;
  String? xposition;
  String? zemail;
  String? xpassword;
  String? xaccess;

  LoginModel({
    this.name,
    this.xposition,
    this.zemail,
    this.xpassword,
    this.xaccess,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    name: json["name"],
    xposition: json["xposition"],
    zemail: json["zemail"],
    xpassword: json["xpassword"],
    xaccess: json["xaccess"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "xposition": xposition,
    "zemail": zemail,
    "xpassword": xpassword,
    "xaccess": xaccess,
  };
}
