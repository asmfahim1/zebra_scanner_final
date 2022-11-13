import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/view/online_mode_screen.dart';
import 'package:zebra_scanner_final/view/tag_selection.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import 'package:zebra_scanner_final/widgets/reusable_passfield.dart';
import 'package:zebra_scanner_final/widgets/reusable_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: loginController.loginKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableTextFormField(
                      hintText: "Enter User Name",
                      labelText: "User name",
                      server: loginController.user,
                      icon: Icon(Icons.person)),
                  SizedBox(
                    height: 10,
                  ),
                  ReusableTextPassField(
                    hintText: "Enter Password",
                    labelText: "Password",
                    server: loginController.pass,
                    prefIcon: const Icon(Icons.vpn_key_outlined),
                    sufIcon: const Icon(Icons.remove_red_eye_outlined),
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
                      Text(
                        "Remember me",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 05,
                  ),
                  GestureDetector(
                    onTap: () async {
                      print('Login Button pressed');
                      Get.offAll(() => TagSelectScreen());
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
        ),
      ),
    );
  }
}
