// import 'package:capstone_project_intune/ui/rooms/create_room.dart';
// import 'package:capstone_project_intune/ui/rooms/join_room.dart';
// import 'package:flutter/material.dart';
// //import 'package:capstone_project_intune/Helpers/text_styles.dart';
// import 'package:get/get.dart';
//
// class live_band extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1E78),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 60, left: 30),
//             padding: const EdgeInsets.only(
//               right: 20,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Live Band",
//                   style:const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(
//                 top: 30,
//               ),
//               padding: const EdgeInsets.only(
//                 top: 30,
//               ),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25))),
//               child: Center(
//                   child: Column(
//                     children: [
//                       Flexible(
//                         flex: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 10),
//                           child: FloatingActionButton(
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (_) {
//                                     return CreateRoom();
//                                   });
//                             },
//                             child: Row(
//                               children: [
//                                 Flexible(
//                                   flex: 4,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         "Create Room",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         "Create a room and ask others to join the same.",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Flexible(
//                         flex: 2,
//                         child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 2,
//                             margin: const EdgeInsets.all(20),
//                             color: const Color(0xFF1A1E78)),
//                       ),
//                       Flexible(
//                         flex: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 10),
//                           child: FloatingActionButton(
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (_) {
//                                     return JoinRoom();
//                                   });
//                             },
//                             child: Row(
//                               children: [
//                                 Flexible(
//                                   flex: 4,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         "Join Room",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         "Join a room created by your friend.",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }