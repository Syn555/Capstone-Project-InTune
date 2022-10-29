import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:pitchupdart/pitch_result.dart';
import 'package:xml/xml.dart';
import 'package:capstone_project_intune/musicXML/parser.dart';
import 'package:capstone_project_intune/musicXML/data.dart';
import 'package:capstone_project_intune/notes/music-line.dart';
import 'package:capstone_project_intune/main.dart';


Future<Score> loadXML() async {
  final rawFile = await rootBundle.loadString('hanon-no1-stripped.musicxml');
  final result = parseMusicXML(XmlDocument.parse(rawFile));
  return result;
}

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
  var notePicked = "";
  List<String> notesPlayed= [];
  List<String> notesToBeAdded= [];
  var noteStatus= "";
  var status = "Click on start";
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Composition'),
      ),
      body: Center(
        child: Column(children: [
          Center(
            child: Container(
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
            ),
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/testers.txt');
  }


  update(String n) async {
    final rawFile = await rootBundle.loadString('hanon-no1-stripped.musicxml');
    var parsedXML= XmlDocument.parse(rawFile);
    //final titles = parsedXML.findAllElements('note');
    //print(noteFun());
    //final file = await _localFile;

    var newNote="<note> <pitch> <step>$n</step> <octave>5</octave> </pitch> <duration>1</duration> <voice>1</voice><type>eighth</type> <stem default-y=\"3\">up</stem><staff>1</staff> <beam number=\"1\">begin</beam></note>";
    notesToBeAdded.add(newNote);
    var ending= "</measure></part></score-partwise>";
    for(var i=0; i < notesToBeAdded.length;i++) {
      final filename= 'testers.txt';
      var file= await File(filename).writeAsString(notesToBeAdded[i]);
      print(file);
    }
    /*var files= File('text');
    var sink= files.openWrite();
    sink.write('testing');
    sink.close();
    files.openWrite(mode: FileMode.append, encoding: ascii);
    */

    //print(basic);
    //print(notesToBeAdded);
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
      notesPlayed.clear();
    });

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

        var holder= handledPitchResult.note;

      //Updates the state with the result
      setState(() {
        if (status == "TuningStatus.tuned") {
          note = "";
          print("Actual pitchresult: $holder");
          notesPlayed.add(holder);
          print(holder);
          print(notesPlayed);
          update(holder);
          //testing to see if I an get the actual note printed
          //print("Actual note: $result");
        }
      }
      );
    }
  }


  void onError(Object e) {
    print(e);
  }
}