import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

class ReusableTextPassField extends StatelessWidget {
  String hintText;
  String labelText;
  TextEditingController server = TextEditingController();
  Widget prefIcon;
  Widget sufIcon;

  ReusableTextPassField(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.server,
      required this.prefIcon,
      required this.sufIcon})
      : super(key: key);

  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: server,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: colors.comColor,
            ),
            borderRadius: BorderRadius.circular(5.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.blue,
            ),
          ),
          prefixIcon: prefIcon,
          suffixIcon: sufIcon,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          fillColor: Colors.blueGrey[50],
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        obscuringCharacter: '*',
      ),
    );
  }
}
