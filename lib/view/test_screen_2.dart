import 'package:flutter/material.dart';

class SettingsTitleWidget extends StatelessWidget {
  final String title;
  final Widget? trailingWidget;
  final Color? color;
  const SettingsTitleWidget({
    required this.title,
    this.trailingWidget,
    this.color = Colors.white,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.maxFinite,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 35,
            width: 173,
            child: Center(
              child: Text(
                title,
              ),
            ),
          ),
          Container(
            child: trailingWidget,
          )
        ],
      ),
    );
  }
}
