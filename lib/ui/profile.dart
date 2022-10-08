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
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UserName();
                },),),},
            ),
            //Change Email
            ListTile(
              //leading: const Icon(Icons.home),
              title: const Text(
                'Change Email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Email();
                },),),},
            ),
            //Change Password
            ListTile(
              title: const Text(
                'Change Password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Password();
                },),),},
            ),
          ],
        ),
      ),
    );
  }
}

//Username Widget
class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const SideDrawerReg(),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Change Username"),
      ),
      body: const Center(
        child: Text('Change Username'),
      ),
    );
  }
}

//Email Widget
class Email extends StatelessWidget {
  const Email({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const SideDrawerReg(),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Change Email"),
      ),
      body: const Center(
        child: Text('Change Email'),
      ),
    );
  }
}

//Email Widget
class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const SideDrawerReg(),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Change Password"),
      ),
      body: const Center(
        child: Text('Change Password'),
      ),
    );
  }
}