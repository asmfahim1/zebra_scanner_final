import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebra_scanner_final/controller/server_controller.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import '../widgets/reusable_textfield.dart';

class ServerSetupScreen extends StatefulWidget {
  const ServerSetupScreen({Key? key}) : super(key: key);

  @override
  State<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends State<ServerSetupScreen> {
  ServerController serverController = Get.put(ServerController());
  ConstantColors colors = ConstantColors();

/*  @override
  void initState() {
    // TODO: implement initState
      super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5),
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
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Uni",
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w800,
                            color: ConstantColors.comColor)),
                    Image.asset(
                      'images/Upgraded S.png',
                      width: MediaQuery.of(context).size.width / 5.33,
                    ),
                    const Text(
                      "tock",
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: ConstantColors.uniGreen),
                    ),
                  ],
                ),
              ),
              Obx(() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    serverController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'Device ID: ${serverController.deviceId}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                    const SizedBox(
                      height: 50,
                    ),
                    ReusableTextFormField(
                      controller: serverController.server,
                      hintText: "ip address",
                      labelText: "Enter Server IP",
                      icon: const Icon(
                        Icons.cast_connected,
                        color: Color(0xffE85724),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return GestureDetector(
                        onTap: () async {
                          serverController.serverSetup();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 7,
                          width: MediaQuery.of(context).size.width / 2.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: ConstantColors.comColor,
                          ),
                          child: Center(
                            child: serverController.isLoading1.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Save and Go',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Powered By ",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                    AssetImage("images/Business.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
