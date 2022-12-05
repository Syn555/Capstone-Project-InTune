import 'package:capstone_project_intune/composition.dart';
import 'package:flutter/material.dart';
//import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('Should stop capture and set status to "Tuned!!!!"',() async{
    final readTone = _MyHomePageState().createState();
    readTone._stopCapture();
    expect(readTone.status,"Tuned!!!!");
  });

  test('Should start capture and set status to "Play something"',() async{
    final readTone = _MyHomePageState().createState();
    readTone._startCapture;
    expect(readTone.status,"Play something");
  });

  test('Listner should print holder note',() async{
    final readTone = _MyHomePageState().createState();
    readTone.lis;
    expect(readTone.status,"Tuned!!!!");
  });


}
