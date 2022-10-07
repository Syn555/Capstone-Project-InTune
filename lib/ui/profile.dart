import 'package:flutter/material.dart';
import '../main.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawerReg(),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text('Profile'),
      ),
    );
  }
}