import 'package:capstone_project_intune/ui/rooms/create_room.dart';
import 'package:capstone_project_intune/ui/rooms/join_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
// import 'package:capstone_project_intune/Helpers/text_styles.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:capstone_project_intune/main.dart';
import 'package:capstone_project_intune/Helpers/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class on_change_practice extends StatefulWidget
{
  @override
  _on_change_practiceState createState() =>  _on_change_practiceState();
}



class _on_change_practiceState extends State<on_change_practice>
{

  final recorder = FlutterSoundRecorder();

  String roomID = "";

  // FIGURE OUT SUPER CLASS BS
  @override
  void initState() {
    roomID = generateRandomString(8);

    initRecorder();
    super.initState();
  }

  FirebaseFirestore database = FirebaseFirestore.instance; // Instance of DB
  FirebaseAuth auth = FirebaseAuth.instance; // Instance of Auth
  final storage = FirebaseStorage.instance; // Create instance of Firebase Storage
  final storageRef = FirebaseStorage.instance.ref(); // Create a reference of storage

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // roomID = generateRandomString(8);


    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Sync Testing'),
      ),
      body: Center(
          child: Column(children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            const Text(
              "Enter Room ID to Join:",
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 2
              ),
            ),
            TextField(controller: controller),
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Create",
                                backgroundColor: Colors.blue,
                                splashColor: Colors.white,
                                onPressed: createRoom,
                                child: const Text("Create")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Join",
                                backgroundColor: Colors.blue,
                                splashColor: Colors.white,
                                onPressed: joinRoom, // _pickFile method
                                child: const Text("Join")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Start",
                                backgroundColor: Colors.green,
                                splashColor: Colors.blueGrey,
                                onPressed: switchOn,
                                child: const Text("Start")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Stop",
                                backgroundColor: Colors.red,
                                splashColor: Colors.blueGrey,
                                onPressed: stopRecording,
                                child: const Text("Stop")))),
                  ],
                ))
          ],
          )
      ),
    );

  }

  // "Create" Room, add Room and User to DB
  void createRoom() async
  {
    final user = auth.currentUser; // get current user
    final userID;

    // roomID = generateRandomString(8);

    if (user == null)
    {
      print("FirebaseAuth Error, create_room.dart, line 125: Mo current user");
    }
    else
    {
      userID = user.uid; // get User ID of current user

      // Create entry in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID);//ref("rooms/$roomID"); // rooms/${roomID} ?

      // Write data into that entry
      await roomRef.set({"status": false}); // set
      final subCollection = roomRef.collection("users").doc(userID);
      await subCollection.set({
        "audio": "audioRef",
        "timestamp": 0
      });
      // "user_$userID":{ // add field for user
      //"uid" : userID // save userID, might be redundant, probably is
    }
  }

  // "Join" Room, add User to Room in DB
  void joinRoom() async
  {
    // DatabaseReference db = database.ref(); // get reference to read and write
    final user = auth.currentUser; // get current user
    final userID;
    final rID = controller.text;


    if (user == null)
    {
      print ("FirebaseAuth Error, create_room.dart, line 125: No current user");
    }
    else
    {
      userID = user.uid; // get User ID of current user

      // Create entry in rooms of named after roomId
      //final roomRef = database.ref("rooms/$rID"); // rooms/${rID} ?
      final roomRef = database.collection("rooms").doc(rID);//ref("rooms/$roomID"); // rooms/${roomID} ?

      // Write data into that entry
      final subCollection = roomRef.collection("users").doc(userID);
      await subCollection.set({
        "audio": "audioRef1",
        "timestamp": 1
      });
    }
  }

  // To be called in body of database listener
  void startRecording() async
  {
    await recorder.startRecorder(toFile: roomID);
  }

  // To be called in body of database listener
  // Recording Functionality has been commented out
  void stopRecording() async
  {
    // final path = await recorder.stopRecorder();
    // final audioFile = File(path!);
    final user = auth.currentUser; // get current user

    if (user == null) { print("No User Currently"); } // null safety for user
    else
    {
      final userID = user.uid; // get user ID

      // This uploads the file to Firebase Storage
      // The path to file is MusicXMLFiles/userId/fileName
      // filesRef.child(userID).child(fileName).putFile(fileForFirebase);
      final filesRef = storageRef.child("audioFiles");
      final wayfaringRef = filesRef.child("Wayfaring Stranger Cover.mp3"); // Make this shit a variable
      final fileURL = wayfaringRef.fullPath;

      // also make this shit a variable (doc)
      final roomRef = database.collection("rooms").doc("RhhLSlPx");//ref("rooms/$roomID"); // rooms/${roomID}

      final subCollection = roomRef.collection("users").doc(userID);
      await subCollection.update({"audio": fileURL,});


      // final fileURL = filesRef.child(fileName).fullPath;
    }

    // print('Recorded Audio @ path: $audioFile');
  }

  // Initialize microphone
  Future initRecorder() async
  {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted)
      {
        throw 'Microphone Permission Not Granted';
      }

    await recorder.openRecorder();
  }
/*
  @override
  void dispose() // ????? THIS IS WONKY WITH SUPER CLASSES OR SMTH IDK BROOOOO ?????????
  {
    recorder.closeRecorder();
    super.dispose();
  }
*/

  // Changes boolean "recording" in database to on
  void switchOn() async
  {
    final user = auth.currentUser; // get current user

    // roomID = generateRandomString(8);

    if (user == null)
    {
      print("FirebaseAuth Error, create_room.dart, line 244: Mo current user");
    }
    else
    {
// get User ID of current user

      // Create ref entry point in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID);

      // Write data into that entry
      await roomRef.update({
        "status": true // Set recording boolean to not recording
      }); // update
    }
  }

  // Change boolean "recording" in database to off
  void switchOff() async
  {
    final user = auth.currentUser; // get current user

    // roomID = generateRandomString(8);

    if (user == null)
    {
      print("FirebaseAuth Error, create_room.dart, line 125: Mo current user");
    }
    else
    {
// get User ID of current user

      // Create ref entry point in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID); // rooms/${roomID} ?

      // Write data into that entry
      await roomRef.update({
        "status":false // Set recording boolean to not recording
      }); // update
    }
  }
} // EOF
