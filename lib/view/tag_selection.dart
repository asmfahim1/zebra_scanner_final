import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/tag_controller.dart';
import 'package:zebra_scanner_final/view/online_mode_screen.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:get/get.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({Key? key}) : super(key: key);

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  TagController tagController = Get.put(TagController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ReusableAppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            iconSize: 30,
          ),
          color: Colors.white,
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
              child: ListView.builder(
                  itemCount: tagController.tagList.length,
                  itemBuilder: (context, index) {
                    if (tagController.tagList.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Product Added.",
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      );
                    } else {
                      if (tagController.isLoading.value) {
                        return const Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container(
                          height: 170,
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
                                          "Open Tags : ${tagController.tagList[index].xtagnum}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          "User Id :  ${tagController.tagList[index].zauserid}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "Store Id :  ${tagController.tagList[index].xwh}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "Tag Status :  ${tagController.tagList[index].xstatustag}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
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
                                            "Date : ${tagController.tagList[index].datecom}",
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
                                          Get.to(() => OnlineMode(
                                                userId: tagController
                                                    .tagList[index].zauserid,
                                                tagId: tagController
                                                    .tagList[index].xtagnum,
                                                storeId: tagController
                                                    .tagList[index].xwh,
                                              ));
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Go",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  size: 20,
                                                ),
                                              ],
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
      ),
    );
  }
}
