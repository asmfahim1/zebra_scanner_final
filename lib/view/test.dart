// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:zebra_scanner_final/view/test_screen_2.dart';
//
// class TestScreen extends StatefulWidget {
//   const TestScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }
//
// class _TestScreenState extends State<TestScreen> {
//   double currentSliderValue = 80;
//   String? _sliderStatus;
//   bool active = false;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Test'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           // Display the current slider value.
//           _profileCompleteWidget(completionValue: currentSliderValue),
//           const SizedBox(height: 20,),
//           _subscriptionWidget(),
//           const SizedBox(height: 20,),
//           _notificationWithBadgeWidget(),
//           const SizedBox(height: 20,),
//           _languageSwitchWidget(),
//           const SizedBox(height: 20,),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 active = !active;
//               });
//             },
//             child: Container(
//               width: size.width * 0.25,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: Colors.blue,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: 35,
//                       height: 20,
//                       decoration: BoxDecoration(
//                           borderRadius:
//                           BorderRadius.circular(50),
//                           color: active
//                               ? Colors.white
//                               : Colors.blue),
//                       child: Center(
//                           child: Text(
//                             'Bn',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: active
//                                     ? Colors.black
//                                     : Colors.white),
//                           )),
//                     ),
//                     Container(
//                       width: 35,
//                       height: 20,
//                       decoration: BoxDecoration(
//                           borderRadius:
//                           BorderRadius.circular(50),
//                           color: active
//                               ? Colors.blue
//                               : Colors.white),
//                       child: Center(
//                           child: Text(
//                             'Eng',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: active
//                                     ? Colors.white
//                                     : Colors.black),
//                           )),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   Widget _profileCompleteWidget({required double completionValue}) {
//     return SettingsTitleWidget(
//         title: 'Create Biodata',
//         trailingWidget: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('profile Completed'),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 20,
//                       width: 173,
//                       child: SliderTheme(
//                         data: SliderTheme.of(context).copyWith(
//                           trackHeight: 2,
//                           thumbColor: Colors.pinkAccent,
//                           overlayColor: Colors.transparent,
//                           thumbShape: SliderComponentShape.noThumb,
//                         ),
//                         child: Slider(
//                           min: 0.0,
//                           max: 100.0,
//                           value: completionValue,
//                           onChanged: (value) {},
//                         ),
//                       ),
//                     ),
//                     Text('${completionValue.round()}%'),
//                   ],
//                 ),
//               ],
//             )
//         ),
//     );
//   }
//
//   Widget _subscriptionWidget(){
//     return SettingsTitleWidget(
//       color: const Color(0xFF89CBD),
//       title: 'Subscription',
//     );
//   }
//
//   Widget _notificationWithBadgeWidget(){
//     return SizedBox(
//       height: 65,
//       width: double.maxFinite,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 35,
//             width: 173,
//             child: Center(
//               child: Badge(
//                 position: BadgePosition.topEnd(end: -15,top: -15),
//                 badgeStyle: BadgeStyle(
//                   badgeColor: Color(0XFFC37B54),
//                 ),
//                 badgeContent: Text(
//                   '2',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 child: Text("Notifications"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _languageSwitchWidget(){
//     return SettingsTitleWidget(
//         title: 'Language',
//         trailingWidget: FlutterSwitch(
//           height: 35,
//           width: 70,
//           value: active,
//           activeText: 'Bn',
//           activeTextColor: Colors.white,
//           inactiveText: 'Eng',
//           inactiveTextColor: Colors.white,
//           showOnOff: true,
//           toggleColor: Colors.blue,
//           onToggle: (bool value) { setState(() {
//           active = value;
//         }); },
//         )
//     );
//   }
// }
