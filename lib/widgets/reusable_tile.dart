import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class TileBtn extends StatelessWidget {
  String buttonName;
  String imageName;
  VoidCallback onPressed;

  TileBtn({
    required this.imageName,
    required this.buttonName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width / 2.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: ConstantColors.comColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(imageName),
                  height: MediaQuery.of(context).size.height / 8.5,
                  width: MediaQuery.of(context).size.width / 6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  buttonName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bakbakOne(
                    fontSize: MediaQuery.of(context).size.height / 48,
                    color: ConstantColors.uniGreen,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}