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
      body:  Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Center(
                  child: Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
              ),
            ),

            //Change Username
            ListTile(
              title: const Text(
                'Change Username',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => {},
            ),
            //Change Email
            ListTile(
              //leading: const Icon(Icons.home),
              title: const Text(
                'Change Email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => {},
            ),
            //Change Password
            ListTile(
              title: const Text(
                'Change Password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => {},
            ),
          ],
        ),
      ),
    );
  }
}