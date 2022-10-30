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
import 'package:capstone_project_intune/notes/music-line.dart';
import 'package:capstone_project_intune/main.dart';

var selectFileName = 'hanon-no1.musicxml';
var iterator = 0;
Iterable<XmlElement> selectNotes = <XmlElement>[];

Future<Score> loadXML() async {
  final rawFile = await rootBundle.loadString('hanon-no1.musicxml');
  final result = parseMusicXML(XmlDocument.parse(rawFile));

  selectNotes = XmlDocument.parse(rawFile).findAllElements('step');
  return result;
}

String loadNote() {
  var currentNote = selectNotes.elementAt(iterator);
  iterator += 1;
  return currentNote.toString();
}

const double STAFF_HEIGHT = 24;


class Practice extends StatelessWidget {
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var notePicked = "EMPTY";
  var noteStatus = "";
  var status = "Click on start";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Intonation Practice'),
      ),
      body: Center(
        child: Column(children: [
          Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
          ),
          Center(
            child: Text(
              notePicked,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
              )),
          Center(
            child: FloatingActionButton(
                heroTag: "Start",
                backgroundColor: Colors.green,
                splashColor: Colors.blueGrey,
                onPressed: (){
                  notePicked = loadNote();
                  print(notePicked);
                  _startCapture;
                },
                child: const Text("Start")
            )),
          Center(
            child: FloatingActionButton(
              heroTag: "Stop",
              backgroundColor: Colors.red,
              splashColor: Colors.blueGrey,
              onPressed: _stopCapture,
              child: const Text("Stop"))),
          Center(
            child: Container(
              alignment: Alignment.center,
              width: size.width - 30,
              height: size.height - 10,
              child: FutureBuilder<Score>(
                  future: loadXML(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        child: MusicLine(
                        options: MusicLineOptions(
                          snapshot.data!,
                          STAFF_HEIGHT,
                          1,
                        ),
                      ));
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
              ),
            ),
          ),
        ],
        )
      ),
    );
  }


  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      note = loadNote();
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
        if (status == "TuningStatus.tuned") {
          status = "Tuned!!!!".toUpperCase();
          _stopCaptureTuned();
        }
      });
    }
  }

  Future<void> _stopCaptureTuned() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      //status = "Tuned!!!!";
    });
  }

  void onError(Object e) {
    print(e);
  }
}