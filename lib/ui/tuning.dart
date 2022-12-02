import 'dart:typed_data';
import 'package:capstone_project_intune/main.dart';
import 'package:capstone_project_intune/ui/tuner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
var freq = 0.0;

var freq = 0.0;

class Tuning extends StatefulWidget {
  const Tuning({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Tuning> createState() => _Tuning();
}

class _Tuning extends State<Tuning> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);
  //final assetsAudioPlayer = AssetsAudioPlayer();
  final FocusNode _focusNode = FocusNode();
  //final audioPlayer = AudioPlayer();
  //final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  AudioPlayer player = AudioPlayer();

  _readTone(String tone) async {
    final player=AudioPlayer();
    player.play(AssetSource('notes/$tone.mp3'));
    setState(() {
      pianoTone=tone;
    });
  }

  var note = "";
  var pianoTone="";
  var notePicked = "";
  var noteStatus= "";
  var status = "Click on start";

  Future<void> _handleKeyEvent(RawKeyEvent event) async {
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      _readTone("C");
      notePicked = "C".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyX) {
      _readTone('D');
      notePicked = "D".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
      _readTone('E');
      notePicked = "E".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyV) {
      _readTone('F');
      notePicked = "F".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyB) {
      _readTone('G');
      notePicked = "G".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
      _readTone('A');
      notePicked = "A".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyM) {
      _readTone('B');
      notePicked = "B".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
     _readTone('Db');
     notePicked = "C#".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      _readTone('Eb');
      notePicked = "D#".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyG) {
      _readTone('Gb');
      notePicked = "F#".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyH) {
      _readTone('Ab');
      notePicked = "G#".toString();
    } else if (event.logicalKey == LogicalKeyboardKey.keyJ) {
      _readTone('Bb');
      notePicked = "A#".toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Center(
              child: Text(
                pianoTone,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              )),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        TunerView(frequency: freq),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
          Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
          /*Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "C",
                              onPressed: (){
                                notePicked = "C".toString();
                              },
                              child: const Text("C")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "C#",
                              onPressed: (){
                                notePicked = "C#".toString();
                              },
                              child: const Text("C#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "D",
                              onPressed: (){
                                notePicked = "D".toString();
                              },
                              child: const Text("D")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "D#",
                              onPressed: (){
                                notePicked = "D#".toString();
                              },
                              child: const Text("D#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "E#",
                              onPressed: (){
                                notePicked = "E".toString();
                              },
                              child: const Text("E")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "F",
                              onPressed: (){
                                notePicked = "F".toString();
                              },
                              child: const Text("F")))),
                ],
              )),*/
          /*Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "F#",
                              onPressed: (){
                                notePicked = "F#".toString();
                              },
                              child: const Text("F#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "GC",
                              onPressed: (){
                                notePicked = "G".toString();
                              },
                              child: const Text("G")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "G#",
                              onPressed: (){
                                notePicked = "G#".toString();
                              },
                              child: const Text("G#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "A",
                              onPressed: (){
                                notePicked = "A".toString();
                              },
                              child: const Text("A")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "A#",
                              onPressed: (){
                                notePicked = "A#".toString();
                              },
                              child: const Text("A#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              heroTag: "B",
                              onPressed: (){
                                notePicked = "B".toString();
                              },
                              child: const Text("B")))),
                ],
              )),*/
          Expanded(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double whiteWidth = constraints.maxWidth / 7;
                return RawKeyboardListener(
                  autofocus: true,
                  focusNode: _focusNode,
                  onKey: _handleKeyEvent,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      whiteTile('C', 0, whiteWidth),
                      whiteTile('D', 1, whiteWidth),
                      whiteTile('E', 2, whiteWidth),
                      whiteTile('F', 3, whiteWidth),
                      whiteTile('G', 4, whiteWidth),
                      whiteTile('A', 5, whiteWidth),
                      whiteTile('B', 6, whiteWidth),
                      blackTile('Db', 1, whiteWidth, constraints.maxHeight / 2),
                      blackTile('Eb', 2, whiteWidth, constraints.maxHeight / 2),
                      blackTile('Gb', 4, whiteWidth, constraints.maxHeight / 2),
                      blackTile('Ab', 5, whiteWidth, constraints.maxHeight / 2),
                      blackTile('Bb', 6, whiteWidth, constraints.maxHeight / 2),
                    ],
                  ),
                );}),),
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
                ],
              ))
        ]),
      ),
    );
  }


  Widget whiteTile(String tone, double position, double whiteWidth) {
    return Positioned(
      top: 0,
      left: position * whiteWidth,
      width: whiteWidth,
      bottom: 0,
      child: RawMaterialButton(
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        onPressed: () => _readTone(tone),
      ),
    );
  }

  Widget blackTile(String tone, double position, double whiteWidth,
      double height) {
    double blackWidth = whiteWidth * 0.60;
    return Positioned(
      top: 0,
      left: position * whiteWidth - blackWidth / 2,
      width: blackWidth,
      height: height,
      child: RawMaterialButton(
        fillColor: Colors.black,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        onPressed: () => _readTone(tone),
      ),
    );}


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

  Future<void> _stopCaptureTuned() async {
    await _audioRecorder.stop();

    setState(() {
      note = "";
      status = "Tuned!!!!";
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
      freq = handledPitchResult.diffFrequency;

      //Updates the state with the result
      setState(() {
        if(status == "TuningStatus.tuned"){
          status = "Tuned!!!!".toUpperCase();
          _stopCaptureTuned();
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
    print(e);
  }
}



