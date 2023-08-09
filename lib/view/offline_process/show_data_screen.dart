import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import '../../constants/const_colors.dart';
import '../../widgets/appBar_widget.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({Key? key}) : super(key: key);

  @override
  State<ShowDataScreen> createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  OfflineController offline = Get.find<OfflineController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    offline.getAll();
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
      body: Obx((){
        return offline.got.value
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
                  Text(
                    "All Fetched Data",
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Container(
                    child: offline.getAllData.isEmpty
                        ? const Center(
                            child: Text("No Data Loaded"),
                          )
                        : ListView.builder(
                            itemCount: offline.getAllData.length,
                            itemBuilder: (context, index) {
                              var masterData = offline.getAllData[index];
                              return  Container(
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
                                            left: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text('${masterData["xitem"]}',
                                                style: GoogleFonts.urbanist(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text('${masterData["xdesc"]}',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text('${masterData["tag_no"]}',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                  ),
                ],
              );
      }),
    );
  }
}


