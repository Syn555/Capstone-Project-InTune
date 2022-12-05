import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:xml/xml.dart';
import 'package:capstone_project_intune/musicXML/parser.dart';
import 'package:capstone_project_intune/musicXML/data.dart';

import 'package:capstone_project_intune/main.dart';

const double STAFF_HEIGHT = 36;

class MyHomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Composition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false, //setup this property
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  //final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Future<Score> loadXML() async {
    //final Directory directory = await getApplicationDocumentsDirectory();

    /*final rawFile = everything.toString();
    print(everything);
    final document= XmlDocument.parse(rawFile);
    final result = parseMusicXML(document);
*/
    final rawFile = await mountainImagesRef.getDownloadURL();
    final result = parseMusicXML(XmlDocument.parse(rawFile));

    return result;
  }

  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var notePicked = "";
  var everything;
  var holder=""; //holds the notes for comp
  List<String> notesPlayed= [];
  List<String> notesToBeAdded= [];
  var noteStatus= "";
  var status = "Click on start";

  late final myFile;
  late final myFilePath;
  late final mountainImagesRef;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text('Composition'),
      ),
      body: Center(
          child: Column(children: [
            Center(
                child: Text(
                  holder,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold),
                )
              /*child: Container(
              alignment: Alignment.center,
              width: size.width - 40,
              height: size.height-500,
              child: FutureBuilder<Score>(
                  future: loadXML(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return MusicLine(
                        options: MusicLineOptions(
                          snapshot.data!,
                          STAFF_HEIGHT,
                          1,
                        ),
                      );
                    } else if(snapshot.hasError) {
                      return Text('Oh, this failed!\n${snapshot.error}');
                    } else {
                      return  const SizedBox(
                        width: 60,
                        height: 40,
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              ),
            ),*/
            ),
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Start",
                                backgroundColor: Colors.green,
                                splashColor: Colors.blueGrey,
                                onPressed: _startCapture,
                                child: const Text("Start")))),
                    Expanded(
                        child: Center(
                            child: FloatingActionButton(
                                heroTag: "Stop",
                                backgroundColor: Colors.red,
                                splashColor: Colors.blueGrey,
                                onPressed: _stopCapture,
                                child: const Text("Stop")))),
                    Expanded(child: Text(
                      status,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ))
                  ],
                ))
          ],
          )
      ),
    );
  }





  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      notesPlayed.clear();
      note = "";
      status = "Play something";
    });
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    //testing
    //notesToBeAdded= ['A','B','C'] ABC;

    //add data to clipboard
    await Clipboard.setData(ClipboardData(text:notesPlayed.join()));

    /*Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
// Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child(myFilePath);
    try {
      await mountainImagesRef.putFile(myFilePath);
      print("Upload Complete!");
    } on FirebaseException catch (e) {
      print("Upload Not Complete");
    }*/

    //open browser for music comp
    var url = Uri.parse('https://editor.drawthedots.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode:LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }

    setState(() {
      //update(notesToBeAdded);
      note = "";
      status = "Click on start";
    });


    //loadXML();


  }

  Future<void> listener(dynamic obj) async {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);
      status = handledPitchResult.tuningStatus.toString();

      holder= handledPitchResult.note;

      //for abc notation
      if(holder=="C#") {
        holder= "C^";
      }else if(holder=="D#"){
        holder= "D^";
      }else if(holder=="F#"){
        holder= "F^";
      }else if(holder=="G#"){
        holder= "G^";
      } else if(holder=="A#"){
        holder= "A^";
      } else if(holder=="B#"){
        holder= "B^";
      }else{
        holder= handledPitchResult.note;
      }

      //Updates the state with the result
      setState(() {
        // if (status == "TuningStatus.tuned")
        note = "";
        print("Actual pitchresult: $holder");
        //take all notes and add it to the notesPlayed List
        notesPlayed.add(holder);
        //print(holder);
      }
      );
    }

  }


  void onError(Object e) {
    print(e);
  }
}

