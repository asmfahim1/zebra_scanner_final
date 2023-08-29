import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/view/server_setup_screen.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: (){
                    //loginController.clearCache();
                    Get.offAll(()=> const ServerSetupScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.arrow_back_ios),
                      Text(
                        "Server setup",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Form(
                  key: loginController.loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReusableTextFormField(
                          hintText: "Enter User Name",
                          labelText: "User name",
                          controller: loginController.user,
                          icon: const Icon(
                            Icons.person,
                            size: 20,
                            color: ConstantColors.uniGreen,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => ReusableTextPassField(
                          hintText: "Enter Password",
                          labelText: "Password",
                          controller: loginController.pass,
                          prefIcon: const Icon(
                            Icons.vpn_key_outlined,
                            size: 20,
                            color: ConstantColors.uniGreen,
                          ),
                          obscureText: loginController.obscureText.value,
                          sufIcon: GestureDetector(
                              onTap: () {
                                loginController.toggle();
                              },
                              child: Icon(
                                loginController.obscureText.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.remove_red_eye_outlined,
                                size: 20,
                                color: loginController.obscureText.value
                                    ? ConstantColors.uniGreen
                                    : ConstantColors.comColor,
                              )),
                        ),
                      ),
                      Obx(() {
                        return Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.black),
                              child: Checkbox(
                                value: loginController.isChecked.value,
                                activeColor: Colors.deepOrange,
                                checkColor: Colors.white,
                                onChanged: (value) {
                                  loginController.isChecked.value =
                                  !loginController.isChecked.value;
                                },
                              ),
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 05,
                      ),
                      Obx((){
                        return GestureDetector(
                          onTap: () async {
                            loginController.loginMethod(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width / 7,
                            width: MediaQuery.of(context).size.width / 3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: ConstantColors.comColor,
                            ),
                            child: loginController.isLoading.value
                                    ? const CircularProgressIndicator(color: Colors.white,)
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                        );
                      }),
                      const SizedBox(
                        height: 10,
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
