import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/view/server_setup_screen.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  ConstantColors colors = ConstantColors();

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(const Duration(seconds: 4), () {
      Get.to(() => const ServerSetupScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            /*(for controlling Colors opacity)*/
            // colors: gradient,
            colors: [
              Colors.red.shade300,
              Colors.green.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: animation,
              child: Center(
                child: Image.asset(
                  'images/stock_logo.png',
                  width: 200,
                ),
              ),
            ),
            ScaleTransition(
              scale: animation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Uni",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                          color: colors.comColor)),
                  Image.asset(
                    'images/Upgraded S.png',
                    width: 50,
                  ),
                  Text(
                    "tock",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        color: colors.uniGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
