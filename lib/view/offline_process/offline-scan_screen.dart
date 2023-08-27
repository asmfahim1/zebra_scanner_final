import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import '../../controller/server_controller.dart';
import '../../constants/const_colors.dart';
import '../../widgets/reusable_alert.dart';
import '../manual_entry/manual_entry_screen.dart';

class OfflineScanScreen extends StatefulWidget {
  const OfflineScanScreen({Key? key}) : super(key: key);

  @override
  State<OfflineScanScreen> createState() => _OfflineScanScreenState();
}

class _OfflineScanScreenState extends State<OfflineScanScreen> {
  OfflineController offline = Get.put(OfflineController());
  ServerController serverController = Get.put(ServerController());

  @override
  void initState() {
    offline.getScannerTable();
    initScanner();
    super.initState();
  }

  //controlling the scanner button
  Future<void> initScanner() async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) async {
          offline.lastCode.value = result.data;
          int codeLength = offline.lastCode.string.length;
          if (codeLength == 5 || codeLength == 12) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => const ReusableAlerDialogue(
                headTitle: "Warning!",
                message: "Add Manually",
                btnText: "OK",
              ),
            );
            await offline.getScannerTable();
          } else if (codeLength < 5) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => const ReusableAlerDialogue(
                headTitle: "Warning!",
                message: "Invalid code",
                btnText: "OK",
              ),
            );
            await offline.getScannerTable();
          } else {
              await offline.addItem(offline.lastCode.value);
          }
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
            /*title: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: TextFormField(
                controller: offline.searchByName,
                decoration: const InputDecoration(
                    hintText: 'Search by name',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search)),
                onChanged: (value) => offline.searchProduct(value),
              ),
            ),*/
          actions: [
            GestureDetector(
            onTap: () {offline.uploadToServer();},
            child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.upload_rounded,
                  size: 30,
                  color: ConstantColors.uniGreen1,
                )
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
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
                          const Text('Last code : '),
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
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(child: Obx(() {
              if (offline.productLoaded.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        child: const CircularProgressIndicator(
                          color: ConstantColors.comColor,
                        ),
                      ),
                      const Text('Loading...'),
                    ],
                  ),
                ) ;
              } else {
                if (offline.filteredProductList.isEmpty) {
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
                      itemCount: offline.filteredProductList.length,
                      itemBuilder: (context, index) {
                        var scanned = offline.filteredProductList[index];
                        return Container(
                          height: MediaQuery.of(context).size.height / 4.22,
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            color: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.blueGrey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('${scanned["itemcode"]}',
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text('${scanned["itemdesc"]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text('xcus : ${scanned["xcus"]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          "Total Quantity : ${scanned["scanqty"]}",
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
                                    offline.updateTQ('${scanned["scanqty"].toString()}');
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(scanned["itemcode"],
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
                                                  '${scanned["itemdesc"]}',
                                                  style: GoogleFonts.urbanist(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      color: Colors.black54),
                                                ),
                                                Text(
                                                  "${scanned["xcus"]}",
                                                  style: GoogleFonts.urbanist(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      color: Colors.black54),
                                                ),
                                                Text(
                                                  "Total Quantity: ${scanned["scanqty"]}",
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
                                                          offline.decrementQuantity();
                                                        },
                                                        child: const CircleAvatar(
                                                          backgroundColor:
                                                          ConstantColors.comColor,
                                                          radius: 15,
                                                          child: Icon(
                                                            Icons.remove,
                                                            size: 20,
                                                          ),
                                                        )),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                        width: MediaQuery.of(context).size.width / 3.5,
                                                        child: TextField(
                                                          inputFormatters: [
                                                            /*FilteringTextInputFormatter.deny(RegExp(r'^0')),
                                                            FilteringTextInputFormatter.deny(RegExp(r'-')),*/
                                                            FilteringTextInputFormatter.deny(RegExp(r',')),
                                                            FilteringTextInputFormatter.deny(RegExp(r'\+')),
                                                            FilteringTextInputFormatter.deny(RegExp(r'\*')),
                                                            FilteringTextInputFormatter.deny(RegExp(r'/')),
                                                            FilteringTextInputFormatter.deny(RegExp(r'=')),
                                                            FilteringTextInputFormatter.deny(RegExp(r'%')),
                                                            FilteringTextInputFormatter.deny(RegExp(r' ')),
                                                          ],
                                                          textAlign: TextAlign.center,
                                                          controller: offline.qtyCon,
                                                          //by using on submitted function, it will immediately after pressing the value done
                                                          onSubmitted: (value) {
                                                            if (value.isEmpty) {
                                                              offline.qtyCon.text = '0';
                                                              print('====${offline.quantity.value}======${offline.qtyCon.text}');
                                                            } else {
                                                              offline.quantity.value = double.parse(value);
                                                              print('====${offline.quantity.value}======${offline.qtyCon.text}');
                                                            }
                                                          },
                                                          decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(width: 1.5, color: ConstantColors.comColor,),
                                                              borderRadius: BorderRadius.circular(5.5),
                                                            ),
                                                            filled: true,
                                                            hintText:
                                                            '${scanned["scanqty"]}',
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
                                                          offline.incrementQuantity();
                                                        },
                                                        child: const CircleAvatar(
                                                          backgroundColor:
                                                          ConstantColors.comColor,
                                                          radius: 15,
                                                          child: Icon(
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
                                                mainAxisAlignment: MainAxisAlignment.center ,
                                                children: [
                                                  /*TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: ConstantColors
                                                          .comColor
                                                          .withOpacity(0.7),
                                                    ),
                                                    onPressed: () async {
                                                      //post to api
                                                      await offline.adjustmentQty(context,double.parse(scanned["scanqty"]),scanned["itemcode"]);
                                                      await offline.getScannerTable();
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
                                                  ),*/
                                                  Container(
                                                    height: MediaQuery.of(context).size.width / 8.5,
                                                    width: MediaQuery.of(context).size.width / 4,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      color: ConstantColors.uniGreen,
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: ConstantColors
                                                            .uniGreen
                                                            .withOpacity(0.7),
                                                      ),
                                                      onPressed: () async {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                              duration: Duration(seconds: 1),
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
                                                            ),
                                                        );
                                                        await offline.updateQty(scanned["itemcode"]);
                                                        await offline.getScannerTable();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Update",
                                                        style:
                                                        GoogleFonts.urbanist(
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                        ),
                                                      ),
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
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          Get.to(()=> const ManualEntry(mode: 'offline',));
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
                // Obx(() => Positioned(
                //     right: 10,
                //     top: -1,
                //     child: BigText(
                //   0285602    text: '${cartController.totalClick}',
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
        backgroundColor: ConstantColors.uniGreen,
      ),*/
    );
  }
}
