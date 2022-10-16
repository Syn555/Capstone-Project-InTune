import 'dart:typed_data';
import 'package:capstone_project_intune/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:capstone_project_intune/pitch_detector.dart';

class TuningReg extends StatefulWidget {
  const TuningReg({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TuningReg> createState() => _TuningReg();
}

class _TuningReg extends State<TuningReg> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var notePicked = "";
  var noteStatus= "";
  var status = "Click on start";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Center(
              child: Text(
                notePicked,
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              )),
          const Spacer(),
          Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "C".toString();
                              },
                              child: const Text("C")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "C#".toString();
                              },
                              child: const Text("C#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "D".toString();
                              },
                              child: const Text("D")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "D#".toString();
                              },
                              child: const Text("D#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "E".toString();
                              },
                              child: const Text("E")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "F".toString();
                              },
                              child: const Text("F")))),
                ],
              )),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "F#".toString();
                              },
                              child: const Text("F#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "G".toString();
                              },
                              child: const Text("G")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "G#".toString();
                              },
                              child: const Text("G#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "A".toString();
                              },
                              child: const Text("A")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "A#".toString();
                              },
                              child: const Text("A#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "B".toString();
                              },
                              child: const Text("B")))),
                ],
              )),
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
          status = "Tuned!!!!".toUpperCase();
        }else if (status == "TuningStatus.toohigh" || status == "TuningStatus.waytoohigh"){
          status = "Too high, please tune lower";
        }else if( status == "TuningStatus.toolow" || status ==  "TuningStatus.waytoolow"){
          status = "Too low, please tune higher";
        }
      });
    }
  }

  void onError(Object e) {
    print(e);
  }
}