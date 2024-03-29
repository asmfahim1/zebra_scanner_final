import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class ReusableTextPassField extends StatelessWidget {
  String hintText;
  String labelText;
  bool? obscureText;
  TextEditingController controller = TextEditingController();
  final ValueChanged<String>? onFieldSubmitted;
  Widget prefIcon;
  Widget sufIcon;

  ReusableTextPassField(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.controller,
      this.onFieldSubmitted,
      required this.prefIcon,
      required this.sufIcon,
      this.obscureText,
      })
      : super(key: key);

  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: ConstantColors.uniGreen,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: ConstantColors.comColor,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
          prefixIcon: prefIcon,
          suffixIcon: sufIcon,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600),
          fillColor: Colors.white10,
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        obscureText: obscureText!,
        obscuringCharacter: '*',
      ),
    );
  }
}
