import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/view/server_setup_screen.dart';
import 'package:zebra_scanner_final/view/splash_screen.dart';
import 'package:zebra_scanner_final/view/test.dart';

void main() {
  //ensure initializing dewa hoy app a jeisob async function ase oigula surute initialize kore newa.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uni-Stock',
      theme: ThemeData(
        textTheme: GoogleFonts.anekMalayalamTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
        ),
      ),
      builder: BotToastInit(),
      locale: const Locale('en'),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const SplashScreen(),
    );
  }
}
