import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:capstone_project_intune/main.dart';
import 'package:capstone_project_intune/Helpers/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class on_change_practice extends StatefulWidget {
  const on_change_practice({super.key});

  @override
  _on_change_practiceState createState() =>  _on_change_practiceState();
}

class _on_change_practiceState extends State<on_change_practice> {
  final recorder = FlutterSoundRecorder();
  // FlutterSoundRecorder _recorderSession;
  String roomID = "";
  String pathToAudio = "";


  // FIGURE OUT SUPER CLASS BS UPDATE: FIGURED IT OUT YAY
  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  FirebaseFirestore database = FirebaseFirestore.instance; // Instance of DB
  FirebaseAuth auth = FirebaseAuth.instance; // Instance of Auth
  final storageRef = FirebaseStorage.instance.ref(); // Create a reference of storage

  final controller = TextEditingController();

  FlutterFFmpeg _ffMpeg = FlutterFFmpeg();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Virtual Band-ish'),
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Text(
              "Room ID: $roomID",
              style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 2
              ),
            ),
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
                                onPressed: joinRoom,
                                child: const Text("Join")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Start",
                                backgroundColor: Colors.green,
                                splashColor: Colors.blueGrey,
                                onPressed: switchOn,
                                // onPressed: startRecording, // switch back to switchOn after testing
                                child: const Text("Start")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Stop",
                                backgroundColor: Colors.red,
                                splashColor: Colors.blueGrey,
                                onPressed: switchOff,
                                // onPressed: stopRecording, // switch back to switchOff after testing
                                child: const Text("Stop")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Merge",
                                backgroundColor: Colors.red,
                                splashColor: Colors.blueGrey,
                                onPressed: mergeAudios,
                                child: const Text("Merge")))),
                  ],
                )
            )],
          )
      ),
    );
  }

  // "Create" Room, add Room and User to DB
  void createRoom() async {
    final user = auth.currentUser; // get current user

    roomID = generateRandomString(8);
    setState(() {
      roomID = roomID;
    });

    if (user == null) {
      print("FirebaseAuth Error, create_room.dart, line 125: Mo current user");
    }
    else {
      // Create entry in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID);

      // Write data into that entry
      await roomRef.set({"status": false}); // set
      final subCollection = roomRef.collection("users").doc(user.uid);
      await subCollection.set({
        "audio": "audioRef",
        "timestamp": 0
      });
      onChange();
    }
  }

  // "Join" Room, add User to Room in DB
  void joinRoom() async {
    final user = auth.currentUser; // get current user
    roomID = controller.text; //User inputs Room ID to join a room

    if (user == null) {
      print ("FirebaseAuth Error, create_room.dart, line 125: No current user");
    }
    else{
      // Create entry in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID);

      // Write data into that entry
      final subCollection = roomRef.collection("users").doc(user.uid);

      //TEMP placeholder
      await subCollection.set({
        "audio": "audioRef1",
        "timestamp": 1
      });
      onChange();
    }
  }

  // To be called in body of database listener
  void startRecording() async {
    // switchOn(); //Set synced db field to true
    // await recorder.startRecorder(toFile: roomID, codec: Codec.aacMP4); // Starts recording to temporary file on device called the current roomID
    // await recorder.startRecorder(toFile: "tempAudio", codec: Codec.defaultCodec);
    await recorder.startRecorder(toFile: "$roomID.mp4", codec: Codec.defaultCodec);
    // ***** REPLACE ABOVE LINE OF CODE WITH THIS WHEN TESTING IS COMPLETE *****
    // await recorder.startRecorder(toFile: roomID, codec: Codec.defaultCodec);
  }

  // To be called in body of database listener
  // Recording Functionality has been commented out
  void stopRecording() async {
    final path = await recorder.stopRecorder(); // Returns URL of recorded audio? Can this be used instead of following code? to find out
    print("recorded audio URL is: $path");

    /*
    // Gets tempstorage/audioFile
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    // final audioPath = "$tempPath/$roomID";
    final audioPath = "$tempPath/tempAudio.mp4";
    print("tempPath is: $tempPath");
    print("filePath is $audioPath");

     */

    final audioFile = File(path!);

    // final audioFile = File(path!);
    final user = auth.currentUser; // get current user

    if (user == null) { print("No User Currently"); } // null safety for user
    else {
      final userID = user.uid;

      // This uploads the file to Firebase Storage
      // The path to file is audioFiles/userId/fileName
      // filesRef.child(userID).child(fileName).putFile(fileForFirebase);
      final filesRef = storageRef.child("AudioFiles");
      final userStorage = filesRef.child(userID);
      userStorage.child("${userID}_$roomID.mp4").putFile(audioFile);



      final audioRef = userStorage.child("${userID}_$roomID.mp4"); // Make this shit a variable
      final fileURL = audioRef.fullPath;

      final roomRef = database.collection("rooms").doc(roomID);

      final subCollection = roomRef.collection("users").doc(user.uid);
      await subCollection.update({"audio": fileURL,});


    }
    // switchOff();
  }

  // Initialize microphone
  Future initRecorder() async {
    // pathToAudio = '/sdcard/Download/$roomID.wav'; // path that audio will be saved in
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      {
        throw 'Microphone Permission Not Granted';
      }
    await recorder.openRecorder();
  }

  @override
  void dispose()
  {
    recorder.closeRecorder();
    super.dispose();
  }

  // Changes boolean "recording" in database to on
  void switchOn() async {
    final user = auth.currentUser; // get current user

    if (user == null) {
      print("FirebaseAuth Error, create_room.dart, line 244: Mo current user");
    }
    else {
      // Create ref entry point in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID);

      // Set recording boolean to recording
      await roomRef.update({"status": true}); // update
    }
  }

  // Change boolean "recording" in database to off
  void switchOff() async {
    final user = auth.currentUser; // get current user

    if (user == null) {
      print("FirebaseAuth Error, create_room.dart, line 125: Mo current user");
    }
    else {
      // Create ref entry point in rooms of named after roomId
      final roomRef = database.collection("rooms").doc(roomID); // rooms/${roomID} ?

      // Set recording boolean to not recording
      await roomRef.update({"status": false}); // update
    }
  }

  // CALL START AND STOP RECORDING HERE
  void onChange() async{
    final roomRef = database.collection("rooms").doc(roomID);
    roomRef.snapshots().listen(
            (event) => {
                if(event.data()?.values.first == true)
                  {
                    startRecording(),
                    print ("Recording is Starting")
                  }
                else if (event.data()?.values.first == false)
                  {
                    stopRecording(),
                    print ("Recording is Ending")
                  }

                // print("current data: ${event.data()}")
            },
        onError: (error) => print("Listen failed: $error")
    );
  }

  void mergeAudios() async
  {
    // Step 1: Access Users in Room in Database
    final usersRef = database.collection("rooms").doc(roomID).collection("users"); // Access the collection of users within room
    //print(usersRef.path);
    final filesRef = storageRef.child("AudioFiles");
    final user = auth.currentUser; // get current user

    final snapshot = await usersRef.get();
    List<DocumentSnapshot> tempList = snapshot.docs;
    List<String> roomUsers = []; // Names of Users
    List<String> paths = [];
    List<Reference> audioRefList = []; // Each file reference to be downloaded
    List<String> localPaths = []; // ONCE DOWNLOADED, ADD EACH LOCAL FILE PATH TO THIS LIST

    for (var value in tempList) {
      roomUsers.add(value.id);
    }

    // Step 2: Get file paths and handle (?)

    String ffmpegExec = "";
    for (var name in roomUsers)
    {
        audioRefList.add(filesRef.child(name).child("${name}_$roomID.mp4"));
        print("audioRefList added a reference");
    }

    // final appDocDir = await getApplicationDocumentsDirectory().path;
    final downloadDir = "/storage/emulated/0/Download";
    print("Application Documents Directory: ${downloadDir}");

    String filePath = "";

    // in this, for each, download file and then get local storage path, add to localPaths
    if (await Permission.manageExternalStorage.request().isGranted) {
      for (var pathName in audioRefList) {
        // for (var userName in roomUsers) {
          String fileUserName = pathName.name;
          filePath = '${downloadDir}/$fileUserName';
          print("localPaths adding: $filePath");
          localPaths.add(filePath);

          final localFile = File(filePath);
          final downloadTask = pathName.writeToFile(localFile);
        // }
      }
    }

    processAudio(localPaths);
  }

  void processAudio(List<String> paths)
  {
    String ffmpegExec = "";
    for(var name in paths)
    {
      ffmpegExec += "-i $name ";

      File testFile = File(name);
      while(!testFile.existsSync())
      {
        print("file $name: doesn't exist");
      }
      print("file $name: exists.");
    }

    ffmpegExec += "-filter_complex amix=inputs=2:duration=first:dropout_transition=3 /storage/emulated/0/Download/mixed_$roomID.mp4";

    print("ffmpeg command is: $ffmpegExec");

      _ffMpeg.execute(ffmpegExec).then((return_code) => print("Return code $return_code"));
  }
} // EOF
