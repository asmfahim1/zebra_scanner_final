import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import '../../widgets/appBar_widget.dart';

class SupSelScreen extends StatefulWidget {
  String tag;
  String store;
  SupSelScreen({required this.tag, required this.store, Key? key}) : super(key: key);

  @override
  State<SupSelScreen> createState() => _SupSelScreenState();
}

class _SupSelScreenState extends State<SupSelScreen> {
  LoginController login = Get.find<LoginController>();
  OfflineController offline = Get.find<OfflineController>();
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    offline.listOfSuppliers(login.serverIp.value);
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
              name.clear();
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
                                  onPressed: () async{
                                    offline.saveData(widget.tag, widget.store, supplier.xcus);
                                    await offline.fetchMasterItemsList(context);
                                  },
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
