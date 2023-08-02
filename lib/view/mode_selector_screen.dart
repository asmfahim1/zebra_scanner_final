import 'package:flutter/material.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/view/online_process/tag_selection.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/widgets/reusable_tile.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    //login.fetchMasterItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ReusableAppBar(
          elevation: 0,
          color: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const TagSelectScreen()));
                        },
                        child: const Text("Online_Mode")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const ScanTypeScreen()));
                        },
                        child: const Text("Offline_Mode")),*/
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
              );
      }),
    );
  }
}
