import 'dart:typed_data';

import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:xml/xml.dart';
import 'package:capstone_project_intune/musicXML/parser.dart';
import 'package:capstone_project_intune/musicXML/data.dart';
//import 'package:capstone_project_intune/notes/music-line.dart';
import 'package:capstone_project_intune/main.dart';

import 'notes/music-line.dart';

var selectFileName = 'testsimple.musicxml';
var iterator = 0;
Iterable<XmlElement> selectNotes = <XmlElement>[];

Future<Score> loadXML() async {
  final rawFile = await rootBundle.loadString(selectFileName);
  final result = parseMusicXML(XmlDocument.parse(rawFile));

  selectNotes = XmlDocument.parse(rawFile).findAllElements('step');
  return result;
}
/*
String firstNote() {
  iterator = 0;
  var notexml = selectNotes.elementAt(iterator);
  var currentNote = notexml.toString();
  return currentNote.substring(6, 7);
} */

String loadNote() {
  if (iterator == selectNotes.length) {
    iterator = 0;
    return "File Done";
  }
  var notexml = selectNotes.elementAt(iterator);
  iterator += 1;
  var currentNote = notexml.toString();
  return currentNote.substring(6, 7);
}

const double staffHeight = 36;

class Practice extends StatefulWidget {
  const Practice({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Practice> createState() => _Practice();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intonation Practice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false, //setup this property
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _Practice createState() => _Practice();
}

//class _MyHomePageState extends State<MyHomePage> {
class _Practice extends State<Practice> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var notePicked = "EMPTY";
  var noteStatus = "";
  var status = "Click on start";

  @override
  Widget build(BuildContext context) {
    loadXML();

    //final size = MediaQuery
        //.of(context)
        //.size;

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Intonation Practice'),
      ),
      body: Center(
        child: Column(children: [
          const Spacer(
            flex: 1
          ),
          Center(
            child: Text(
              notePicked,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 50.0,
                fontWeight: FontWeight.bold),
              )
          ),
          const Spacer(
            flex: 1
          ),
          Center(
            child: Text(
              status,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
          ),
          const Spacer(
            flex: 1
          ),
          Center(
            child: Row( children: [
              Expanded(
                // child: Center(
                  child: FloatingActionButton(
                    heroTag: "Load",
                    backgroundColor: Colors.blue,
                    splashColor: Colors.blueGrey,
                    onPressed: (){
                      //loadxml();
                      notePicked = loadNote().toString();
                    },
                    child: const Text("Load")
                  )
                //)
              ),
              Expanded(
                // child: Center(
                  child: FloatingActionButton(
                    heroTag: "Start",
                    backgroundColor: Colors.green,
                    splashColor: Colors.blueGrey,
                    onPressed: _startCapture,
                    child: const Text("Start")
                  )
                //),
              ),
              Expanded(
                // child: Center(
                  child: FloatingActionButton(
                    heroTag: "Stop",
                    backgroundColor: Colors.red,
                    splashColor: Colors.blueGrey,
                    onPressed: _stopCapture,
                    child: const Text("Stop")
                  )
                //)
              )
            ])
          ),
        //])
      //)
          const Spacer(
            flex: 1
          ),

          Expanded(
            child: Center(
              /* alignment: Alignment.center,
              width: size.width - 30,
              height: size.height - 10, */
              child: FutureBuilder<Score>(
                future: loadXML(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      child: MusicLine(
                        options: MusicLineOptions(
                          snapshot.data!,
                          staffHeight,
                          1
                        )
                      )
                    );
                  } else if (snapshot.hasError) {
                    return Text('Oh, this failed!\n${snapshot.error}');
                  } else {
                    return const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              )
            )
          ),
          const Spacer(
            flex: 7
          )
        ])
      )
    );
  }

  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      note = "";
      status = "Play something";
    });
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      status = "Click on start";
    });
  }

  /* Future<void> _stopCaptureTuned() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      status = "Tuned!!!";
    });
  } */

  void listener(dynamic obj) {
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

      //Updates the state with the result
      setState(() {
        if(status == "TuningStatus.tuned"){
          status = "Tuned!!!".toUpperCase();
          //_stopCaptureTuned();
        }else if (status == "TuningStatus.toohigh" || status == "TuningStatus.waytoohigh"){
          status = "Too high, please tune lower";
        }else if( status == "TuningStatus.toolow" || status ==  "TuningStatus.waytoolow"){
          status = "Too low, please tune higher";
        }else if (status =="TuningStatus.undefined"){
          status= "Unknown Pitch. Please try again!";
        }
      });
    }
  }

  void onError(Object e) {
    //print(e);
  }
}