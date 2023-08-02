import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import '../../controller/server_controller.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/const_colors.dart';

class OfflineScanScreen extends StatefulWidget {
  const OfflineScanScreen({Key? key}) : super(key: key);

  @override
  State<OfflineScanScreen> createState() => _OfflineScanScreenState();
}

class _OfflineScanScreenState extends State<OfflineScanScreen> {
  OfflineController offline = Get.find<OfflineController>();
  ServerController serverController = Get.put(ServerController());

  @override
  void initState() {
    offline.getScannerTable();
    initScanner(
        serverController.ipAddress.value,
        'widget.userId',
        'widget.tagNum',
        'widget.outlet',
        'widget.storeId',
        serverController.deviceID.value);
    super.initState();
  }

  //controlling the scanner button
  Future<void> initScanner(String ipAddress, String userId, String tagNum, String outlet, String storeId, String deviceId) async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) async {
          offline.lastCode.value = result.data;
          await offline.addItem(
              ipAddress,
              offline.lastCode.value,
              userId,
              tagNum,
              outlet,
              storeId,
              deviceId);
          // await offline.productList('widget.tagNum', ipAddress);
        },
        onStatusUpdate: (result) {
          ScannerStatusType status = result.status;
          offline.scannerStatus.value = status.toString().split('.')[1];
        });
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
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Obx((){
          return offline.productLoaded.value
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                                  () => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Last code: '),
                                  Text(offline.lastCode.value,
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(width: 10.0),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "List of Products added",
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(child: Container(
                      child: Obx(() {
                        if (offline.haveProduct.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ConstantColors.comColor,
                            ),
                          );
                        } else {
                          if (offline.products.isEmpty) {
                            return Center(
                                child: Text(
                                  "No product found",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ));
                          } else {
                            return ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
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
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text('item code',
                                                    style: GoogleFonts.urbanist(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text('item desc',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.urbanist(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text('xcus',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.urbanist(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Total Quantity :  ",
                                                    style: GoogleFonts.urbanist(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              /*offline.updateTQ(
                                                '${onlineController.products[index].scanQty}');
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      onlineController
                                                          .products[index].itemCode,
                                                      style: GoogleFonts.urbanist(
                                                          fontSize: 30,
                                                          fontWeight: FontWeight.w800,
                                                          color: Colors.black54),
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${onlineController.products[index].itemDesc}',
                                                          style: GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w800,
                                                              color: Colors.black54),
                                                        ),
                                                        Text(
                                                          "${onlineController.products[index].xcus}",
                                                          style: GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w800,
                                                              color: Colors.black54),
                                                        ),
                                                        Text(
                                                          "Total Quantity: ${onlineController.products[index].scanQty}",
                                                          style: GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight.w800,
                                                              color: Colors.black54),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  onlineController.decrementQuantity();
                                                                },
                                                                child: CircleAvatar(
                                                                  backgroundColor:
                                                                  ConstantColors.comColor,
                                                                  radius: 15,
                                                                  child: const Icon(
                                                                    Icons.remove,
                                                                    size: 20,
                                                                  ),
                                                                )),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width /
                                                                    3.5,
                                                                child: TextField(
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'^0')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'-')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r',')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'\+')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'\*')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'/')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'=')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r'%')),
                                                                    FilteringTextInputFormatter
                                                                        .deny(RegExp(
                                                                        r' ')),
                                                                  ],
                                                                  textAlign: TextAlign.center,
                                                                  controller: onlineController.qtyCon,
                                                                  //by using on submitted function, it will immediately after pressing the value done
                                                                  onSubmitted: (value) {
                                                                    if (value.isEmpty) {
                                                                      onlineController.qtyCon.text = '0';
                                                                      print('====${onlineController.quantity.value}======${onlineController.qtyCon.text}');
                                                                    } else {
                                                                      onlineController.quantity.value = int.parse(value);
                                                                      print('====${onlineController.quantity.value}======${onlineController.qtyCon.text}');
                                                                    }
                                                                  },
                                                                  decoration: InputDecoration(
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(width: 1.5, color: ConstantColors.comColor,),
                                                                      borderRadius: BorderRadius.circular(5.5),
                                                                    ),
                                                                    filled: true,
                                                                    hintText:
                                                                    '${onlineController.products[index].scanQty}',
                                                                    hintStyle: const TextStyle(color: Colors.white, fontSize: 50,fontWeight: FontWeight.w600),
                                                                    fillColor: Colors.blueGrey[50],
                                                                  ),
                                                                  style:
                                                                  const TextStyle(
                                                                      fontSize: 50),
                                                                  keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                                )),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  onlineController
                                                                      .incrementQuantity();
                                                                },
                                                                child: CircleAvatar(
                                                                  backgroundColor:
                                                                  ConstantColors.comColor,
                                                                  radius: 15,
                                                                  child: const Icon(
                                                                    Icons.add,
                                                                    size: 20,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                              backgroundColor: ConstantColors
                                                                  .comColor
                                                                  .withOpacity(0.7),
                                                            ),
                                                            onPressed: () async {
                                                              //post to api
                                                              await onlineController
                                                                  .adjustmentQty(
                                                                  context,
                                                                  onlineController
                                                                      .products[
                                                                  index]
                                                                      .scanQty,
                                                                  serverController
                                                                      .ipAddress
                                                                      .value,
                                                                  onlineController
                                                                      .products[
                                                                  index]
                                                                      .itemCode,
                                                                  widget.userId,
                                                                  widget.tagNum,
                                                                  widget.outlet,
                                                                  widget.storeId,
                                                                  serverController
                                                                      .deviceID
                                                                      .value);
                                                              await onlineController
                                                                  .productList(
                                                                  widget.tagNum,
                                                                  serverController
                                                                      .ipAddress
                                                                      .value);

                                                              // var snackBar = SnackBar(
                                                              //     content: Text('Hello World'));
                                                              // ScaffoldMessenger.of(context)
                                                              //     .showSnackBar(snackBar);
                                                              //scanBarcodeNormal();
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
                                                          ),
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                              backgroundColor: ConstantColors
                                                                  .uniGreen
                                                                  .withOpacity(0.7),
                                                            ),
                                                            onPressed: () async {
                                                              ScaffoldMessenger.of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  const SnackBar(
                                                                    duration: Duration(
                                                                        seconds: 1),
                                                                    content: Text(
                                                                      "Product updated successfully",
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                      style: TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        fontSize: 18,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ));
                                                              //post to api
                                                              await onlineController
                                                                  .updateQty(
                                                                  serverController
                                                                      .ipAddress
                                                                      .value,
                                                                  onlineController
                                                                      .products[
                                                                  index]
                                                                      .itemCode,
                                                                  widget.userId,
                                                                  widget.tagNum,
                                                                  widget.outlet,
                                                                  widget.storeId,
                                                                  serverController
                                                                      .deviceID
                                                                      .value);
                                                              await onlineController
                                                                  .productList(
                                                                  widget.tagNum,
                                                                  serverController
                                                                      .ipAddress
                                                                      .value);
                                                              Navigator.pop(context);

                                                              // var snackBar = SnackBar(
                                                              //     content: Text('Hello World'));
                                                              // ScaffoldMessenger.of(context)
                                                              //     .showSnackBar(snackBar);
                                                              //scanBarcodeNormal();
                                                            },
                                                            child: Text(
                                                              "Manual",
                                                              style:
                                                              GoogleFonts.urbanist(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                    scrollable: true,
                                                  );
                                                });*/
                                            },
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: ConstantColors.comColor.withOpacity(0.6),
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
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }
                      }),
                    ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
