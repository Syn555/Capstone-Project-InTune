import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:xml/xml.dart';
import 'package:capstone_project_intune/musicXML/parser.dart';
import 'package:capstone_project_intune/musicXML/data.dart';
import 'package:capstone_project_intune/notes/music-line.dart';
import 'package:capstone_project_intune/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'com.google.firebase.storage.ktx.component1';


class CloudFilePicker extends StatelessWidget {
  const CloudFilePicker({Key? key}) : super(key: key);
// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ListView.builder",
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        // home : new ListViewBuilder(),  NO Need To Use Unnecessary New Keyword
        home: ListViewBuilder());
  }
}

class ListViewBuilder extends StatelessWidget {
   ListViewBuilder({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance; // Get instance of Firebase Auth
  final storageRef = FirebaseStorage.instance.ref(); // Get instance of Firebase Storage

  getFilesFromStorage() async
   {
      final user = auth.currentUser;
      var fileList = [];
      // var _value = Future<List>;

      if (user == null){return fileList;}
      else
        {
          final userID = user.uid; // Get UserID which is folder name
          final fileRef = storageRef.child(userID); // get folder
          var futureList = await fileRef.listAll(); // list all files under user

          if (futureList.items.isEmpty){return fileList;}
          else {
            for (var item in futureList.items)
              {
                fileList.add(item);
              }
            // fileList.add(futureList);
            return fileList;
          }
        }
   }
/*
   Widget filesWidget(){
    var filesLists = getFilesFromStorage();

     return FutureBuilder<List>(
       future: getFilesFromStorage(),
       builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) { return Center(child: CircularProgressIndicator()); }
          else { return Container( child: ListView.builder(
              itemCount: snapshot.data!,
              itemBuilder: (context, index)
              {
                return Text('${filesLists[index].title}');
              }
            )
          );
          }
       }
     );

   }
*/
  @override
  Widget build(BuildContext context) {

    var filesLists = getFilesFromStorage();

      return Scaffold(
        appBar: AppBar(title: const Text("No User Current")),
        body: FutureBuilder(
            future: getFilesFromStorage(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) { return Center(child: CircularProgressIndicator()); }
              else { return Container( child: ListView.builder(
                  itemCount: snapshot.data!,
                  itemBuilder: (context, index)
                  {
                    return Text('${filesLists[index].title}');
                  }
              )
              );
              }
            }
          )
        );
    }
  }

