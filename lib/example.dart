import 'package:flutter/material.dart';
import 'package:tonic/tonic.dart';

import 'sheet_music.dart';
import 'util/notes.dart';
import 'util/pitch_asset.dart';
import 'util/scale_asset.dart';
import 'util/scales.dart';

void main() async{
  runApp(const SheetMusicExample());
}

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
                      final String currentScale =
                          scalesMajor[index].toString();
                      return ListTile(
                        contentPadding: const EdgeInsets.all(5.0),
                        leading: SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            getScaleAsset(currentScale,
                                trebleClef: trebleClef),
                            package: sheetMusicPackageName,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: Text(
                          currentScale,
                        ),
                        subtitle: Text(scalesMinor[index].toString()),
                        onTap: () {
                          Navigator.pop(context, currentScale);
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
    final List<String> notesList = trebleClef
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
                    itemCount: notesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String _currentPitch = notesList[index].toString();
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
                subtitle: Text(scale ?? 'C Major'),
                trailing: const Icon(Icons.search),
                onTap: () => _pickScale(context),
              ),
              ListTile(
                title: const Text('Pitch'),
                subtitle: Text(scale ?? 'None'),
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
