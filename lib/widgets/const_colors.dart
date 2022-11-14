import 'package:flutter/material.dart';

class ConstantColors {
  Color comColor = const Color(0xffEF4112);
  Color uniGreen = const Color(0xff016850);
  Color comColor1 = const Color(0xffEF4112).withOpacity(0.2);
  Color uniGreen1 = const Color(0xff016850);

  static const double fillPercent =
      52; // fills 56.23% for container from bottom
  static const double fillStop = (100 - fillPercent) / 95;
  final List<double> stops = [
    fillStop,
    fillStop,
  ];
}
