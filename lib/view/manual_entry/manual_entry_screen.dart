import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import 'package:zebra_scanner_final/controller/online_controller.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:get/get.dart';

class ManualEntry extends StatefulWidget {
  String? mode;
  ManualEntry({
    this.mode,
    Key? key,
  }) : super(key: key);

  @override
  State<ManualEntry> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  OnlineController online = Get.put(OnlineController());
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
      body: Column(
        children: [
          Container(
            height: 70,
            width: double.maxFinite,
            padding:
            const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
                left: 10, top: 10, right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: TextFormField(
              //controller: depositController.amount,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(r'^0')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'-')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'\.')),
                FilteringTextInputFormatter.deny(
                    RegExp(r',')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'\+')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'\*')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'/')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'=')),
                FilteringTextInputFormatter.deny(
                    RegExp(r'%')),
                FilteringTextInputFormatter.deny(
                    RegExp(r' ')),
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter product code',
              ),
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            height: 70,
            width: double.maxFinite,
            padding:
            const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
                left: 10, top: 10, right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: TextFormField(
              //controller: depositController.amount,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'^0')),
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
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0)),
            clipBehavior: Clip.hardEdge,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ConstantColors.uniGreen,
              ),
              onPressed: () {
                // make some logic to post data into server or local database
                if(widget.mode == 'online'){
                  //online logic
                }else{
                  //offline login
                }
              },
              child: Text('Submit', style: TextStyle(fontSize: 15),)
            ),
          ),
        ],
      ),
    );
  }
}