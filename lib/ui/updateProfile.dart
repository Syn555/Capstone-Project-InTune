import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget{
  const UpdateProfile({super.key});

  @override
  _UpdateProfile createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateProfile> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const SideDrawerReg(),
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
         children: [
           const SizedBox(
             height: 35,
           ),

           buildTextField("Change Username", false),
           buildTextField("Change Email", false),
           buildTextField("Change Password", true),

           const SizedBox(
             height: 35,
           ),

           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children:[
               OutlinedButton(
                 onPressed: (){},
                 style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(horizontal: 50),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                 ),
                 child: const Text(
                     "Cancel",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2,
                        color: Colors.black
                      ),
                 )
              ),
             ElevatedButton(
                 onPressed: (){},
                 style: ElevatedButton.styleFrom(
                     foregroundColor: Colors.blue,
                     padding: const EdgeInsets.symmetric(horizontal: 50),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                 ),
                 child: const Text(
                   "Save",
                   style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2,
                    color: Colors.white
                   ),
                 )
             ),
           ])],
        ),
       ),
     ),
    );
  }

  Widget buildTextField(String label, bool isPassword){
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: TextField(
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
}