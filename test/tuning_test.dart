import 'package:capstone_project_intune/ui/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Should display A on top of screen", (WidgetTester tester) async {
    final button = find.byKey(const ValueKey("A"));
    final note = find.text("A");

    await tester.pumpWidget(const MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pump();
    expect(note, findsOneWidget);
  });

  testWidgets("Should start listening to user input", (WidgetTester tester) async {
    final button = find.byKey(const ValueKey("Start"));
    final status  = find.text("Play something");

    await tester.pumpWidget(const MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pump();

    expect(status, findsOneWidget);
  });

  testWidgets("Should stop listening to user input", (WidgetTester tester) async {
    final button = find.byKey(const ValueKey("Stop"));
    final status  = find.text("Click start");

    await tester.pumpWidget(const MaterialApp(home: Tuning(title: "Tuning")));
    await tester.tap(button);
    await tester.pump();

    expect(status, findsOneWidget);
  });
/*
  test('Should stop capture and set status to "Tuned!!!!"',() async{
    final status = find.text("Tuned!!!!");
    Tune().stopCaptureTuned;
    expect(status, findsOneWidget);
  });
*/
}