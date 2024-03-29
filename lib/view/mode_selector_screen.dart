import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/view/login_screen.dart';
import 'package:zebra_scanner_final/view/online_process/tag_selection.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/widgets/reusable_tile.dart';
import '../constants/const_colors.dart';
import '../widgets/appBar_widget.dart';
import 'offline_process/scan_type_screen.dart';

class ModeSelect extends StatefulWidget {
  const ModeSelect({Key? key}) : super(key: key);

  @override
  State<ModeSelect> createState() => _ModeSelectState();
}

class _ModeSelectState extends State<ModeSelect> {
  LoginController login = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async{
        final shouldPop =
        await login.showWarningContext(context);
        return shouldPop ?? false;
    },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: ReusableAppBar(
            elevation: 0,
            color: Colors.white,
            action: [
              GestureDetector(
                onTap: () async{
                  login.clearCache();
                  Get.offAll(()=> const LoginScreen());
                 // await login.loginOutMethod(context);
                },
                child:  const Icon(
                  Icons.logout_sharp,
                  color: ConstantColors.uniGreen,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.height / 1.8,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: ConstantColors.uniGreen,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(login.userId.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                      Text(login.userName.value, style: const TextStyle(fontSize: 12,),),
                      Text(login.deviceID.value, style: const TextStyle(fontSize: 12,),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TileBtn(imageName: 'images/wireless-symbol.png', buttonName: 'Online Mode', onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const TagSelectScreen()));
                  }),
                  TileBtn(imageName: 'images/no-internet.png', buttonName: 'Offline Mode', onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ScanTypeScreen()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
