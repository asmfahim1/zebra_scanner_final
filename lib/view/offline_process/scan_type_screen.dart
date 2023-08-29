import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/view/manual_entry/manual_entry_screen.dart';
import 'package:zebra_scanner_final/view/offline_process/offline-scan_screen.dart';
import 'package:zebra_scanner_final/view/offline_process/show_data_screen.dart';
import 'package:zebra_scanner_final/view/offline_process/tag-selection_screen.dart';
import '../../controller/offline_controller.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/reusable_tile.dart';

class ScanTypeScreen extends StatefulWidget {
  const ScanTypeScreen({Key? key}) : super(key: key);

  @override
  State<ScanTypeScreen> createState() => _ScanTypeScreenState();
}

class _ScanTypeScreenState extends State<ScanTypeScreen> {
  OfflineController offline = Get.put(OfflineController());
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TileBtn(imageName: 'images/data-transfer.png', buttonName: 'Fetch Data', onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const OfflineTagScreen()));
                }),
                TileBtn(imageName: 'images/table.png', buttonName: 'Show Data', onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ShowDataScreen()));
                }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TileBtn(
                  imageName: 'images/auto_scan.png',
                  buttonName: 'Automatic scan',
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OfflineScanScreen(),
                      ),
                    );
                }),
                TileBtn(
                  imageName: 'images/manual_scan.png',
                  buttonName: 'Manual entry',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualEntry(
                          mode: 'Offline',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

