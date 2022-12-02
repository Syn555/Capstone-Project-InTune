import 'package:capstone_project_intune/ui/rooms/create_room.dart';
import 'package:capstone_project_intune/ui/rooms/join_room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'video_call.dart';

class live_band extends StatefulWidget{
  const live_band({Key? key}) : super (key: key);

  @override
  State<StatefulWidget> createState() => BandState();
}

class BandState extends State<live_band>{
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose(){
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Band'), centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText:
                    _validateError ? 'Channel id is mandatory' : null,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide (width: 1),
                  ),
                  hintText: 'Channel name',
                ),
                ),
                RadioListTile(
                  title: const Text('Host'),
                  onChanged: (ClientRole? value){
                    setState((){
                      _role = value;
                  });
                },
                value: ClientRole.Broadcaster,
                groupValue: _role,
              ),
              RadioListTile(
                title: const Text('Guest'),
                onChanged: (ClientRole? value){
                  setState((){
                    _role = value;
                  });
                },
                value: ClientRole.Audience,
                groupValue: _role,
              ),
              ElevatedButton(
                onPressed: onJoin,
                child: const Text('Join'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async{
    setState(() {
      _channelController.text.isNotEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if(_channelController.text.isNotEmpty){
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context,
          MaterialPageRoute(
          builder: (context) => video_call(
            channelName: _channelController.text, role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}

// class live_band extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1E78),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 60, left: 30),
//             padding: const EdgeInsets.only(
//               right: 20,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Live Band",
//                   style:const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(
//                 top: 30,
//               ),
//               padding: const EdgeInsets.only(
//                 top: 30,
//               ),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25))),
//               child: Center(
//                   child: Column(
//                     children: [
//                       Flexible(
//                         flex: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 10),
//                           child: FloatingActionButton(
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (_) {
//                                     return CreateRoom();
//                                   });
//                             },
//                             child: Row(
//                               children: [
//                                 Flexible(
//                                   flex: 4,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         "Create Room",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         "Create a room and ask others to join the same.",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Flexible(
//                         flex: 2,
//                         child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 2,
//                             margin: const EdgeInsets.all(20),
//                             color: const Color(0xFF1A1E78)),
//                       ),
//                       Flexible(
//                         flex: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 10),
//                           child: FloatingActionButton(
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (_) {
//                                     return JoinRoom();
//                                   });
//                             },
//                             child: Row(
//                               children: [
//                                 Flexible(
//                                   flex: 4,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         "Join Room",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         "Join a room created by your friend.",
//                                         style: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }