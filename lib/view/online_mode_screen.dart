import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';
import 'dart:convert';

import '../model/productList_model.dart';

class OnlineMode extends StatefulWidget {
  const OnlineMode({Key? key}) : super(key: key);

  @override
  State<OnlineMode> createState() => _OnlineModeState();
}

class _OnlineModeState extends State<OnlineMode> {
  String _scannerStatus = "Scanner status";
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
  }

  @override
  void initState() {
    super.initState();
    productList();
    initScanner();
  }

  //controlling the scanner button
  void initScanner() async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) {
          setState(() {
            _lastCode = result.data;
            autoScan(_lastCode);
          });
        },
        onStatusUpdate: (result) {
          ScannerStatusType status = result.status;
          setState(() {
            _scannerStatus = status.toString().split('.')[1];
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
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              )),
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
                    Text(_lastCode,
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(width: 10.0),
                    Text('Status:'),
                    Text(_scannerStatus,
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: _isEnabled ? colors.comColor : Colors.grey),
            child: Text(
              _isEnabled ? 'Disactivate' : 'Activate',
            ),
            onPressed: () {
              FlutterDataWedge.enableScanner(!_isEnabled);
              setState(() {
                _isEnabled = !_isEnabled;
              });
            },
          ),
          Text(
            "List of Products added",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
              child: Container(
            child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Product Added.",
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    );
                  } else {
                    if (haveProduct == true) {
                      return const Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Container(
                        height: 150,
                        padding: EdgeInsets.only(
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
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Item Code : ${products[index].xitem}",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "Item Name :  ${products[index].xdesc}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Supplier Name :  ${products[index].xcusname}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Total Quantity :  ${products[index].xcount}",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Last Added Quantity :  ${products[index].lastqty}",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 120,
                                padding: EdgeInsets.only(
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
                                          "Date : ${products[index].xbodycode}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Time: ${products[index].xitem}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Edit quantity',
                                                  style: GoogleFonts.urbanist(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black54),
                                                ),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Item Code:    ${products[index].xitem}',
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      "Item Name :  ${products[index].xdesc}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      "Supplier Name:   ${products[index].xcusname}",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      "Total Quantity:   ${products[index].xcount}",
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Last added quantity : ",
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
                                                          height: 60,
                                                          width: 30,
                                                          child: TextField(
                                                            controller: qtyCon,
                                                            textAlign: TextAlign
                                                                .center,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            cursorColor: Theme
                                                                    .of(context)
                                                                .primaryColorDark,
                                                            decoration:
                                                                InputDecoration(
                                                              // border:
                                                              //     OutlineInputBorder(),
                                                              counterText: ' ',
                                                              hintText:
                                                                  " ${products[index].lastqty}",
                                                              hintStyle: GoogleFonts
                                                                  .urbanist(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            // onChanged:
                                                            //     (value) {
                                                            //   //focus scope next and previous use for control the controller movement.
                                                            //   if (value
                                                            //           .length ==
                                                            //       1) {
                                                            //     FocusScope.of(
                                                            //             context)
                                                            //         .nextFocus();
                                                            //   } else if (value
                                                            //       .isEmpty) {
                                                            //     FocusScope.of(
                                                            //             context)
                                                            //         .previousFocus();
                                                            //   }
                                                            // },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
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
                                                      await updateQty(
                                                          qtyCon.text,
                                                          '${products[index].xitem}');
                                                      await productList();
                                                      qtyCon.clear();
                                                      Navigator.pop(context);

                                                      // var snackBar = SnackBar(
                                                      //     content: Text('Hello World'));
                                                      // ScaffoldMessenger.of(context)
                                                      //     .showSnackBar(snackBar);
                                                      //scanBarcodeNormal();
                                                    },
                                                    child: Text(
                                                      "Update",
                                                      style:
                                                          GoogleFonts.urbanist(
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
                    }
                  }
                }),
          )),
        ],
      ),
    );
  }
}
