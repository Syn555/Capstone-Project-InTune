import 'package:capstone_project_intune/ui/tuning.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  _Profile createState() => _Profile();

}

class _Profile extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile"),
      ),

      body: Column(
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

          //Account Settings
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child:
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UpdateProfile();},),),
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey.shade100),
                ),
                child: Row(
                    children: const [
                      Expanded(
                          child: Text(
                          "Update Account",
                          style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 3,
                              color: Colors.black
                          ),
                        )
                      ),
                      Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black
                      )
                    ]
                ),
              )
          ),

          //Uploaded Sheets
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child:
              ElevatedButton(
                onPressed: () => {
                 // Navigator.push(context, MaterialPageRoute(builder: (context) {
                 //   return const UpdateProfile();},),),
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey.shade100),
                ),
                child: Row(
                    children: const [
                      Expanded(
                          child: Text(
                            "Uploaded Sheets",
                            style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 3,
                                color: Colors.black
                            ),
                          )
                      ),
                      Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black
                      )
                    ]
                ),
              )
          ),

          //Created Sheets
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child:
              ElevatedButton(
                onPressed: () => {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) {
                   // return const UpdateProfile();},),),
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey.shade100),
                ),
                child: Row(
                    children: const [
                      Expanded(
                          child: Text(
                            "Created Sheets",
                            style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 3,
                                color: Colors.black
                            ),
                          )
                      ),
                      Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black
                      )
                    ]
                ),
              )
          ),

          //Log Out
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child:
              ElevatedButton(
                onPressed: () => {
                  //FirebaseAuth.instance.signOut(),
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Tuning();
                },),),},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey.shade100),
                ),
                child: Row(
                    children: const [
                      Expanded(
                          child: Text(
                            "Log Out",
                            style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 3,
                                color: Colors.red
                            ),
                          )
                      ),
                      Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.red
                      )
                    ]
                ),
              )
          )
        ],
      ),
    );
  }
}