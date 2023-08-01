import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/view/tag_selection.dart';
import 'package:get/get.dart';
import 'offline.dart';

class ModeSelect extends StatefulWidget {
  const ModeSelect({Key? key}) : super(key: key);

  @override
  State<ModeSelect> createState() => _ModeSelectState();
}

class _ModeSelectState extends State<ModeSelect> {
  LoginController login = Get.find<LoginController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login.fetchMasterItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        return login.isFetched.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                    const Text('Loading...')
                  ],
                ),
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const TagSelectScreen()));
                          },
                          child: const Text("Online_Mode")),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const OfflineMode()));
                          },
                          child: const Text("Offline_Mode")),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
