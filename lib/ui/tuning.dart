/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../main.dart';
// import package to play specific frequency for tuning
import 'package:sound_generator/sound_generator.dart';


// List of every note in an octave
// Implement dropdown button for different instruments for ease of use?
const List<String> notes = <String>['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

class Tuning extends StatelessWidget {
  const Tuning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Tuning'),
      ),
      body:  Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
          [
              Text('Tuning FROM UI FOLDER'),
              NoteSelectionDropdown(),
          ]
        ),
      ),
    );
  }
}

// Create Dropdown
class NoteSelectionDropdown extends StatefulWidget
{
  const NoteSelectionDropdown({super.key});

  @override
  State<NoteSelectionDropdown> createState() => _NoteSelectionDropdownState();
}

// Create Different States for NoteSelectionDropdown
class _NoteSelectionDropdownState extends State<NoteSelectionDropdown>
{
  String dropdownValue = notes.first;

  @override
  Widget build(BuildContext context)
  {
    return DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down_circle_sharp),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value)
        {
          // Called when user selects note
          setState(()
          {
            dropdownValue = value!;

          });
        },

        items: notes.map<DropdownMenuItem<String>>((String value)
        {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
    );
  }
}

*/

import 'dart:ui';

import 'package:capstone_project_intune/ui/Tuning.dart';
import 'package:flutter/material.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';

class Tuning extends StatefulWidget {
  @override
  _TuningState createState() => _TuningState();
}

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  final List<int> oneCycleData;

  MyPainter(this.oneCycleData);

  @override
  void paint(Canvas canvas, Size size) {
    var i = 0;
    List<Offset> maxPoints = [];

    final t = size.width / (oneCycleData.length - 1);
    for (var _i = 0, _len = oneCycleData.length; _i < _len; _i++) {
      maxPoints.add(Offset(
          t * i,
          size.height / 2 -
              oneCycleData[_i].toDouble() / 32767.0 * size.height / 2));
      i++;
    }

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.polygon, maxPoints, paint);
  }

  @override
  bool shouldRepaint(MyPainter old) {
    if (oneCycleData != old.oneCycleData) {
      return true;
    }
    return false;
  }
}

class _TuningState extends State<Tuning> {
  bool isPlaying = false;
  double frequency = 20;
  double balance = 0;
  double volume = 1;
  waveTypes waveType = waveTypes.SINUSOIDAL;
  int sampleRate = 96000;
  List<int>? oneCycleData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Tuning'),
            ),
            body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Choose a note to tune"),
                      SizedBox(height: 2),
                      Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.white54,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 0,
                          ),
                          child: oneCycleData != null
                              ? CustomPaint(
                            painter: MyPainter(oneCycleData!),
                          )
                              : Container()),
                      SizedBox(height: 2),
                      Text("A Cycle Data Length is " +
                          (sampleRate / this.frequency).round().toString() +
                          " on sample rate " +
                          sampleRate.toString()),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.red,
                      ),
                      SizedBox(height: 5),
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightBlueAccent,
                          child: IconButton(
                              icon: Icon(
                                  isPlaying ? Icons.stop : Icons.play_arrow),
                              onPressed: () {
                                isPlaying
                                    ? SoundGenerator.stop()
                                    : SoundGenerator.play();
                              })),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.red,
                      ),
                      SizedBox(height: 5),
                      Text("Wave Form"),
                      Center(
                          child: DropdownButton<waveTypes>(
                              value: this.waveType,
                              onChanged: (waveTypes? newValue) {
                                setState(() {
                                  this.waveType = newValue!;
                                  SoundGenerator.setWaveType(this.waveType);
                                });
                              },
                              items:
                              waveTypes.values.map((waveTypes classType) {
                                return DropdownMenuItem<waveTypes>(
                                    value: classType,
                                    child: Text(
                                        classType.toString().split('.').last));
                              }).toList())),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.red,
                      ),
                      SizedBox(height: 5),
                      Text("Frequency"),
                      Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                          this.frequency.toStringAsFixed(2) +
                                              " Hz")),
                                ),
                                Expanded(
                                  flex: 8, // 60%
                                  child: Slider(
                                      min: 20,
                                      max: 10000,
                                      value: this.frequency,
                                      onChanged: (_value) {
                                        setState(() {
                                          this.frequency = _value.toDouble();
                                          SoundGenerator.setFrequency(
                                              this.frequency);
                                        });
                                      }),
                                )
                              ])),
                      SizedBox(height: 5),
                      Text("Balance"),
                      Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                          this.balance.toStringAsFixed(2))),
                                ),
                                Expanded(
                                  flex: 8, // 60%
                                  child: Slider(
                                      min: -1,
                                      max: 1,
                                      value: this.balance,
                                      onChanged: (_value) {
                                        setState(() {
                                          this.balance = _value.toDouble();
                                          SoundGenerator.setBalance(
                                              this.balance);
                                        });
                                      }),
                                )
                              ])),
                      SizedBox(height: 5),
                      Text("Volume"),
                      Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                      child:
                                      Text(this.volume.toStringAsFixed(2))),
                                ),
                                Expanded(
                                  flex: 8, // 60%
                                  child: Slider(
                                      min: 0,
                                      max: 1,
                                      value: this.volume,
                                      onChanged: (_value) {
                                        setState(() {
                                          this.volume = _value.toDouble();
                                          SoundGenerator.setVolume(this.volume);
                                        });
                                      }),
                                )
                              ]))
                    ]))));
  }

  @override
  void dispose() {
    super.dispose();
    SoundGenerator.release();
  }

  @override
  void initState() {
    super.initState();
    isPlaying = false;

    SoundGenerator.init(sampleRate);

    SoundGenerator.onIsPlayingChanged.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    SoundGenerator.onOneCycleDataHandler.listen((value) {
      setState(() {
        oneCycleData = value;
      });
    });

    SoundGenerator.setAutoUpdateOneCycleSample(true);
    //Force update for one time
    SoundGenerator.refreshOneCycleData();
  }
}