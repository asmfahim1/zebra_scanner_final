import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/tag_controller.dart';
import 'package:zebra_scanner_final/view/online_mode_screen.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

import '../controller/server_controller.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({Key? key}) : super(key: key);

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  TagController tagController = Get.put(TagController());
  ServerController serverController = Get.put(ServerController());
  ConstantColors colors = ConstantColors();

  //need to call the tagList for first build
  @override
  void initState() {
    // TODO: implement initState
    tagController.listOfTags(serverController.ipAddress.value.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ReusableAppBar(
          elevation: 0,
          /*leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black, size: 30,),

          ),*/
          color: Colors.white,
          action: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.logout_sharp,
                color: colors.uniGreen,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              "List of Open Tag list",
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: Container(
                //wrap ListView with Obc() for state-management. So that the product will show at the time when the screen is built.
                margin: const EdgeInsets.only(left: 05, right: 05),
                child: Obx(() {
                  if (tagController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colors.comColor,
                      ),
                    );
                  } else {
                    if (tagController.tagList.isEmpty) {
                      return const Center(
                        child: Text("No tag list open for count"),
                      );
                    } else {
                      return GridView.builder(
                          itemCount: tagController.tagList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0,
                                  childAspectRatio: 1.22),
                          itemBuilder: (context, index) {
                            if (tagController.tagList.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No Product Added.",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 50),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    Get.to(() => OnlineMode(
                                          tagNum: tagController
                                              .tagList[index].xtagnum,
                                          storeId:
                                              tagController.tagList[index].xwh,
                                          userId: tagController
                                              .tagList[index].zauserid,
                                          outlet:
                                              tagController.tagList[index].xwh,
                                          adminId:
                                              tagController.tagList[index].zaip,
                                        ));
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                          height: 125,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            gradient: LinearGradient(
                                              stops: tagController.stops,
                                              colors: [
                                                colors.comColor,
                                                colors.uniGreen,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          )),
                                      Container(
                                        /*height: 118,
                                        width: 142,*/
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.white.withOpacity(0.2)
                                            /*color: Colors.transparent
                                              .withOpacity(0.2),*/
                                            ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              tagController
                                                  .tagList[index].xtagnum,
                                              style: GoogleFonts.urbanist(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              tagController.tagList[index].xwh,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.urbanist(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              tagController.tagList[index].date,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.urbanist(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ));
                            }
                          });
                    }
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
