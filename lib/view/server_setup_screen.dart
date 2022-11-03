import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/server_controller.dart';
import 'package:zebra_scanner_final/view/login_screen.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

import '../widgets/appBar_widget.dart';
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
      /*appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ReusableAppBar(),
      ),*/
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Obx(() {
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
              GestureDetector(
                onTap: () async {
                  print('Login Button pressed');
                  Get.to(() => const LoginScreen());
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
                    child: Text(
                      'Save and Go',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
