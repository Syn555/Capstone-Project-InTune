import 'package:capstone_project_intune/ui/tuning.dart';
import 'package:capstone_project_intune/ui/tuningReg.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {


  testWidgets(
      "Clicking on A key while show A on top", (WidgetTester tester) async {
    final button = find.byKey(Key("A"));
    final note = find.text("A");

    await tester.pumpWidget(
        const MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pump();

    expect(note, findsOneWidget);
  });

  testWidgets("Clicking on start will start listening to user", (
      WidgetTester tester) async {
    final button = find.byKey(Key("Start"));
    final status = find.text("Start");


    await tester.pumpWidget(
        const MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pumpAndSettle(Duration(seconds:2));

    expect(status, findsOneWidget);

  });
}