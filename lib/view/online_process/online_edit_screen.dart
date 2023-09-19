import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/online_controller.dart';

class AutoScanEditScreen extends StatefulWidget {
  final String? tagNum;
  final String? storeId;
  const AutoScanEditScreen({
    this.tagNum,
    this.storeId,
    Key? key,
  }) : super(key: key);

  @override
  State<AutoScanEditScreen> createState() => _AutoScanEditScreenState();
}

class _AutoScanEditScreenState extends State<AutoScanEditScreen> {
  LoginController login = Get.find<LoginController>();
  OnlineController online = Get.find<OnlineController>();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode itemFocusNode = FocusNode();

  //controlling the scanner button
  Future<void> initScanner() async {
    FlutterDataWedge.initScanner(
      profileName: 'FlutterDataWedge',
      onScan: (result) async{
        print('scanned code : ${result.data}');
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
    online.releaseAutoEditScreenVariables();
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
              "Auto Scan Edit",
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
                    color: online.isAutoFieldEmpty.value ==
                        true
                        ? Colors.red
                        : Colors.grey,
                    width:
                    online.isAutoFieldEmpty.value ==
                        true
                        ? 2.0
                        : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextFormField(
                  controller: online.automaticProductCode,
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
                  // onChanged: (value) async{
                  //   if(widget.mode == 'Online'){
                  //     print('last added code before assign: ${manual.productCode.text}');
                  //     String itemCode = manual.productCode.text;
                  //     print('last added code after assign: $itemCode');
                  //     if(itemCode.length >= 5){
                  //       final result = await manual.getManualAddedProduct(widget.tagNum.toString(), itemCode);
                  //       if(result == 'Success'){
                  //         FocusScope.of(context).requestFocus(quantityFocusNode);
                  //       }else{
                  //         null ;
                  //       }
                  //     }else{
                  //       null ;
                  //     }
                  //   }else{
                  //     if(manual.productCode.text.length >= 5){
                  //       final result = await manual.getSingleScannedProduct();
                  //       if(result == 'Success'){
                  //         FocusScope.of(context).requestFocus(quantityFocusNode);
                  //       }else{
                  //         null ;
                  //       }
                  //     }else{
                  //       null ;
                  //     }
                  //   }
                  // },
                  onFieldSubmitted: (value) async{
                    String itemCode = online.automaticProductCode.text;
                    if(itemCode.length >= 5){
                      final result = await online.getSearchedAutomaticProduct(widget.tagNum.toString(), itemCode);
                      if(result == 'Success'){
                        FocusScope.of(context).requestFocus(quantityFocusNode);
                      }else{
                        null ;
                      }
                    }else{
                      null ;
                    }
                  },
                ),
              ),
              const SizedBox(height: 5,),
              Obx(() {
                if (online.isAutoUpdate.value) {
                  return Container(); // Display a loading indicator
                } else {
                  if (online.automaticAddedProductModel == null) {
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
                    return _automaticAddedProduct(online: online);
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
                        color: online.isAutoFieldEmpty.value ==
                            true
                            ? Colors.red
                            : Colors.grey,
                        width: online.isAutoFieldEmpty.value ==
                            true
                            ? 2.0
                            : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextFormField(
                      focusNode: quantityFocusNode,
                      controller: online.automaticQty,
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
                          final result = await online.updateAutomaticScanned(
                            context,
                            login.serverIp.value,
                            login.deviceID.value,
                            login.userId.value,
                            widget.tagNum.toString(),
                            widget.storeId.toString(),
                          );
                          if(result == 'Success'){
                            FocusScope.of(context).requestFocus(itemFocusNode);
                          }else{

                          }
                          /*if(online.automaticQty.text.startsWith('-')){
                            FocusScope.of(context).requestFocus(itemFocusNode);
                            await online.updateAutomaticScanned(
                              context,
                              login.serverIp.value,
                              login.deviceID.value,
                              login.userId.value,
                              widget.tagNum.toString(),
                              widget.storeId.toString(),
                            );
                          }else{
                            Get.snackbar(
                              'Warning!',
                              'Quantity must be negative',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                          }*/
                        },
                        child:  const Text('Update', style: TextStyle(fontSize: 16),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Text('Last Updated : ',style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),),
              ),
              Obx(() {
                if (online.isAutoUpdate.value) {
                  return Container(); // Display a loading indicator
                } else {
                  if (online.lastAutoAddedProductModel == null) {
                    return Container();
                  } else {
                    return _lastAddedWidget(online: online);
                  }
                }
              }),
            ],
          ),
        )
    );
  }

  Widget _automaticAddedProduct({
    required OnlineController online
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
                online.automaticAddedProductModel?.itemDesc ?? 'Description : ',
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
                        '${online.automaticAddedProductModel?.autoQty.toString()}',
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
                        '${online.automaticAddedProductModel?.manualQty.toString()}',
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
                    '${online.automaticAddedProductModel?.scanQty.toString()}',
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
    required OnlineController online
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
                online.lastAutoAddedProductModel?.itemDesc ?? 'Description : ',
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
                        '${ online.lastAutoAddedProductModel?.autoQty.toString()}',
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
                        '${ online.lastAutoAddedProductModel?.manualQty.toString()}',
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
                    '${ online.lastAutoAddedProductModel?.scanQty.toString()}',
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