import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableAlerDialogue extends StatelessWidget {
  String? headTitle;
  String? message;
  String? btnText;
  ReusableAlerDialogue({Key? key, this.headTitle, this.message, this.btnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        headTitle!,
        style: GoogleFonts.urbanist(
          color: Colors.red,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Image.asset(
              "images/waeng1.png",
              height: MediaQuery.of(context).size.height / 8.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message!,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text(btnText!),
        ),
      ],
    );
  }
}
