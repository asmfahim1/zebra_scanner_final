import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class TileBtn extends StatelessWidget {
  final String buttonName;
  final String imageName;
  final VoidCallback onPressed;

  const TileBtn({
    required this.imageName,
    required this.buttonName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 2.9,
      width: MediaQuery.of(context).size.width / 2.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: ConstantColors.comColor,
            spreadRadius: 0.5,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
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
                  height: MediaQuery.of(context).size.height / 11,
                  width: MediaQuery.of(context).size.width / 8,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  buttonName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bakbakOne(
                    fontSize: MediaQuery.of(context).size.height / 42,
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