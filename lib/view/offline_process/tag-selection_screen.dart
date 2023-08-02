import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/view/offline_process/supplier_select_screen.dart';
import '../../controller/server_controller.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/const_colors.dart';

class OfflineTagScreen extends StatefulWidget {
  const OfflineTagScreen({Key? key}) : super(key: key);

  @override
  State<OfflineTagScreen> createState() => _OfflineTagScreenState();
}

class _OfflineTagScreenState extends State<OfflineTagScreen> {
  OfflineController offline = Get.put(OfflineController());
  ServerController serverController = Get.find<ServerController>();
  ConstantColors colors = ConstantColors();

  //need to call the tagList for first build
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    offline.listOfTags(serverController.ipAddress.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ReusableAppBar(
          elevation: 0,
          color: Colors.white,
          action: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.logout_sharp,
                color: ConstantColors.uniGreen,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Text(
            "List of Open Tag list",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Container(
              //wrap ListView with Obc() for state-management. So that the product will show at the time when the screen is built.
              margin: const EdgeInsets.only(left: 05, right: 05),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Obx(() {
                if (offline.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(
                            color: ConstantColors.comColor,
                          ),
                        ),
                        const Text('Loading...'),
                      ],
                    ),
                  );
                } else {
                  if (offline.offlineTags.isEmpty) {
                    return const Center(
                      child: Text("No tag list open for count"),
                    );
                  } else {
                    return GridView.builder(
                        itemCount: offline.offlineTags.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                            childAspectRatio: 1.22),
                        itemBuilder: (context, index) {
                          var openTags = offline.offlineTags[index];
                          return GestureDetector(
                              onTap: () {
                                Get.to(()=> SupSelScreen());
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      height: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2.6,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2.13,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        gradient: LinearGradient(
                                          stops: offline.stops,
                                          colors: [
                                            ConstantColors.comColor,
                                            ConstantColors.uniGreen,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        color:
                                        Colors.white.withOpacity(0.2)
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          openTags.xtagnum,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          openTags.xwh,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          openTags.date,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        });
                  }
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
