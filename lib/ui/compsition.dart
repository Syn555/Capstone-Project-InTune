import 'package:capstone_project_intune/ui/config.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class Composition extends StatefulWidget{
  const Composition({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Composition> createState() => _Composition();
}

class _Composition extends State<Composition>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        title: const Text("Composition"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Config(title: "Config",);
              },),);},
          ), //IconButton
        ],
        elevation: 50.0,
      ),
      body: const Center(
        child: Text('Composition'),
      ),
    );
  }
}