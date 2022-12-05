// //import 'package:capstone_project_intune/Helpers/text_styles.dart';
// import 'package:capstone_project_intune/Helpers/utils.dart';
// import 'package:capstone_project_intune/video_call.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class CreateRoom extends StatefulWidget {
//   @override
//   _CreateRoomState createState() => _CreateRoomState();
// }
//
// class _CreateRoomState extends State<CreateRoom> {
//   String roomId = "";
//   @override
//   void initState() {
//     roomId = generateRandomString(8);
//     super.initState();
//   }
//
//   FirebaseDatabase database = FirebaseDatabase.instance; // Instance of DB
//   FirebaseAuth auth = FirebaseAuth.instance; // Instance of Auth
//   // DatabaseReference ref = database.instance.ref();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       title: Text("Room Created"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Room ID : $roomId",
//             style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               FloatingActionButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6)),
//                 //color: const Color(0xFF1A1E78),
//                 onPressed: () {
//                   shareToApps(roomId);
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.share, color: Colors.white),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       "Share",
//                         style: const TextStyle(
//                         color: Colors.black87,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               FloatingActionButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6)),
//                 //color: const Color(0xFF1A1E78),
//                 onPressed: () async {
//                   bool isPermissionGranted =
//                   await handlePermissionsForCall(context);
//                   if (isPermissionGranted) { // START CALL
//                     addSessionAndUserToDatabase(roomId); // Add Room and User to Firebase Database
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => VideoCallScreen(
//                               channelName: roomId,
//                             )));
//                   } else {
//                     Get.snackbar("Failed",
//                         "Microphone Permission Required for Video Call.",
//                         backgroundColor: Colors.white,
//                         colorText: Color(0xFF1A1E78),
//                         snackPosition: SnackPosition.BOTTOM);
//                   }
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.arrow_forward, color: Colors.white),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       "Join",
//                           style: const TextStyle(
//                           color: Colors.black87,
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Add Session and User into Database
//   void addSessionAndUserToDatabase(String roomID) async
//   {
//       // DatabaseReference db = database.ref(); // get reference to read and write
//       final user = auth.currentUser; // get current user
//       final userID;
//
//       if (user == null)
//       {
//         print ("FirebaseAuth Error, create_room.dart, line 125: Mo current user");
//       }
//       else
//       {
//         userID = user.uid; // get User ID of current user
//
//         // Create entry in rooms of named after roomId
//         final roomRef = database.ref("rooms/$roomId"); // rooms/${roomID} ?
//
//         // Write data into that entry
//         await roomRef.set({
//           "user_$userID":{ // add field for user
//             "uid" : userID // save userID, might be redundant, probably is
//           },
//           "status":{
//             "recording" : false // Set recording boolean to not recording
//           }
//         }); // set
//       }
//   } // addSessionAndUserToDatabase
//
//
//
//
// }