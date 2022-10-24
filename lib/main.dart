import 'package:capstone_project_intune/sheet_music.dart';
import 'package:capstone_project_intune/ui/tuning.dart';
import 'package:capstone_project_intune/ui/tuningReg.dart';
import 'package:capstone_project_intune/ui/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'ui/authentication.dart';
import 'package:tonic/tonic.dart';
import 'util/notes.dart';
import 'util/pitch_asset.dart';
import 'util/scale_asset.dart';
import 'util/scales.dart';


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
      //home: Tuning(title: 'Tuning'),
      home: SheetMusicExample(),
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
                color: Colors.blue,
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
                return const Authentication();
              },),),},
          ),
          //Tuning
          ListTile(
            //leading: const Icon(Icons.home),
            title: const Text('Tuning'),
            onTap: () => {},
          ),
          //Practice
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Practice'),
            onTap: () => {},
          ),
          //Composition
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Composition'),
            onTap: () => {},
          ),
          //Virtual Band
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Virtual Band'),
            onTap: () => {},
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
                color: Colors.blue,
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
            title: const Text('Profile'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Profile();
                },),),},
          ),
          //Tuning
          ListTile(
            title: const Text('Tuning'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const TuningReg(title: 'Tuning',);
              },),),},
          ),
          //Practice
          ListTile(
            title: const Text('Practice'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Practice();
              },),),},
          ),
          //Composition
          ListTile(
            title: const Text('Composition'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
               return SheetMusicExample();
              },),),},
          ),
          //Virtual Band
          ListTile(
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
/*class Composition extends StatefulWidget {
  const Composition({super.key});

  @override
  SheetMusicExampleState createState() => SheetMusicExampleState();
}*/

class SheetMusicExample extends StatefulWidget {
  const SheetMusicExample({super.key});

  @override
  SheetMusicExampleState createState() => SheetMusicExampleState();
}

class SheetMusicExampleState extends State<SheetMusicExample> {
  late String name= "A";
  late String number= "2";
  late String scale = 'None';
  late String pitch ="";
  late String timeSignature="";
  late String source="";
  late String notes="";
  late String id="";
  late bool coda= true;
  late bool chorus = true;
  late bool trebleClef= true;
  late int verses, count;

  void _pickScale(BuildContext context) {
    showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const ListTile(
                  title: Text(
                    'Scales',
                    //style: Theme.of(context).textTheme.display1,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: scalesMajor.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String _currentScale =
                          scalesMajor[index].toString();
                          return ListTile(
                            contentPadding: const EdgeInsets.all(5.0),
                            leading: SizedBox(
                              height: 60.0,
                              width: 60.0,
                              child: Image.asset(
                                getScaleAsset(_currentScale,
                                    trebleClef: trebleClef),
                                package: sheetMusicPackageName,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            title: Text(
                              _currentScale,
                            ),
                            subtitle: Text(scalesMinor[index].toString()),
                            onTap: () {
                              Navigator.pop(context, _currentScale);
                            },
                          );
                        })),
              ]));
        }).then((String? value) {
      if (value != null) {
        setState(() => scale = value);
      }
    });
  }

  void _pickPitch(BuildContext context) {
    final List<String> _notesList = trebleClef
        ? pitchesTreble.reversed.toList()
        : pitchesBass.reversed.toList();
    showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const ListTile(
                  title: Text(
                    'Notes',
                    //style: Theme.of(context).textTheme.display1,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListView.builder(
                        itemCount: _notesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String _currentPitch = _notesList[index].toString();
                          final String _pitchName =
                          getPitchName(pitch: _currentPitch, scale: scale);

                          return ListTile(
                            contentPadding: const EdgeInsets.all(5.0),
                            leading: SizedBox(
                              height: 60.0,
                              width: 60.0,
                              child: Image.asset(
                                getPitchAsset(_pitchName, trebleClef: trebleClef),
                                package: sheetMusicPackageName,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            title: Text(
                              _pitchName,
                            ),
                            onTap: () {
                              final Pitch _pitchInfo = Pitch.parse(_pitchName);
                              Navigator.pop(context, _pitchInfo.toString());
                            },
                          );
                        }),
                  ),
                ),
              ]));
        }).then((String? value) {
      if (value != null) {
        setState(() => pitch = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text('Sheet Music Example'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SheetMusic(
                height: 160.0,
                width: 300.0,
                backgroundColor: Colors.white,
                trebleClef: trebleClef,
                scale: scale,
                pitch: pitch,
                clefTap: () => setState(() => trebleClef = !trebleClef),
                scaleTap: () => _pickScale(context),
                pitchTap: () => _pickPitch(context),
              ),
              ListTile(
                title: const Text('Scale'),
                subtitle: Text(scale),
                trailing: const Icon(Icons.search),
                onTap: () => _pickScale(context),
              ),
              ListTile(
                title: const Text('Pitch'),
                subtitle: Text(scale),
                trailing: const Icon(Icons.search),
                onTap: () => _pickPitch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*class Composition extends StatelessWidget {
  const Composition({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SheetMusic(
        scale: "C Major",
        pitch: "C4",
        trebleClef: true,
      ),
    );
  }*/


  /*@override
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
  }*/



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