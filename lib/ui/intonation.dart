import 'dart:typed_data';
import 'package:capstone_project_intune/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:capstone_project_intune/pitch_detector.dart';

class Intonation extends StatefulWidget {
  const Intonation({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Intonation> createState() => _Intonation();
}

class _Intonation extends State<Intonation> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var musicOption = "";
  var noteStatus = "";
  var status = "Click on start";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(children:[
          Expanded(
            child: Row(
              children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.file_upload, color: Colors.blueGrey),
                    FloatingActionButton(
                      shape: const RoundedRectangleBorder(),
                      onPressed: (){
                        musicOption = "File Upload".toString();
                      },
                        child: const Text("Upload File"))
                 ],
                ),
              ),

              Expanded(
               child: Column(
                children: [
                  Icon(Icons.file_open, color: Colors.blueGrey),
                  FloatingActionButton(
                    shape: const RoundedRectangleBorder(),
                    onPressed: (){
                      musicOption = "File Open".toString();
                    },
                    child: const Text("Open File"))
                ],
              ),
           ),
        ],

        ),
          ),
    ],
    ),
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