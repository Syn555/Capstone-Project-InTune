import 'package:flutter/material.dart';

class Config extends StatefulWidget{
  const Config({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Config> createState() => _Config();
}

class _Config extends State<Config>{
  int clefVal = 1;
  int timeVal = 1;
  int keyVal = 1;
  int tempoVal = 1;
  var clefList = ["Treble", "Bass", "Alto", ""];
  var timeSignList = ["4/4", "2/4", "3/4", "6/8"];
  var keySignList = ["C Major", "G Major", "D Major", "F Major"];
  var tempoList = ["Largo (40-60)", "Moderato (108-120)", "Allagro (120-156)", "Presto (168-200)"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Config"),
      ),

      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right:16),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              //Clef
              const SizedBox(height: 35,),
              buildLabel("Clef"),
              DropdownButton(
                  value: clefVal,
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text(clefList.elementAt(0)),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(clefList.elementAt(1)),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(clefList.elementAt(2)),
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      clefVal = value!;
                    });
                  }
              ),

              //Time Signature
              const SizedBox(height: 35,),
              buildLabel("Time Signature"),
              DropdownButton(
                value: timeVal,
                  items: [
                    DropdownMenuItem(
                        value: 1,
                        child: Text(timeSignList.elementAt(0)),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(timeSignList.elementAt(1)),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(timeSignList.elementAt(2)),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text(timeSignList.elementAt(3)),
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      timeVal = value!;
                    });
                  }
              ),

              //Key Signature
              const SizedBox(height: 35,),
              buildLabel("Key Signature"),
              DropdownButton(
                  value: keyVal,
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text(keySignList.elementAt(0)),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(keySignList.elementAt(1)),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(keySignList.elementAt(2)),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text(keySignList.elementAt(3)),
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      keyVal = value!;
                    });
                  }
              ),

              //Tempo
              const SizedBox(height: 35,),
              buildLabel("Tempo (BPM)"),
              DropdownButton(
                  value: tempoVal,
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text(tempoList.elementAt(0)),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(tempoList.elementAt(1)),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(tempoList.elementAt(2)),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text(tempoList.elementAt(3)),
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      tempoVal = value!;
                    });
                  }
              ),
            ]
          ),
        ),
      ),
    );
  }
  Widget buildLabel(String label){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
      Text(
        "Select $label",
        style: const TextStyle(
            fontSize: 25,
            letterSpacing: 2
        ),
      ),
    );
  }
}