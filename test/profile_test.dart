import 'package:capstone_project_intune/ui/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Should update user's email", (WidgetTester tester) async {
    final email = find.byKey(ValueKey("emailField"));
    final emailButton = find.byKey(ValueKey("emailButton"));

    await tester.pumpWidget(MaterialApp(home: UpdateProfile()));
    await tester.enterText(email, "user@email.com");
    await tester.tap(emailButton);
    await tester.pump();

  });

  testWidgets("Should update user's password", (WidgetTester tester) async {
    final pwd = find.byKey(ValueKey("passField"));
    final pwdButton = find.byKey(ValueKey("passButton"));

    await tester.pumpWidget(MaterialApp(home: UpdateProfile()));
    await tester.enterText(pwd, "password");
    await tester.tap(pwdButton);
    await tester.pump();

  });

  testWidgets("Should sign out of account", (WidgetTester tester) async{

  });

  testWidgets("Should delete account", (WidgetTester tester) async{

  });

}