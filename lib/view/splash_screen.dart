import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebra_scanner_final/view/login_screen.dart';
import 'package:zebra_scanner_final/view/server_setup_screen.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  ConstantColors colors = ConstantColors();

  String? obtainedIpAddress;
  Future getValidationData() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var savedIp = preferences.getString('ipAddress');
    setState(() {
      obtainedIpAddress = savedIp;
    });
    print('Saved Ip address is : $obtainedIpAddress');
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    getValidationData().whenComplete(() async{
      Timer(const Duration(seconds: 3), () {
        Get.to(() => obtainedIpAddress == null ? const ServerSetupScreen() : const LoginScreen());
      });
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
                  width: MediaQuery.of(context).size.width / 1.6,
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
                          color: ConstantColors.comColor)),
                  Image.asset(
                    'images/Upgraded S.png',
                    width: MediaQuery.of(context).size.width / 6.4,
                  ),
                  Text(
                    "tock",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        color: ConstantColors.uniGreen),
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
