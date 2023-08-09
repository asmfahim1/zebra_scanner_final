import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        child: SizedBox(
          width: double.maxFinite,
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
                  TileBtn(imageName: 'images/barcode-scan.png', buttonName: 'Scan Data', onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const OfflineScanScreen()));
                  }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TileBtn(imageName: 'images/table.png', buttonName: 'Show Data', onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ShowDataScreen()));
                  }),
                  TileBtn(imageName: 'images/delete-folder.png', buttonName: 'Delete Data', onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReusableAlert(
                            offline: offline,
                          );
                        });
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const OfflineScanScreen()));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//delete data
//for delete alert
class ReusableAlert extends StatelessWidget {
  const ReusableAlert({
    Key? key,
    required this.offline,
  }) : super(key: key);

  final OfflineController offline;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete data',
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Do you want to delete data?',
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'No',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text(
            'Yes',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () async {
            await offline.deleteAllData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
