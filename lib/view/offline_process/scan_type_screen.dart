import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/view/offline_process/offline-scan_screen.dart';
import 'package:zebra_scanner_final/view/offline_process/tag-selection_screen.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/reusable_tile.dart';

class ScanTypeScreen extends StatefulWidget {
  const ScanTypeScreen({Key? key}) : super(key: key);

  @override
  State<ScanTypeScreen> createState() => _ScanTypeScreenState();
}

class _ScanTypeScreenState extends State<ScanTypeScreen> {
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
        child: SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /*ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const OfflineTagScreen()));
                  },
                  child: const Text("Fetch data")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const OfflineScanScreen()));
                  },
                  child: const Text("Scan code")),*/
              TileBtn(imageName: 'images/data-transfer.png', buttonName: 'Fetch data', onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const OfflineTagScreen()));
              }),
              TileBtn(imageName: 'images/barcode-scan.png', buttonName: 'Scan data', onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const OfflineScanScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
