import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

class ReusableAppBar extends StatelessWidget {
  Color? color;
  double? elevation;
  Widget? leading;
  List<Widget>? action;
  ReusableAppBar(
      {Key? key, this.color, this.elevation, this.leading, this.action})
      : super(key: key);

  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      elevation: elevation,
      automaticallyImplyLeading: false,
      leading: leading,
      centerTitle: true,
      title: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Uni",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: colors.comColor)),
            Image.asset(
              'images/Upgraded S.png',
              width: 30,
            ),
            Text(
              "tock",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: colors.uniGreen),
            ),
          ],
        ),
      ),
      actions: action,
    );
  }
}
/*Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
"Uni",
style: TextStyle(
fontSize: 30, fontWeight: FontWeight.w800, color: Colors.black),
),
Image.asset(
'images/s.png',
width: 30,
),
const Text(
"tock",
style: TextStyle(
fontSize: 30, fontWeight: FontWeight.w800, color: Colors.black),
),
],
)*/
