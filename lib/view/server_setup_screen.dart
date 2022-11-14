import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/server_controller.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
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
      body: Container(
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
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Uni",
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        color: colors.comColor),
                  ),
                  /*Image.asset(
            'images/s.png',
            width: 30,
          ),*/
                  Text(
                    "Stock",
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        color: colors.uniGreen),
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
                    server: serverController.server,
                    hintText: "192.168.10.114",
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
                        //serverController.saveValue();
                        serverController.serverSetup();
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: colors.comColor,
                          /*gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              colors.comColor.withOpacity(50),
                              colors.comColor.withOpacity(600),
                            ],
                          ),*/
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
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
