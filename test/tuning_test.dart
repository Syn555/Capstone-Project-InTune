import 'package:capstone_project_intune/ui/tuning.dart';
import 'package:flutter/material.dart';
//import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //testing start function
  test('Should start capture and set status to "Play Something"',() async {
    const readTone = Tuning(title: "Tuning");
    //final readToneState= readTone.createState();
    final actualText= find.text("Play Something");
    final status= find.byKey(ValueKey("Status"));
    expect(status, actualText);
  });

  //actual start function
  test('Should start capture and set status to "Play Something"',() async {
    const readTone = Tuning(title: "Tuning");
    //final readToneState= readTone.createState(Tuning(title: Tuning));
    readTone.startCapture();
    expect(const Tuning(title: 'Tuning',).unitTestVariable, "Play something");
  });

  test('Should stop capture and set status to "Tuned!!!!"',()async{
    final readTone = _Tuning();
    readTone.stopCaptureTuned();
    expect(_Tuning().unitTestVariable,"Tuned!!!!");
  });

  test('Should stop capture and set status to "Click on start"',()async{
    final readTone = _Tuning();
    readTone.stopCapture();
    expect(_Tuning().unitTestVariable,"Click on start");
  });
}
