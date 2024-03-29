import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class ReusableTextFormField extends StatelessWidget {
  String hintText;
  String labelText;
  TextEditingController controller = TextEditingController();
  Widget icon;

  ReusableTextFormField(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.controller,
      required this.icon})
      : super(key: key);

  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      //margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: ConstantColors.uniGreen,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: ConstantColors.comColor,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
          prefixIcon: icon,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600),
          fillColor: Colors.white10,
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
