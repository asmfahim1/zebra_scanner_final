import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/controller/tag_controller.dart';
import 'package:zebra_scanner_final/view/online_process/online_mode_screen.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:get/get.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({Key? key}) : super(key: key);

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  LoginController login = Get.find<LoginController>();
  TagController tagController = Get.put(TagController());
  ConstantColors colors = ConstantColors();

  //need to call the tagList for first build
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tagController.listOfTags(login.serverIp.value);
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
                if (tagController.isLoading.value) {
                  return Center(
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
                                        tagNum: tagController.tagList[index].xtagnum,
                                        storeId: tagController.tagList[index].xwh,
                                        userId: tagController.tagList[index].zauserid,
                                        outlet: tagController.tagList[index].xwh,
                                      )
                                  );
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
                                            stops: tagController.stops,
                                            colors: [
                                              ConstantColors.comColor,
                                              ConstantColors.uniGreen,
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
                                          color:
                                              Colors.white.withOpacity(0.2)
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            tagController
                                                .tagList[index].xwh,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            tagController
                                                .tagList[index].date,
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
                          }
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

/*
onWillPop: () async {
final shouldPop = await tagController.showWarningContext(context);
return shouldPop ?? true;
},*/
