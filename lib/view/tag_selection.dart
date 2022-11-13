import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/tag_controller.dart';
import 'package:zebra_scanner_final/view/online_mode_screen.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/widgets/const_colors.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({Key? key}) : super(key: key);

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  TagController tagController = Get.put(TagController());
  ConstantColors colors = ConstantColors();

  //need to call the tagList for first build
  @override
  void initState() {
    // TODO: implement initState
    tagController.listOfTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double fillPercent = 52; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 95;
    final List<double> stops = [
      fillStop,
      fillStop,
    ];
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
                                  childAspectRatio: 1.2),
                          itemBuilder: (context, index) {
                            if (tagController.tagList.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No Product Added.",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
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
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  color: colors.comColor,
                                  elevation: 2,
                                  shadowColor: Colors.blueGrey,
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      gradient: LinearGradient(
                                        stops: stops,
                                        /*(for controlling Colors opacity)*/
                                        // colors: gradient,
                                        colors: [
                                          colors.comColor,
                                          colors.uniGreen,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${tagController.tagList[index].xtagnum}",
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          "${tagController.tagList[index].xwh}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${tagController.tagList[index].date}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
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

/*Row(
children: [
Expanded(
child: Container(
padding: EdgeInsets.only(
left: 10, top: 5),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
mainAxisAlignment:
MainAxisAlignment.spaceEvenly,
children: [
Text(
"${tagController.tagList[index].xtagnum}",
style: GoogleFonts.urbanist(
color: Colors.black,
fontWeight: FontWeight.w800,
),
),
Text(
"${tagController.tagList[index].zauserid}",
overflow:
TextOverflow.ellipsis,
style: GoogleFonts.urbanist(
color: Colors.black,
fontWeight: FontWeight.w400,
),
),
Text(
"${tagController.tagList[index].xwh}",
overflow:
TextOverflow.ellipsis,
style: GoogleFonts.urbanist(
color: Colors.black,
fontWeight: FontWeight.w400,
),
),
// Text(
//   "Tag Status :  ${tagController.tagList[index].xstatustag}",
//   style: GoogleFonts.urbanist(
//     color: Colors.black,
//     fontWeight: FontWeight.w400,
//   ),
// )
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
"Date : ${tagController.tagList[index].datecom}",
style: GoogleFonts.urbanist(
color: Colors.black,
fontSize: 12,
fontWeight:
FontWeight.w600,
),
),
*/ /*Text(
                                              "Time: ${onlineController.products[index].xitem}",
                                              style: GoogleFonts.urbanist(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),*/ /*
],
),
*/ /*GestureDetector(
                                                onTap: () {
                                                  Get.to(() => OnlineMode(
                                                        userId: tagController
                                                            .tagList[index]
                                                            .zauserid,
                                                        tagId: tagController
                                                            .tagList[index]
                                                            .xtagnum,
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
                                                          BorderRadius.circular(
                                                              10.0)),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Go",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
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
                                              )*/ /*
],
),
)
],
),*/
