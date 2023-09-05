import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/view/manual_entry/manual_entry_screen.dart';
import 'package:zebra_scanner_final/view/online_process/online_mode_screen.dart';
import 'package:zebra_scanner_final/widgets/reusable_tile.dart';

class OnlineScanTypeScreen extends StatefulWidget {
 final String tagNum;
  final String storeId;
  const OnlineScanTypeScreen({Key? key, required this.tagNum, required this.storeId})
      : super(key: key);

  @override
  State<OnlineScanTypeScreen> createState() => _OnlineScanTypeScreenState();
}

class _OnlineScanTypeScreenState extends State<OnlineScanTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
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
            title: Text(
              "Scan type",
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            )),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TileBtn(
              imageName: 'images/auto_scan.png',
              buttonName: 'Automatic scan',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnlineMode(
                      tagNum: widget.tagNum,
                      storeId: widget.storeId,
                    ),
                  ),
                );
              },
            ),
            TileBtn(
              imageName: 'images/manual_scan.png',
              buttonName: 'Manual entry',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManualEntry(
                      tagNum: widget.tagNum,
                      storeId: widget.storeId,
                      mode: 'Online',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
