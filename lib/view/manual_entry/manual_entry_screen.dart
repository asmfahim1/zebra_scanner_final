import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/controller/manual_entry_controller.dart';
import 'package:get/get.dart';

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
  FocusNode quantityFocusNode = FocusNode();
  FocusNode itemFocusNode = FocusNode();

  //controlling the scanner button
  Future<void> initScanner() async {
    FlutterDataWedge.initScanner(
      profileName: 'FlutterDataWedge',
      onScan: (result) async{
        print('scanned code : $result');
      },
    );
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
    super.dispose();
    manual.releaseVariables(widget.mode.toString());
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
                height: 40,
                width: MediaQuery.of(context).size.width,
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
                  focusNode: itemFocusNode,
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
                        final result = await manual.getManualAddedProduct(widget.tagNum.toString(), manual.productCode.text);
                        if(result == 'Success'){
                          FocusScope.of(context).requestFocus(quantityFocusNode);
                        }else{
                          null ;
                        }
                      }else{
                        null ;
                      }
                    }else{
                      if(manual.productCode.text.length >= 5){
                        final result = await manual.getSingleScannedProduct();
                        if(result == 'Success'){
                          FocusScope.of(context).requestFocus(quantityFocusNode);
                        }else{
                          null ;
                        }
                      }else{
                        null ;
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 5,),
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.blueGrey,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Center(
                              child: Text('No product searched'),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _manualAddedProduct(manual: manual);
                    }
                  } else {
                    if (manual.singleAddedProducts.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.blueGrey,
                          child: Container(
                            height: 50,
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Center(
                              child: Text('No product searched'),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _manualOfflineAddedProduct(manual: manual);
                    }
                  }
                }
              }),
              const SizedBox(height: 5,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2,
                    padding:
                    const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: manual.isEmptyField.value ==
                            true
                            ? Colors.red
                            : Colors.grey,
                        width: manual.isEmptyField.value ==
                            true
                            ? 2.0
                            : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextFormField(
                      focusNode: quantityFocusNode,
                      controller: manual.qtyController,
                      inputFormatters: [
                        //FilteringTextInputFormatter.deny(RegExp(r'^0')),
                        // FilteringTextInputFormatter.deny(RegExp(r'-')),
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
                  const SizedBox(width: 20,),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13)),
                    clipBehavior: Clip.hardEdge,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ConstantColors.uniGreen,
                        ),
                        onPressed: () async{
                          if(widget.mode == 'Online'){
                            FocusScope.of(context).requestFocus(itemFocusNode);
                            await manual.addItemManually(
                              context,
                              login.serverIp.value,
                              login.deviceID.value,
                              login.userId.value,
                              widget.tagNum.toString(),
                              widget.storeId.toString(),
                            );

                          }else{
                            FocusScope.of(context).requestFocus(itemFocusNode);
                            await manual.addManuallyOffline(context);
                          }
                        },
                        child:  const Text('Add', style: TextStyle(fontSize: 16),)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Text('Last added : ',style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),),
              ),
              Obx(() {
                if (manual.entryDone.value) {
                  return Container(); // Display a loading indicator
                } else {
                  if (widget.mode == 'Online') {
                    if (manual.lastAddedItem == null) {
                      return Container();
                    } else {
                      return _lastAddedWidget(manual: manual);
                    }
                  } else {
                    return Container();
                  }
                }
              }),
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
          height: 50,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                manual.manualAddedProduct?.xdesc ?? 'Description : ',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Auto Count :',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${manual.manualAddedProduct?.autoQty.toString()}',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Row(
                    children: [
                      Text(
                        'Manual Count :',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${manual.manualAddedProduct?.manualQty.toString()}',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Total Count :',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${manual.manualAddedProduct?.scanQty.toString()}',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 12,
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

  Widget _manualOfflineAddedProduct({
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
          height: 50,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                manual.singleAddedProducts[0]["xdesc"],
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Auto Count :',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        manual.singleAddedProducts[0]["autoqty"].toString(),
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Row(
                    children: [
                      Text(
                        'Manual Count :',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        manual.singleAddedProducts[0]["manualqty"].toString(),
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Total Count :',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    manual.singleAddedProducts[0]["scanqty"].toString(),
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 12,
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

  Widget _lastAddedWidget({
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
          height: 50,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                manual.lastAddedItem?.xdesc ?? 'Description : ',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Auto Count :',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${ manual.lastAddedItem?.autoQty.toString()}',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Row(
                    children: [
                      Text(
                        'Manual Count :',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${ manual.lastAddedItem?.manualQty.toString()}',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Total Count :',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${ manual.lastAddedItem?.scanQty.toString()}',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 12,
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