import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

import '../../controller/server_controller.dart';
import '../../widgets/appBar_widget.dart';

class SupSelScreen extends StatefulWidget {
  const SupSelScreen({Key? key}) : super(key: key);

  @override
  State<SupSelScreen> createState() => _SupSelScreenState();
}

class _SupSelScreenState extends State<SupSelScreen> {
  OfflineController offline = Get.find<OfflineController>();
  ServerController serverController = Get.find<ServerController>();
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    offline.listOfSuppliers(serverController.ipAddress.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ReusableAppBar(
          elevation: 0,
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Obx((){
          return offline.isSupLoaded.value
              ? Center(
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
                )
              : Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                          hintText: 'Search by name',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
                          onChanged: (value) => offline.search(value),
                    ),
                    Obx((){
                      return offline.filteredSupList.isEmpty
                          ? const Center(
                              child: Text("No tag list open for count"),
                            )
                          : Expanded(
                        child: ListView.builder(
                          itemCount: offline.filteredSupList.length,
                          itemBuilder: (context, index){
                            var supplier = offline.filteredSupList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: Container(
                                height: 60,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: ConstantColors.uniGreen1,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0,
                                          1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.white,),
                                  onPressed: (){},
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(supplier.xcus),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    })
                  ],
                );
        }),
      ),
    );
  }
}