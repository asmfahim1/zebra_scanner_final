import 'package:flutter/material.dart';
import 'dart:ui';

class ConstantColors {
  static const Color comColor = Color(0xffEF4112);
  static const Color uniGreen = Color(0xff016850);
  static const Color comColor1 = Color(0xffD73A10);
  static const Color uniGreen1 = Color(0xff338672);

  static const double fillPercent =
      52; // fills 56.23% for container from bottom
  static const double fillStop = (100 - fillPercent) / 95;
  final List<double> stops = [
    fillStop,
    fillStop,
  ];
}
