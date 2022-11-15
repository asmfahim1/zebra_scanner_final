import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/remote_services.dart';
import 'package:zebra_scanner_final/view/tag_selection.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import 'package:zebra_scanner_final/widgets/reusable_passfield.dart';
import 'package:zebra_scanner_final/widgets/reusable_textfield.dart';
import '../controller/server_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  ServerController serverController = Get.put(ServerController());
  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    print('===========${serverController.ipAddress.value}');
    print('===========${serverController.deviceID.value}');
    print('Screen height: ${MediaQuery.of(context).size.height}');
    print('Screen width: ${MediaQuery.of(context).size.width}');
    return Scaffold(
      /* appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ReusableAppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            iconSize: 30,
          ),
          color: Colors.transparent,
        ),
      ),*/
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Uni",
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w800,
                            color: colors.comColor)),
                    Image.asset(
                      'images/Upgraded S.png',
                      width: 60,
                    ),
                    Text(
                      "tock",
                      style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          color: colors.uniGreen),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Form(
                  key: loginController.loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReusableTextFormField(
                          hintText: "Enter User Name",
                          labelText: "User name",
                          server: loginController.user,
                          icon: Icon(
                            Icons.person,
                            size: 25,
                            color: colors.uniGreen,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => ReusableTextPassField(
                          hintText: "Enter Password",
                          labelText: "Password",
                          server: loginController.pass,
                          prefIcon: Icon(
                            Icons.vpn_key_outlined,
                            size: 25,
                            color: colors.uniGreen,
                          ),
                          obscureText: loginController.obscureText.value,
                          sufIcon: GestureDetector(
                              onTap: () {
                                print('ontap pressed');
                                loginController.toggle();
                              },
                              child: Icon(
                                loginController.obscureText.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.remove_red_eye_outlined,
                                size: 25,
                                color: loginController.obscureText.value
                                    ? colors.uniGreen
                                    : colors.comColor,
                              )),
                        ),
                      ),
                      Row(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(unselectedWidgetColor: Colors.black),
                            child: Checkbox(
                              value: true,
                              activeColor: colors.comColor,
                              checkColor: Colors.black,
                              onChanged: (value) {},
                            ),
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 05,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Get.to(() => TagSelectScreen());
                          print(
                              'device ID: ${serverController.deviceID.value} && IPAddress: ${serverController.ipAddress.value}');
                          loginController.loginMethod(
                              serverController.deviceID.value,
                              serverController.ipAddress.value,
                              context);
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
                          child: const Center(
                            child: Text(
                              'LOGIN',
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
