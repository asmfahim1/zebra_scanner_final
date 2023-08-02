// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_datawedge/flutter_datawedge.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:sqflite/sqflite.dart';
// import 'package:get/get.dart';
// import '../../db_helper/item_repo.dart';
// import '../../widgets/appBar_widget.dart';
//
// class OfflineMode extends StatefulWidget {
//   const OfflineMode({Key? key}) : super(key: key);
//   @override
//   State<OfflineMode> createState() => _OfflineModeState();
// }
//
// class _OfflineModeState extends State<OfflineMode> {
//   String _scannerStatus = "Scanner status";
//   String _lastCode = '';
//   bool _isEnabled = true;
//   TextEditingController qtyCon = TextEditingController();
//   Database? database;
// /*  //open database
//   Future<Database?> openDB() async {
//     database = await DatabaseHandler().openDB();
//     return database;
//   }
//   //insert database
//   Future<void> insertDB() async {
//     database = await openDB();
//     ItemsRepo itemsRepo = ItemsRepo();
//     itemsRepo.createTable(database);
//     ItemsModel itemsModel =
//         ItemsModel(item_code: _lastCode, item_quantity: 1.toString());
//     await database?.insert('ITEMS', itemsModel.toMap());
//     await database?.close();
//   }
//   //get items
//   Future<void> getFromItems() async {
//     database = await openDB();
//     ItemsRepo itemsRepo = ItemsRepo();
//     await itemsRepo.getItems(database);
//     await database?.close();
//   }*/
// /*  //API for ProductList
//   bool haveProduct = false;
//   List<ProductList> products = [];
//   Future<void> productList() async {
//     setState(() {
//       haveProduct = true;
//     });
//     var response = await http
//         .get(Uri.parse("http://172.20.20.69/sina/unistock/product_list.php"));
//     if (response.statusCode == 200) {
//       products = productListFromJson(response.body);
//       print(response.body);
//     } else {
//       products = [];
//     }
//     setState(() {
//       haveProduct = false;
//     });
//   }
//   //update quantity
//   Future<void> updateQty(String amt, String item) async {
//     var response = await http.post(
//         Uri.parse("http://172.20.20.69/sina/unistock/update_item.php"),
//         body: jsonEncode(<String, dynamic>{"item": item, "qty": amt}));
//   }
//   //autoscann
//   Future<void> autoScan(String lastCode) async {
//     var response = await http.post(
//         Uri.parse("http://172.20.20.69/sina/unistock/scan_only.php"),
//         body: jsonEncode(<String, dynamic>{
//           "item": lastCode,
//           "xwh": "Sina",
//           "prep_id": "6"
//         }));
//     print(response.body);
//     productList();
//   }*/
//   List<Map<String, dynamic>> itemsList = [];
//   bool _isLoading = true;
//   void getItemsList() async {
//     final getData = await ItemsRepo.getUsers();
//     setState(() {
//       itemsList = getData;
//       itemsList = itemsList.reversed.toList();
//       print("-------------------${itemsList}--------------------------");
//       print(
//           "-------------------------------${itemsList.length}-------------------------------");
//       _isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getItemsList();
//     initScanner();
//   }
//
//   //controlling the scanner button
//   void initScanner() async {
//     FlutterDataWedge.initScanner(
//         profileName: 'FlutterDataWedge',
//         onScan: (result) async {
//           setState(() {
//             _lastCode = result.data;
//           });
//           if (id == null) {
//             await addNewUser();
//             getItemsList();
//           }
//           if (id != null) {
//             await updateUser(id!);
//             getItemsList();
//           }
//         },
//         onStatusUpdate: (result) {
//           ScannerStatusType status = result.status;
//           setState(() {
//             _scannerStatus = status.toString().split('.')[1];
//           });
//         });
//   }
//
//   //item wise update
//   void selectedUser(id, itemCode) async {
//     if (id != null) {
//       final selectedId = itemsList.firstWhere((element) => element['id'] == id);
//       itemCode = selectedId['item_code'];
//       qtyController.text = selectedId['item_quantity'];
//     }
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0),
//             contentPadding: const EdgeInsets.only(top: 12, left: 0, bottom: 10),
//             insetPadding: const EdgeInsets.symmetric(horizontal: 15),
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(15.0))),
//             title: Padding(
//               padding: const EdgeInsets.only(left: 15.0, right: 15),
//               child: Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                 )),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const SizedBox(),
//                     Row(
//                       children: const [
//                         Text(
//                           "Update Quantity",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.close,
//                         size: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             content: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 15.0, right: 15),
//                 child: ListBody(
//                   children: <Widget>[
//                     Text(
//                       itemCode,
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: qtyController,
//                       decoration:
//                           const InputDecoration(hintText: 'items Quantity'),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         for (int i = 1; i <= 100000; i++) {
//                           if (id == null) {
//                             await addNewUser();
//                           }
//                           if (id != null) {
//                             await updateUser(id);
//                           }
//                         }
//                         Navigator.of(context).pop();
//                         print('button pressed');
//                       },
//                       child: Text(id == null ? 'Create' : 'Update'),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(50),
//     child: ReusableAppBar(
//     elevation: 0,
//     color: Colors.white,
//     leading: GestureDetector(
//     onTap: () {
//     Get.back();
//     },
//     child: const Icon(
//     Icons.arrow_back,
//     size: 30,
//     color: Colors.black,
//     ),
//     ),),),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Text('Last code:'),
//                     Text(_lastCode,
//                         style: Theme.of(context).textTheme.headline5),
//                     SizedBox(width: 10.0),
//                     Text('Status:'),
//                     Text(_scannerStatus,
//                         style: Theme.of(context).textTheme.headline6),
//                   ],
//                 ),
//                 SizedBox(height: 10.0),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             child: Text(_isEnabled ? 'Disactivate' : 'Activate'),
//             onPressed: () {
//               FlutterDataWedge.enableScanner(!_isEnabled);
//               setState(() {
//                 _isEnabled = !_isEnabled;
//               });
//             },
//           ),
//           Text(
//             "List of Products added",
//             style: GoogleFonts.urbanist(
//               color: Colors.black,
//               fontSize: 25,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.only(
//                 top: 5,
//                 bottom: 5,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: _isLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : ListView.builder(
//                       itemCount: itemsList.length,
//                       itemBuilder: (context, index) => Card(
//                         child: ListTile(
//                             title: Row(
//                               children: [
//                                 Text(
//                                   "${itemsList[index]['id']}.",
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Item Code: ${itemsList[index]['item_code']}",
//                                       style: const TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       "Item quantity: ${itemsList[index]['item_quantity']}",
//                                       style: const TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             trailing: SizedBox(
//                               width: 90,
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     child: IconButton(
//                                         icon: const Icon(
//                                           Icons.edit,
//                                           color: Colors.indigo,
//                                         ),
//                                         onPressed: () {
//                                           showDialog(
//                                               context: context,
//                                               builder: (context) {
//                                                 return AlertDialog(
//                                                   title: Text(
//                                                     'Edit quantity',
//                                                     style: GoogleFonts.urbanist(
//                                                         fontSize: 30,
//                                                         fontWeight:
//                                                             FontWeight.w800,
//                                                         color: Colors.black54),
//                                                   ),
//                                                   content: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         'Item Code:    ${itemsList[index]['item_code']}',
//                                                         style: GoogleFonts
//                                                             .urbanist(
//                                                                 fontSize: 15,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w800,
//                                                                 color: Colors
//                                                                     .black54),
//                                                       ),
//                                                       Text(
//                                                         'Item Quantity:    ${itemsList[index]['item_quantity']}',
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: GoogleFonts
//                                                             .urbanist(
//                                                                 fontSize: 15,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w800,
//                                                                 color: Colors
//                                                                     .black54),
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Text(
//                                                             "Last added quantity : ",
//                                                             style: GoogleFonts
//                                                                 .urbanist(
//                                                                     fontSize:
//                                                                         15,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w800,
//                                                                     color: Colors
//                                                                         .black54),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 60,
//                                                             width: 30,
//                                                             child: TextField(
//                                                               controller:
//                                                                   qtyController,
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                               keyboardType:
//                                                                   TextInputType
//                                                                       .number,
//                                                               cursorColor: Theme
//                                                                       .of(context)
//                                                                   .primaryColorDark,
//                                                               decoration:
//                                                                   InputDecoration(
//                                                                 // border:
//                                                                 //     OutlineInputBorder(),
//                                                                 counterText:
//                                                                     ' ',
//                                                                 hintText:
//                                                                     " ${itemsList[index]['item_quantity']}",
//                                                                 hintStyle: GoogleFonts
//                                                                     .urbanist(
//                                                                         color: Colors
//                                                                             .black),
//                                                               ),
//                                                               /*// onChanged:
//                                                               //     (value) {
//                                                               //   //focus scope next and previous use for control the controller movement.
//                                                               //   if (value
//                                                               //           .length ==
//                                                               //       1) {
//                                                               //     FocusScope.of(
//                                                               //             context)
//                                                               //         .nextFocus();
//                                                               //   } else if (value
//                                                               //       .isEmpty) {
//                                                               //     FocusScope.of(
//                                                               //             context)
//                                                               //         .previousFocus();
//                                                               //   }
//                                                               // },*/
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   actions: [
//                                                     TextButton(
//                                                       style:
//                                                           TextButton.styleFrom(
//                                                         backgroundColor:
//                                                             Colors.amberAccent,
//                                                       ),
//                                                       onPressed: () async {
//                                                         updateUser(
//                                                             itemsList[index]
//                                                                 ['id']);
//                                                         getItemsList();
//                                                         Navigator.pop(context);
//                                                         qtyController.clear();
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(
//                                                                 const SnackBar(
//                                                           content: Text(
//                                                               'Successfully updated item!'),
//                                                         ));
//                                                       },
//                                                       child: Text(
//                                                         "Update",
//                                                         style: GoogleFonts
//                                                             .urbanist(
//                                                           color: Colors.black,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                   scrollable: true,
//                                                 );
//                                               });
//                                         }),
//                                   ),
//                                   const SizedBox(
//                                     width: 5,
//                                   ),
//                                   Container(
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     child: Center(
//                                       child: IconButton(
//                                         icon: const Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                         ),
//                                         onPressed: () {
//                                           deleteUser(itemsList[index]['id']);
//                                           getItemsList();
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                             content: Text(
//                                                 'Successfully deleted item!'),
//                                           ));
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )),
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   int? id;
//   String? itemCode;
//   TextEditingController qtyController = TextEditingController();
//   //database all functions
// /*  Future<void> addNewUser() async {
//     await ItemsRepo.createUser(_lastCode.toString(), 1.toString());
//   }*/
//   Future<void> addNewUser() async {
//     await ItemsRepo.createUser(_lastCode.toString(), 1.toString());
//   }
//
//   Future<void> updateUser(id) async {
//     await ItemsRepo.updateUser(id, qtyController.text);
//   }
//
//   void deleteUser(id) async {
//     await ItemsRepo.deleteUser(id);
//   }
//
//   bool isPosted = false;
//   Future saveToMysqlWith() async {
//     setState(() {
//       isPosted = true;
//       var time = DateTime.now();
//       print("Before posted data $time");
//     });
//     for (var i = 0; i < itemsList.length; i++) {
//       var data = jsonEncode(<String, dynamic>{
//         "item_code": itemsList[i]['item_code'],
//         "item_quantity": itemsList[i]['item_quantity'],
//         // "created_at": itemsList[i]['created_at'],
//       });
//       final response = await http.post(
//           Uri.parse("http://172.20.20.69/sina/unistock/upload.php"),
//           body: data);
//       if (response.statusCode == 200) {
//         print(data);
//         print("Saving Data ");
//       } else {
//         print(response.statusCode);
//       }
//     }
//     ItemsRepo.dropTable();
//     setState(() {
//       isPosted = true;
//       var time1 = DateTime.now();
//       print("After posted data $time1");
//       itemsList = [];
//       getItemsList();
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Successfully uploaded items!'),
//       ));
//     });
//   }
// }
