import 'package:capstone_project_intune/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
          ]);
        }
        return const MaterialApp(home: TuningReg());
      }
    );
  }
}