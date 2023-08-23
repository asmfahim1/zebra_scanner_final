import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/controller/manual_entry_controller.dart';
import 'package:get/get.dart';
import '../../widgets/reusable_alert.dart';

class ManualEntry extends StatefulWidget {
  final String? mode;
  final String? tagNum;
  final String? storeId;
  const ManualEntry({
    this.mode,
    this.tagNum,
    this.storeId,
    Key? key,
  }) : super(key: key);

  @override
  State<ManualEntry> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
     LoginController login = Get.find<LoginController>();
     ManualController manual = Get.put(ManualController());
  // OnlineController online = Get.put(OnlineController());
  // OfflineController offline = Get.put(OfflineController());

  //controlling the scanner button
  Future<void> initScanner() async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) async{
          manual.productCode.clear();
          print('=====${manual.productCode.text}');
          manual.lastCode.value = result.data;
          manual.productCode.text = manual.lastCode.value;
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScanner();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose called');
    manual.releaseVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () async{
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Manual Scan",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: double.maxFinite,
              padding:
              const EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                  left: 10, top: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: manual.isEmptyField.value ==
                      true
                      ? Colors.red
                      : Colors.grey,
                  width:
                  manual.isEmptyField.value ==
                      true
                      ? 2.0
                      : 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TextFormField(
                controller: manual.productCode,
                autofocus: true,
                inputFormatters: [
                  //FilteringTextInputFormatter.deny(RegExp(r'^0')),
                  FilteringTextInputFormatter.deny(RegExp(r'-')),
                  FilteringTextInputFormatter.deny(RegExp(r'\.')),
                  FilteringTextInputFormatter.deny(RegExp(r',')),
                  FilteringTextInputFormatter.deny(RegExp(r'\+')),
                  FilteringTextInputFormatter.deny(RegExp(r'\*')),
                  FilteringTextInputFormatter.deny(RegExp(r'/')),
                  FilteringTextInputFormatter.deny(RegExp(r'=')),
                  FilteringTextInputFormatter.deny(RegExp(r'%')),
                  FilteringTextInputFormatter.deny(RegExp(r' ')),
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter product code',
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
                onChanged: (value) async{
                  if(widget.mode == 'Online'){
                    if(manual.productCode.text.length >= 5){
                      print('==============Search from server : ${manual.productCode}============');
                      await manual.getManualAddedProduct(widget.tagNum.toString(), manual.productCode.text);
                    }else{
                    }
                  }else{
                    print('go to offline mode');
                  }
                },
              ),
            ),
            const SizedBox(height: 10,),
            Obx(() {
              if (manual.entryDone.value) {
                return Container(); // Display a loading indicator
              } else {
                if (widget.mode == 'Online') {
                  if (manual.manualAddedProduct == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.blueGrey,
                        child: Container(
                          height: 100,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Center(
                            child: Text('No product added yet'),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return _manualAddedProduct(manual: manual);
                  }
                } else {
                  if (manual.manualAddedProduct == null) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.blueGrey,
                      child: Container(
                        height: 100,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Center(
                          child: Text('No product added yet'),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(); // Return an empty SizedBox if not needed
                  }
                }
              }
            }),

            const SizedBox(height: 10,),
            Container(
              height: 50,
              width: double.maxFinite,
              padding:
              const EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                  left: 10, top: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: manual.isEmptyField.value ==
                      true
                      ? Colors.red
                      : Colors.grey,
                  width:
                  manual.isEmptyField.value ==
                      true
                      ? 2.0
                      : 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TextFormField(
                controller: manual.qtyController,
                inputFormatters: [
                  //FilteringTextInputFormatter.deny(RegExp(r'^0')),
                  FilteringTextInputFormatter.deny(RegExp(r'-')),
                  FilteringTextInputFormatter.deny(RegExp(r',')),
                  FilteringTextInputFormatter.deny(RegExp(r'\+')),
                  FilteringTextInputFormatter.deny(RegExp(r'\*')),
                  FilteringTextInputFormatter.deny(RegExp(r'/')),
                  FilteringTextInputFormatter.deny(RegExp(r'=')),
                  FilteringTextInputFormatter.deny(RegExp(r'%')),
                  FilteringTextInputFormatter.deny(RegExp(r' ')),
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter quantity',
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0)),
              clipBehavior: Clip.hardEdge,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ConstantColors.uniGreen,
                  ),
                  onPressed: () {
                    if(widget.mode == 'Online'){
                      //online logic
                      manual.addItemManually(
                        context,
                        login.serverIp.value,
                        login.deviceID.value,
                        login.userId.value,
                        widget.tagNum.toString(),
                        widget.storeId.toString(),
                      );
                    }else{
                      manual.addManuallyOffline(context);
                    }
                  },
                  child:  const Text('Submit', style: TextStyle(fontSize: 16),)
              ),
            ),

          ],
        ),
      )
    );
  }

  Widget _manualAddedProduct({
  required ManualController manual
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.blueGrey,
        child: Container(
          height: 80,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                manual.manualAddedProduct?.xdesc ?? 'Description : ',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              /*Text(
                      subTitle,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),*/
              Row(
                children: [
                  Text(
                    'Previous Count :',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${manual.manualAddedProduct?.quantity.toString()}',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
