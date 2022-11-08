import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:zebra_scanner_final/controller/online_controller.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import 'package:zebra_scanner_final/widgets/reusable_textfield.dart';

class OnlineMode extends StatefulWidget {
  //apadoto storeId and outlet same e rakhtesi
  String tagNum;
  String storeId;
  String userId;
  String outlet;
  String adminId;
  OnlineMode({
    Key? key,
    required this.tagNum,
    required this.storeId,
    required this.userId,
    required this.outlet,
    required this.adminId,
  }) : super(key: key);

  @override
  State<OnlineMode> createState() => _OnlineModeState();
}

class _OnlineModeState extends State<OnlineMode> {
  OnlineController onlineController = Get.put(OnlineController());
  ConstantColors colors = ConstantColors();

  /* String _scannerStatus = "Scanner status";
  String _lastCode = '';
  bool _isEnabled = true;
  TextEditingController qtyCon = TextEditingController();
  ConstantColors colors = ConstantColors();
  //API for ProductList
  bool haveProduct = false;
  List<ProductList> products = [];
  Future<void> productList() async {
    setState(() {
      haveProduct = true;
    });
    var response = await http
        .get(Uri.parse("http://172.20.20.69/sina/unistock/allProductList.php"));
    if (response.statusCode == 200) {
      products = productListFromJson(response.body);
      print(response.body);
    } else {
      products = [];
    }
    setState(() {
      haveProduct = false;
    });
  }
  //update quantity
  Future<void> updateQty(String amt, String item) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/update_item.php"),
        body: jsonEncode(<String, dynamic>{"item": item, "qty": amt}));
  }
  //autoscann
  Future<void> autoScan(String lastCode) async {
    var response = await http.post(
        Uri.parse("http://172.20.20.69/sina/unistock/scan_only.php"),
        body: jsonEncode(<String, dynamic>{
          "item": lastCode,
          "xwh": "Sina",
          "prep_id": "6"
        }));
    print(response.body);
    productList();
  }*/

  @override
  void initState() {
    super.initState();
    onlineController.productList(widget.tagNum);
    print('======${widget.tagNum}');
    initScanner(widget.userId, widget.tagNum, widget.adminId, widget.outlet,
        widget.storeId);
  }

  //controlling the scanner button
  void initScanner(String userId, String tagNum, String adminId, String outlet,
      String storeId) async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) {
          setState(() {
            onlineController.lastCode.value = result.data;
            onlineController.addItem(onlineController.lastCode.value, userId,
                tagNum, adminId, outlet, storeId);
            onlineController.productList(widget.tagNum);
          });
        },
        onStatusUpdate: (result) {
          ScannerStatusType status = result.status;
          setState(() {
            onlineController.scannerStatus.value =
                status.toString().split('.')[1];
          });
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
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Last code:'),
                    Text(onlineController.lastCode.value,
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(width: 10.0),
                    Text('Status:'),
                    Text(onlineController.scannerStatus.value,
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: onlineController.isEnabled.value
                      ? colors.comColor
                      : Colors.grey),
              child: Text(
                onlineController.isEnabled.value ? 'Disactivate' : 'Activate',
              ),
              onPressed: () {
                onlineController.enableButton();
              },
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
              if (onlineController.haveProduct.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colors.comColor,
                  ),
                );
              } else {
                if (onlineController.products.isEmpty) {
                  return const Center(
                    child: Text("No Product present"),
                  );
                } else {
                  return ListView.builder(
                      itemCount: onlineController.products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 150,
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 5, right: 5),
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
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Item Code : ${onlineController.products[index].itemCode}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          "Item Name :  ${onlineController.products[index].itemDesc}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "Supplier Name :  ${onlineController.products[index].xcus}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "Total Quantity :  ${onlineController.products[index].scanQty}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        /*Text(
                                          "Last Added Quantity :  ${onlineController.products[index].}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 5, bottom: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date : ${onlineController.products[index].ztime}",
                                            style: GoogleFonts.urbanist(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          /*Text(
                                            "Time: ${onlineController.products[index].xitem}",
                                            style: GoogleFonts.urbanist(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    onlineController
                                                        .products[index]
                                                        .itemCode,
                                                    style: GoogleFonts.urbanist(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black54),
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${onlineController.products[index].itemDesc}',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      Text(
                                                        "${onlineController.products[index].xcus}",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      Text(
                                                        "Total Quantity: ${onlineController.products[index].scanQty}",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          /*Text(
                                                            "Quantity : ",
                                                            style: GoogleFonts
                                                                .urbanist(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black54),
                                                          ),*/
                                                          GestureDetector(
                                                              onTap: () {
                                                                onlineController
                                                                    .decrementQuantity();
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    colors
                                                                        .comColor,
                                                                radius: 15,
                                                                child:
                                                                    const Icon(
                                                                  Icons.remove,
                                                                  size: 20,
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Obx(
                                                            () => Container(
                                                              width: 100,
                                                              child: TextField(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                controller:
                                                                    onlineController
                                                                        .qtyCon,
                                                                decoration:
                                                                    InputDecoration(
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      width:
                                                                          1.5,
                                                                      color: colors
                                                                          .comColor,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.5),
                                                                  ),
                                                                  enabledBorder:
                                                                      const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      width:
                                                                          1.5,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                  filled: true,
                                                                  hintText:
                                                                      '${onlineController.quantity.value}',
                                                                  hintStyle: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                  fillColor:
                                                                      Colors.blueGrey[
                                                                          50],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          GestureDetector(
                                                              onTap: () {
                                                                onlineController
                                                                    .incrementQuantity();
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    colors
                                                                        .comColor,
                                                                radius: 15,
                                                                child:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  size: 20,
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.amberAccent,
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
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              //fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ));
                                                        //post to api
                                                        await onlineController
                                                            .updateQty(
                                                          onlineController
                                                              .products[index]
                                                              .itemCode,
                                                          widget.userId,
                                                          widget.tagNum,
                                                          widget.adminId,
                                                          widget.outlet,
                                                          widget.storeId,
                                                        );
                                                        await onlineController
                                                            .productList(
                                                                widget.tagNum);
                                                        Navigator.pop(context);

                                                        // var snackBar = SnackBar(
                                                        //     content: Text('Hello World'));
                                                        // ScaffoldMessenger.of(context)
                                                        //     .showSnackBar(snackBar);
                                                        //scanBarcodeNormal();
                                                      },
                                                      child: Text(
                                                        "Update",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  scrollable: true,
                                                );
                                              });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
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
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              }
            }),
          )),
        ],
      ),
    );
  }
}
