import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';

import 'package:capstone_project_intune/ui/tuning.dart';
import 'package:external_path/external_path.dart';
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
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

const double STAFF_HEIGHT = 36;

// class CounterStorage {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/counter.txt');
//   }
//
//   Future<int> readCounter() async {
//     try {
//       final file = await _localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//
//       return int.parse(contents);
//     } catch (e) {
//       // If encountering an error, return 0
//       return 0;
//     }
//   }
//
//   Future<File> writeCounter(int counter) async {
//     final file = await _localFile;
//
//     // Write the file
//     return file.writeAsString('$counter');
//   }
// }

//read and write
Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}


class MyHomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Composition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false, //setup this property
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  //final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _openResult = 'Unknown';
  List<String> _exPath = [];

  // Get storage directory paths
  // Like internal and external (SD card) storage path
  Future<void> getPath() async {
    List<String> paths;
    // getExternalStorageDirectories() will return list containing internal storage directory path
    // And external storage (SD card) directory path (if exists)
    paths = await ExternalPath.getExternalStorageDirectories();

    setState(() {
      _exPath = paths; // [/storage/emulated/0, /storage/B3AE-4D28]
    });
  }

  // To get public storage directory path like Downloads, Picture, Movie etc.
  // Use below code
  Future<void> getPublicDirectoryPath() async {
    String path;

    path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    setState(() {
      print(path); // /storage/emulated/0/Download
    });
  }

  Future<void> openFile() async {
    //read and write
    const filename = 'test.xml';

    var bytes = await rootBundle.load("blank.musicxml");
    String? dir = (await getApplicationDocumentsDirectory()).path;

    writeToFile(bytes, '$dir/$filename');

    //DocumentFileSave.saveFile(bytes,filename, 'xml');
    //String? filePath = r'/storage/emulated/0/update.apk';
    //FilePickerResult? result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   dir = result.files.single.path;
    // } else {
    //   // User canceled the picker
    // }

    final _result = await OpenFile.open('$dir/$filename');
    print(_result.message);

    //loadXMLexternal();


    final index = notesToBeAdded.length-1; // remove the 6th line


    // f.readAsLines().then((List<String> lines) {
    //   for(var index=lines.length-4; index<lines.length;index++) {
    //     lines.removeAt(index);
    //     final newTextData = lines.join('\n');
    //     f.writeAsString(newTextData);
    //   }// update the file with the new data
    // });

    setState(() {
      _openResult = "type=${_result.type}  message=${_result.message}";
    });

  }


  Future<Score> loadXML() async {
    //final Directory directory = await getApplicationDocumentsDirectory();
    // final rawFile = everything.toString();
    // //print(everything);
    // final document= XmlDocument.parse(rawFile);
    // final result = parseMusicXML(document);
    // return result;
    final rawFile = await rootBundle.loadString('blank.musicxml');
    final result = parseMusicXML(XmlDocument.parse(rawFile));
    return result;
  }

  Future<Score> loadXMLexternal() async {

    String? dir = (await getApplicationDocumentsDirectory()).path;
    //final Directory directory = await getApplicationDocumentsDirectory();
    //final rawFile = await OpenFile.open('$dir/test.xml');
    final file = File('$dir/test.xml');
    //update(notesToBeAdded);
    // //print(everything);
    final document= XmlDocument.parse(file.readAsStringSync());
    final result = parseMusicXML(document);
    // return result;
    // final rawFile = await rootBundle.loadString('blank.musicxml');
    // final result = parseMusicXML(XmlDocument.parse(rawFile));
    return result;
  }

  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = "";
  var notePicked = "";
  var everything;
  List<String> notesPlayed= [];
  List<String> notesToBeAdded= [];
  var noteStatus= "";
  var status = "Click on start";


  // @override
  // void initState() {
  //   super.initState();
  //   widget.storage.readCounter().then((value) {
  //     setState(() {
  //       everything = value;
  //     });
  //   });
  // }
  //
  // Future<File> _writeCounter() {
  //
  //
  //   // Write the variable as a string to the file.
  //   return widget.storage.writeCounter(everything);
  // }



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
            child: FutureBuilder<Score>(
                future: loadXMLexternal(),
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




  Future<void> update(List<String> n) async {
    //final titles = parsedXML.findAllElements('note');
    //print(noteFun());
    //await _stopCapture();
    String? dir = (await getApplicationDocumentsDirectory()).path;
    //final Directory directory = await getApplicationDocumentsDirectory();
    //final rawFile = await OpenFile.open('$dir/test.xml');
    final file = File('$dir/test.xml');
    XmlDocument xml = XmlDocument.parse('''<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE score-partwise PUBLIC
    "-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd">
    <score-partwise version="3.1">
    <part-list>
    <score-part id="P1">
    <part-name>Piano</part-name>
    <score-instrument id="P1-I1">
    <instrument-name>Piano</instrument-name>
    </score-instrument>
    </score-part>
    </part-list>
    <part id="P1">
    <measure number="1">
    <attributes>
    <divisions>4</divisions>
    <key>
    <fifths>0</fifths>
    </key>
    <time>
    <beats>4</beats>
    <beat-type>4</beat-type>
    </time>
    <staves>1</staves>
    <clef number="1">
    <sign>G</sign>
    <line>2</line>
    </clef>
    </attributes>
    <note>

    <duration>8</duration>
    <voice>1</voice>
    <staff>1</staff>
    </note>
    <backup>
    <duration>8</duration>
    </backup>''');
    //var notesAdded=n;
    var start= '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE score-partwise PUBLIC-//Recordare//DTD MusicXML 3.1 Partwise//EN" "http://www.musicxml.org/dtds/partwise.dtd"><score-partwise version="3.1"><part-list><score-part id="P1"><part-name>Piano</part-name><score-instrument id="P1-I1"><instrument-name>Piano</instrument-name></score-instrument></score-part></part-list><part id="P1"><measure number="1"><attributes><divisions>4</divisions><key><fifths>0</fifths></key><time><beats>2</beats><beat-type>4</beat-type></time><staves>1</staves><clef number="1"><sign>G</sign><line>2</line></clef></attributes>';
    String newNote;
    var ending= '\</measure></part></score-partwise>';
    var allNotes="";
    //print(notesAdded);

    //final index = lines.length-1; // remove the 6th line

    // File f = new File('test.txt');
     file.readAsLines().then((List<String> lines) {
      for(var index=lines.length-4; index<lines.length;index++) {
        lines.removeAt(index);
        //final newTextData = lines.join('\n');
       // file.writeAsString(newTextData);
      }// update the file with the new data
    });

    for(var i=0; i < n.length;i++) {
      note = n[i];
      XmlDocument newNote= XmlDocument.append('<note> <pitch> <step> $note </step> <octave>5</octave> </pitch> <duration>1</duration> <voice>1</voice><type>eighth</type> <stem default-y="3">up</stem><staff>1</staff> <beam number="1">begin</beam></note>');
      //xml= xml+newNote;
      // await xml.writeAsString(
      //   newNote,
      // mode: FileMode.append,
      // flush: true,
      // );

    }
    //print(allNotes);
    //print(newNote);

    //everything= start+allNotes+ending;


    // //read and write
    // final filename = 'test.pdf';
    // var bytes = await rootBundle.load("blank.musicxml");
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // writeToFile(bytes,'$dir/$filename');
    //
    // OpenFile.open('$dir/$filename');
    //return file;
    //var file = _write(everything);
    //print(everything);

    /*var files= File('text');
    var sink= files.openWrite();
    sink.write('testing');
    sink.close();
    files.openWrite(mode: FileMode.append, encoding: ascii);
    */



  }



  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      notesPlayed.clear();
      note = "";
      status = "Play something";
    });

  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      //update(notesPlayed);
      note = "";
      status = "Click on start";
    });
    //loadXML();
    //openFile();
    update(notesToBeAdded);
    loadXMLexternal();



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
      //   if (status == "TuningStatus.tuned") {
      //     note = "";
      //     print("Actual pitchresult: $holder");
      //     notesPlayed.add(holder);
      //     //print(holder);
      //     //print(notesPlayed);
      //     update(notesPlayed);
      //   }
      //}
      //);
    }
  }


  void onError(Object e) {
    print(e);
  }
}

