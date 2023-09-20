import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:zebra_scanner_final/constants/app_constants.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/controller/online_controller.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/view/online_process/online_edit_screen.dart';
import '../../widgets/reusable_alert.dart';

class OnlineMode extends StatefulWidget {
  final String tagNum;
  final String storeId;

  const OnlineMode({
    Key? key,
    required this.tagNum,
    required this.storeId,
  }) : super(key: key);

  @override
  State<OnlineMode> createState() => _OnlineModeState();
}

class _OnlineModeState extends State<OnlineMode> {
  LoginController login = Get.find<LoginController>();
  OnlineController onlineController = Get.put(OnlineController());
  ConstantColors colors = ConstantColors();

  @override
  void initState() {
    // onlineController.productList(widget.tagNum, login.serverIp.value, widget.storeId);
    initScanner(
      login.serverIp.value,
      widget.tagNum,
      widget.storeId,
      login.deviceID.value,
    );
    super.initState();
  }

  //controlling the scanner button
  Future<void> initScanner(
      String ipAddress, String tagNum, String storeId, String deviceId) async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) async {
          onlineController.lastCode.value = result.data;
          int codeLength = onlineController.lastCode.string.length;
          if (codeLength < 5) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => const ReusableAlerDialogue(
                headTitle: "Warning!",
                message: "Invalid code",
                btnText: "OK",
              ),
            );
          } else {
            await onlineController.addItem(
              ipAddress,
              onlineController.lastCode.value,
              tagNum,
              storeId,
              deviceId,
            );
            // await onlineController.productList(widget.tagNum, ipAddress, storeId);
          }
        },
        onStatusUpdate: (result) {
          ScannerStatusType status = result.status;
          onlineController.scannerStatus.value =
              status.toString().split('.')[1];
        });
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
            "Automatic Scan",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 12,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey
              )
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Scan Code : ',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(onlineController.lastCode.value,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ConstantColors.uniGreen)),
                  const SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
          Text(
            "List of Products added",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (onlineController.postProduct.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ConstantColors.comColor,
                  ),
                );
              } else {
                if (onlineController.productList.isEmpty) {
                  return Center(
                      child: Text(
                    "No product added yet",
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ));
                } else {
                  return ListView.builder(
                      itemCount: onlineController.productList.length,
                      itemBuilder: (context, index) {
                        var products =
                            onlineController.productList[index];
                        return Container(
                          height: MediaQuery.of(context).size.height / 4.22,
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.blueGrey,
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        products.itemCode!,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        products.itemDesc!,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Auto count: ',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '${products.autoQty}',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 11,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Manual count: ',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '${products.manualQty}',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 11,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Total Count :  ${products.scanQty}",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      onlineController
                                          .updateTQ('${products.autoQty}');
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                onlineController
                                                    .products[index].itemCode,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${products.itemDesc}',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Auto count: ',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${products.autoQty}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Manual count: ',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${products.manualQty}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "Total Count: ${products.scanQty}",
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            onlineController
                                                                .decrementQuantity();
                                                          },
                                                          child:
                                                              const CircleAvatar(
                                                            backgroundColor:
                                                                ConstantColors
                                                                    .comColor,
                                                            radius: 15,
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child: TextField(
                                                            inputFormatters: [
                                                              *//*FilteringTextInputFormatter
                                                                .deny(RegExp(
                                                                    r'^0')),*//*
                                                              FilteringTextInputFormatter.deny(RegExp(r'-')),
                                                              FilteringTextInputFormatter.deny(RegExp(r',')),
                                                              FilteringTextInputFormatter.deny(RegExp(r'\+')),
                                                              FilteringTextInputFormatter.deny(RegExp(r'\*')),
                                                              FilteringTextInputFormatter.deny(RegExp(r'/')),
                                                              FilteringTextInputFormatter.deny(RegExp(r'=')),
                                                              FilteringTextInputFormatter.deny(RegExp(r'%')),
                                                              FilteringTextInputFormatter.deny(RegExp(r' ')),
                                                            ],
                                                            textAlign: TextAlign
                                                                .center,
                                                            controller:
                                                                onlineController
                                                                    .qtyCon,
                                                           onSubmitted:
                                                                (value) {
                                                              if (value
                                                                  .isEmpty) {
                                                                onlineController
                                                                    .qtyCon
                                                                    .text = '0';
                                                              } else {
                                                                onlineController
                                                                        .quantity
                                                                        .value =
                                                                    double.parse(
                                                                        value);
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(focusedBorder:
                                                                  OutlineInputBorder(
                                                                    borderSide: const BorderSide(width: 1.5, color: ConstantColors.comColor,),
                                                                borderRadius: BorderRadius.circular(5.5),
                                                              ),
                                                              filled: true,
                                                              hintText:
                                                                  '${onlineController.products[index].autoQty}',
                                                              hintStyle: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 50,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              fillColor: Colors
                                                                  .blueGrey[50],
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        50),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          )),
                                                      GestureDetector(
                                                        onTap: () {
                                                          onlineController
                                                              .incrementQuantity();
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              ConstantColors
                                                                  .comColor,
                                                          radius: 15,
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    *//*TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: ConstantColors
                                                          .comColor
                                                          .withOpacity(0.7),
                                                    ),
                                                    onPressed: () async {
                                                      //post to api
                                                      await onlineController.adjustmentQty(
                                                              context,
                                                              products.scanQty,
                                                              login.serverIp.value,
                                                              products.itemCode,
                                                              widget.tagNum,
                                                              widget.storeId,
                                                              login.deviceID.value,
                                                      );
                                                      await onlineController
                                                          .productList(widget.tagNum, login.serverIp.value, widget.storeId);
                                                    },
                                                    child: Text(
                                                      "Adjustment",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),*//*
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              8.5,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: ConstantColors
                                                            .uniGreen,
                                                      ),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              ConstantColors
                                                                  .uniGreen
                                                                  .withOpacity(
                                                                      0.7),
                                                        ),
                                                        onPressed: () async {
                                                          await onlineController.updateQty(
                                                            login.serverIp.value,
                                                            products.itemCode,
                                                            widget.tagNum,
                                                            widget.storeId,
                                                            login.deviceID.value,
                                                          );
                                                          await onlineController.productList(
                                                                  widget.tagNum,
                                                                  login.serverIp.value,
                                                                  widget.storeId);
                                                          Navigator.pop(context);
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            duration: Duration(seconds: 1),
                                                            content: Text(
                                                              "Product updated successfully",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 18, color: Colors.white,),
                                                            ),
                                                          ));
                                                        },
                                                        child: Text(
                                                          "Update",
                                                          style: GoogleFonts.urbanist(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                              scrollable: true,
                                            );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ConstantColors.comColor
                                            .withOpacity(0.6),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Edit",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        );
                      });
                }
              }
            }),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(()=> ManualEntry(mode: 'Online',tagNum: widget.tagNum, storeId: widget.storeId,));
        },
        label: Row(
          children: [
            const Text("Manual add", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    width: 30,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent),
                    child: const Icon(
                      Icons.add_circle_outline_sharp,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        backgroundColor: ConstantColors.uniGreen,
      ),*/
    );
  }
}
