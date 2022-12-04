import 'dart:html';

import 'package:capstone_project_intune/ui/profile.dart';
import 'package:capstone_project_intune/ui/tuning.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{

  TestWidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  testWidgets("Clicking on A key while show A on top", (WidgetTester tester) async {
    final button = find.byKey(ValueKey("A"));
    final note = find.text("A");

    await tester.pumpWidget(MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pump();

    expect(note, findsOneWidget);
  });
  testWidgets("Clicking on start will start listening to user", (WidgetTester tester) async {
    final button = find.byKey(ValueKey("Start"));
    final status = find.text("Play Something");

    await tester.pumpWidget(MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pump();

    expect(status, findsOneWidget);
  });

}