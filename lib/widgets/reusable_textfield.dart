import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

class ReusableTextFormField extends StatelessWidget {
  String hintText;
  String labelText;
  TextEditingController server = TextEditingController();
  Widget icon;

  ReusableTextFormField(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.server,
      required this.icon})
      : super(key: key);

  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      //margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: server,
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
              color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w600),
          fillColor: Colors.white10,
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
