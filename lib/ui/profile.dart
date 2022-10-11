import 'package:flutter/material.dart';
import 'package:capstone_project_intune/ui/updateProfile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const SideDrawerReg(),
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

            //Username
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child:
              ListTile(
                title: Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 25,
                      letterSpacing: 2
                  ),
                ),
              ),
            ),
            //Email
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child:
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 25,
                        letterSpacing: 2
                    ),
                  ),
                ),
            ),

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
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  //padding: const EdgeInsets.all(10)
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
          )
        ],
      ),
    );
  }
}