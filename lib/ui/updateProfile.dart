import 'package:capstone_project_intune/ui/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget{
  const UpdateProfile({super.key});

  @override
  _UpdateProfile createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateProfile> {
  bool showPassword = true;

  final user = FirebaseAuth.instance.currentUser;

  //final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var username = "";
  var email = "";
  var password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Update Account"),
      ),

     body: Container(
       padding: const EdgeInsets.only(left: 16, top: 25, right:16),
       child: GestureDetector(
         onTap: () {
           FocusScope.of(context).unfocus();
         },

        child: ListView(
         children: <Widget> [
           /*
           //Change Username
           const SizedBox(height: 35,),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 20),
             child:
             Text(
               "Current Username: ${displayUsername()}",
               style: const TextStyle(
                   fontSize: 25,
                   letterSpacing: 2
               ),
             ),
           ),
           buildTextField("New Username", false, _username),
           ElevatedButton(
             onPressed: () {
               if (_username.text != "") {
                 //user?.updatePassword(password);
                 setState(() {
                   username = _username.text;
                 });
                 //print(_username.text);
               }
             },
             style: ElevatedButton.styleFrom(
                 foregroundColor: Colors.blue,
                 padding: const EdgeInsets.symmetric(horizontal: 50),
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20))
             ),
             child: const Text(
               "Change Username",
               style: TextStyle(
                   fontSize: 14,
                   letterSpacing: 2,
                   color: Colors.white
               ),
             )
         ),
          */
           //Change Email
            const SizedBox(height: 35,),
            Padding(
               padding: const EdgeInsets.symmetric(vertical: 20),
               child:
               Text(
                 "Current Email: ${user!.email}",
                 style: const TextStyle(
                     fontSize: 25,
                     letterSpacing: 2
                 ),
               ),
             ),
            buildTextField("New Email", false, _email),
            ElevatedButton(
               onPressed: () {
                 if (_email.text != "") {
                   setState(() {
                     email = _email.text;
                   });
                   changeEmail();
                   //print(user!.email);
                   //print(_email.text);
                 }
               },
               style: ElevatedButton.styleFrom(
                   foregroundColor: Colors.blue,
                   padding: const EdgeInsets.symmetric(horizontal: 50),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20))
               ),
               child: const Text(
                 "Change Email",
                 style: TextStyle(
                     fontSize: 14,
                     letterSpacing: 2,
                     color: Colors.white
                 ),
               )
           ),

            //Change Password
            const SizedBox(height: 35,),
            const Padding(
               padding: EdgeInsets.symmetric(vertical: 20),
               child: null
           ),
            buildTextField("New Password", true, _password),
            ElevatedButton(
               onPressed: () {
                 if (_password.text != "") {
                   setState(() {
                     password = _password.text;
                   });
                   changePassword();
                   //print(_password.text);
                 }
               },
               style: ElevatedButton.styleFrom(
                   foregroundColor: Colors.blue,
                   padding: const EdgeInsets.symmetric(horizontal: 50),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20))
               ),
               child: const Text(
                 "Change Password",
                 style: TextStyle(
                     fontSize: 14,
                     letterSpacing: 2,
                     color: Colors.white
                 ),
               )
           ),

            const SizedBox(height: 35,),
         ],
        ),
       ),
     ),
    );
  }

  Widget buildTextField(String label, bool isPassword, TextEditingController info){
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child:
      TextField(
        controller: info,
        obscureText: isPassword ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword ? IconButton(
            onPressed: () {
              setState((){
                showPassword = !showPassword;
              });
            },
            icon: const Icon(
              Icons.remove_red_eye,
              color: Colors.grey,
            ),
          ): null,
          contentPadding: const EdgeInsets.only(bottom: 3),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  //Change Password on Firebase
  changePassword() async{
    try{
      await user!.updatePassword(password);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authentication()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password has changed ... Login again"),),);
    }
    catch(e){
      print(e);
    }
  }

  //Change Email on Firebase
  changeEmail() async{
    try{
      await user!.updateEmail(email);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authentication()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email has changed ... Login again"),),);
    }
    catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }
  /*
  String? displayUsername(){
    if(user!.displayName != null){
      return user!.displayName;
    }
    return " ";
  }
  */
}


