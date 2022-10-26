import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: Text('Composition'),
      ),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            width: size.width - 40,
            height: size.height - 40,
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
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                }
            )
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}