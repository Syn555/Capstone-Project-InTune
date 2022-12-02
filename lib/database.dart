import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Database extends StatefulWidget{
  const Database({super.key});

  @override
  _Database createState() => _Database();
}
class _Database extends State<Database> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: TextField(controller: controller),
       actions: [
         IconButton(
             onPressed: (){
               final name = controller.text;
               createUser(name: name);
             },
             icon: Icon(Icons.add))
       ],

     ),
     body: Text("Text"),
   );
  }

  Future createUser({required String name}) async{
    final docUser = FirebaseFirestore.instance.collection("SAMPLE").doc("roomID");
    await docUser.set({"records": false});
    docUser.collection("users").doc(name).set({"time": 60});

  }

}
