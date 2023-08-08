import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class SpecialAlert extends StatelessWidget {
  String? headTitle;
  String? message;
  String? btnText;
  SpecialAlert({Key? key, this.headTitle, this.message, this.btnText})
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
        height: 150,
        child: Column(
          children: [
            Image.asset(
              "images/Successdesign.gif",
              height: MediaQuery.of(context).size.height / 4,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message!,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 14,
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
          onPressed: (){
            Navigator.pop(context, 'Back');
            Navigator.pop(context, 'Back');
            Navigator.pop(context, 'Back');
          },
          child: Text(btnText!, style: const TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
