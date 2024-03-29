import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class ReusableAlerDialogue extends StatelessWidget {
  final String? headTitle;
  final String? message;
  final String? btnText;
  const ReusableAlerDialogue({Key? key, this.headTitle, this.message, this.btnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          headTitle!,
          style: GoogleFonts.urbanist(
            color: Colors.red,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "images/waeng1.png",
              height: MediaQuery.of(context).size.height / 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message!,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ConstantColors.uniGreen
          ),
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text(btnText!, style: const TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
