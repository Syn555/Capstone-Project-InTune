//import 'package:capstone_project_intune/Helpers/text_styles.dart';
import 'package:capstone_project_intune/Helpers/utils.dart';
import 'package:capstone_project_intune/ui/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  String roomId = "";
  @override
  void initState() {
    roomId = generateRandomString(8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Room Created"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Room ID : " + roomId,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                //color: const Color(0xFF1A1E78),
                onPressed: () {
                  shareToApps(roomId);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Share",
                        style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                //color: const Color(0xFF1A1E78),
                onPressed: () async {
                  bool isPermissionGranted =
                  await handlePermissionsForCall(context);
                  if (isPermissionGranted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoCallScreen(
                              channelName: roomId,
                            )));
                  } else {
                    Get.snackbar("Failed",
                        "Microphone Permission Required for Video Call.",
                        backgroundColor: Colors.white,
                        colorText: Color(0xFF1A1E78),
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Join",
                          style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}