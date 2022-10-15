import 'dart:typed_data';
import 'package:capstone_project_intune/pitch_detector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'firebase_options.dart';
import 'ui/authentication.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';


// import package to play specific frequency for tuning


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'InTune',
      home: Tuning(title: 'Tuning',),
      debugShowCheckedModeBanner: false, //setup this property
    );
  }
}

//Nav Bar (Side Bar)
class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text(
                  'InTune',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),

          //Login
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Login/Register'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                //return const SignIn();
                return const Authentication();
              },),),},
          ),
          //Tuning
          ListTile(
            //leading: const Icon(Icons.home),
            title: const Text('Tuning'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Tuning(title: 'Tuning',);
              },),),},
          ),
          //Practice
          ListTile(
             leading: const Icon(Icons.lock),
            title: const Text('Practice'),
            onTap: () => {
              //Navigator.push(context, MaterialPageRoute(builder: (context) {
                //return const Practice();
              //},),),
            },
          ),
          //Composition
          ListTile(
             leading: const Icon(Icons.lock),
            title: const Text('Composition'),
            onTap: () => {
              //Navigator.push(context, MaterialPageRoute(builder: (context) {
               // return const Composition();
              //},),),
            },
          ),
          //Virtual Band
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Virtual Band'),
            onTap: () => {
              //Navigator.push(context, MaterialPageRoute(builder: (context) {
               // return const VirtualBand();
              //},),),
              },
          ),
        ],
      ),
    );
  }
}

//Nav Bar (Side Bar) (Registered)
class SideDrawerReg extends StatelessWidget {
  const SideDrawerReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text(
                  'InTune',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),

          //Login
          ListTile(
            //leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Profile();
                },),),},
          ),
          //Tuning
          ListTile(
            //leading: const Icon(Icons.home),
            title: const Text('Tuning'),
            onTap: () =>
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Tuning(title: 'Tuning',);
              },),),},
              /* Navigator.push(context, MaterialPageRoute(builder: (context) => const Tuning()),
              )} */
          ),
          //Practice
          ListTile(
            //leading: const Icon(Icons.lock),
            title: const Text('Practice'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Practice();
              },),),},
          ),
          //Composition
          ListTile(
            //leading: const Icon(Icons.lock),
            title: const Text('Composition'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
               return const Composition();
              },),),},
          ),
          //Virtual Band
          ListTile(
            //: const Icon(Icons.lock),
            title: const Text('Virtual Band'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
               return const VirtualBand();
              },),),},
          ),
        ],
      ),
    );
  }
}

//Tuning Widget
/*
class Tuning extends StatelessWidget {
  const Tuning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Tuning'),
      ),
      body: const Center(
        child: Text('Tuning'),
      ),
    );
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

      //Updates the state with the result
      setState(() {
        note = handledPitchResult.note;
        status = handledPitchResult.tuningStatus.toString();
      });
    }
  }

  void onError(Object e) {
    print(e);
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
                note,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              )),
          const Spacer(),
          Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: _startCapture,
                              child: const Text("Start")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: _stopCapture, child: const Text("Stop")))),
                ],
              ))
        ]),
      ),
    );
  }
}
*/
/*
class TuningReg extends Tuning() {
  const TuningReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text('Tuning'),
      ),
      body: const Center(
        child: Text('Tuning'),
      ),
    );
  }
}
*/
class Tuning extends StatefulWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('Tuning'),
      ),
      body: const Center(
        child: Text('Tuning'),
      ),
    );
  }
  const Tuning({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Tuning> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Tuning> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var notePicked = "";
  var noteStatus= "";
  var status = "Click on start";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                          }, child: const Text("C#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "D".toString();

                              }, child: const Text("D")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "D#".toString();

                              }, child: const Text("D#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "E".toString();

                              }, child: const Text("E")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "F".toString();

                              }, child: const Text("F")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "F#".toString();

                              }, child: const Text("F#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "G".toString();

                              }, child: const Text("G")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "G#".toString();

                              }, child: const Text("G#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "A".toString();

                              }, child: const Text("A")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "A#".toString();

                              }, child: const Text("A#")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              onPressed: (){
                                notePicked = "B".toString();

                              }, child: const Text("B")))),
                ],
              )),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
                              backgroundColor: Colors.green,
                              splashColor: Colors.blueGrey,
                              onPressed: _startCapture,
                              child: const Text("Start")))),
                  Expanded(
                      child: Center(
                          child: FloatingActionButton(
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
}


//Practice Widget
class Practice extends StatelessWidget {
  const Practice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: const Center(
        child: Text('Practice'),
      ),
    );
  }
}

//Composition Widget
class Composition extends StatelessWidget {
  const Composition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text("Composition"),
      ),
      body: const Center(
        child: Text('Composition'),
      ),
    );
  }
}

//Virtual Band Widget
class VirtualBand extends StatelessWidget {
  const VirtualBand({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text('Virtual Band'),
      ),
      body: const Center(
        child: Text('Virtual Band'),
      ),
    );
  }
}

//Account Widget
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text('Profile'),
      ),
    );
  }
}