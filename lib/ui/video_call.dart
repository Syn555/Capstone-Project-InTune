import 'dart:async';
import 'package:capstone_project_intune/Helpers/agora_controls.dart';
import 'package:capstone_project_intune/Helpers/utils.dart';
import 'package:capstone_project_intune/ui/live_band.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:capstone_project_intune/Helpers/setting.dart';

import 'package:signal_strength_indicator/signal_strength_indicator.dart';

class video_call extends StatefulWidget{
  final String? channelName;
  final ClientRole? role;
  const video_call({Key? key, this.channelName, this.role}) : super(key: key);
  
  @override
  CallState createState() => CallState();
}

class CallState extends State<video_call>{
  final users = <int> [];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  @override
  void initState(){
    super.initState();
    initialize();
  }
  @override
  void dispose(){
    users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    if (appId.isEmpty){
      setState((){
        _infoStrings.add(
          'App ID is missing, please provide app ID in setting.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    //! _addAgoraRtcEngine
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);
    //! _addAgoraEventHandlers
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920,height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine;
    await _engine.joinChannel(token, widget.channelName!, null, 0);
  }

  void _addAgoraEventHandlers(){
    _engine.setEventHandler(RtcEngineEventHandler(error: (code){
      setState((){
        final info = 'Error: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapse) {
      setState(() {
        final info = 'Join Channel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState((){
        _infoStrings.add('Leave Channel');
        users.clear();
      });
    }, userJoined:(uid, elapsed){
      setState((){
        final info = 'User Joined: $uid';
        _infoStrings.add(info);
        users.add(uid);
      });
    }, userOffline:(uid, elapsed) {
      setState(() {
        final info = 'User Offline: $uid';
        _infoStrings.add(info);
        users.remove(uid);
    });
    }, firstRemoteVideoFrame: (uid, width, height, elapse){
      setState(() {
        final info = 'First Remote Video: $uid ${width}x $height';
        _infoStrings.add(info);
      });
  }));
  }

  Widget _viewRows(){
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster){
      list.add(const rtc_local_view.SurfaceView());
    }
    for (var uid in users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: uid, channelId: widget.channelName!,
      ));
    }
    final views = list;
    return Column(
      children: List.generate(
        views.length,
          (index) => Expanded(
            child: views[index]
          ),
      ),
    );
  }

  Widget _toolbar(){
    //if (widget.role == ClientRole.Audience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical:48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: (){
              setState((){
                muted = !muted;
              });
              _engine.muteLocalAudioStream(muted);
            },
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: (){
              _engine.switchCamera();
            },
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
              ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  Widget _panel(){
    return Visibility(
      visible: viewPanel,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
              reverse: true,
              itemCount: _infoStrings.length,
              itemBuilder: (BuildContext context, int index) {
                if (_infoStrings.isEmpty){
                  return const Text("Null");
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical:3,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                          ),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(5),
                         ),
                            child: Text(
                              _infoStrings[index],
                              style: const TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Call"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: (){
                setState((){
                  viewPanel = !viewPanel;
                });
              },
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _panel(),
              _toolbar(),
            ]),
          ),
      );
  }
}

// class VideoCallScreen extends StatefulWidget {
//   final String channelName;
//
//   VideoCallScreen({required this.channelName});
//   @override
//   VideoCallScreenState createState() => VideoCallScreenState();
// }
//
// class VideoCallScreenState extends State<VideoCallScreen> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];
//   late RtcEngine AgoraRtcEngine;
//
//   // UserJoined Bool
//   bool isSomeOneJoinedCall = false;
//   final AgoraController agoraController = Get.put(AgoraController());
//
//   int networkQuality = 3;
//   Color networkQualityBarColor = Colors.green;
//
//   @override
//   void setState(fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }
//
//   @override
//   void dispose() {
//     print("\n============ ON DISPOSE ===============\n");
//     super.dispose();
//
//     if (agoraController.meetingTimer != null) {
//       agoraController.meetingTimer.cancel();
//     }
//
//     // clear users
//     _users.clear();
//
//     // destroy Agora sdk
//     AgoraRtcEngine.leaveChannel();
//     AgoraRtcEngine.destroy();
//   }
//
//   @override
//   void initState() {
//     // initialize agora sdk
//     initAgoraRTC();
//
//     super.initState();
//   }
//
//   Future<void> initAgoraRTC() async {
//     if (getAgoraAppId().isEmpty) {
//       Get.snackbar("", "Agora APP_ID Is Not Valid");
//       return;
//     }
//
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await AgoraRtcEngine.enableWebSdkInteroperability(true);
//
//     await AgoraRtcEngine.setParameters(
//         '''{\"che.video.lowBitRateStreamParameter\":{\"width\":640,\"height\":360,\"frameRate\":30,\"bitRate\":800}}''');
//     await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
//   }
//
//   Future<void> _initAgoraRtcEngine() async {
//     await AgoraRtcEngine.create(getAgoraAppId());
//     await AgoraRtcEngine.enableVideo();
//   }
//
//   /// agora event handlers
//   void _addAgoraEventHandlers() {
//     AgoraRtcEngine.onError = (dynamic code) {
//       print("======== AGORA ERROR  : ======= " + code.toString());
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     };
//     AgoraRtcEngine.onUserOffline = (int uid, int reason) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     };
//
//     AgoraRtcEngine.onJoinChannelSuccess =
//         (String channel, int uid, int elapsed) {
//       setState(() {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//       });
//     };
//
//     AgoraRtcEngine.onLeaveChannel = () {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     };
//
//     AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
//       print("======================================");
//       print("             User Joined              ");
//       print("======================================");
//       if (agoraController.meetingTimer != null) {
//         if (!agoraController.meetingTimer.isActive) {
//           agoraController.startMeetingTimer();
//         }
//       } else {
//         agoraController.startMeetingTimer();
//       }
//
//       isSomeOneJoinedCall = true;
//
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//       });
//     };
//     AgoraRtcEngine.onNetworkQuality = (int uid, int txQuality, int rxQuality) {
//       setState(() {
//         networkQuality = getNetworkQuality(txQuality);
//         networkQualityBarColor = getNetworkQualityBarColor(txQuality);
//       });
//     };
//     AgoraRtcEngine.onFirstRemoteVideoFrame =
//         (int uid, int width, int height, int elapsed) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     };
//     AgoraRtcEngine.onUserMuteAudio = (int uid, bool muted) {};
//   }
//
//   List<Widget> _getRenderViews() {
//     final List<AgoraRenderWidget> list = [
//       AgoraRenderWidget(0, local: true, preview: true),
//     ];
//     _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//     return list;
//   }
//
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//    }
//
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   Widget buildJoinUserUI() {
//     final views = _getRenderViews();
//
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//               children: <Widget>[_videoView(views[0])],
//             ));
//       case 2:
//         return new Container(
//             width: Get.width,
//             height: Get.height,
//             child: new Stack(
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Column(
//                     children: <Widget>[
//                       _expandedVideoRow([views[1]]),
//                     ],
//                   ),
//                 ),
//                 Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             width: 8,
//                             color: Colors.white38,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         margin: const EdgeInsets.fromLTRB(15, 40, 10, 15),
//                         width: 110,
//                         height: 140,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             _expandedVideoRow([views[0]]),
//                           ],
//                         )))
//               ],
//             ));
//       case 3:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow(views.sublist(0, 2)),
//                 _expandedVideoRow(views.sublist(2, 3))
//               ],
//             ));
//       case 4:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow(views.sublist(0, 2)),
//                 _expandedVideoRow(views.sublist(2, 4))
//               ],
//             ));
//       default:
//     }
//     return Container();
//   }
//
//   void onCallEnd(BuildContext context) async {
//     if (agoraController.meetingTimer != null) {
//       if (agoraController.meetingTimer.isActive) {
//         agoraController.meetingTimer.cancel();
//       }
//     }
//
//     if (isSomeOneJoinedCall) {
//       Future.delayed(Duration(milliseconds: 300), () {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => live_band()));
//       });
//     } else {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: Text("Note"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                   "No one has not joined this call yet,\nDo You want to close this room?"),
//             ],
//           ),
//           actions: <Widget>[
//             FloatingActionButton(
//               child: Text("Yes"),
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) => live_band()));
//               },
//             ),
//             FloatingActionButton(
//               child: Text("No"),
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//               },
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         return new Future(() => false);
//       },
//       child: Scaffold(
//         body: buildNormalVideoUI(),
//         bottomNavigationBar: GetBuilder<AgoraController>(builder: (_) {
//           return ConvexAppBar(
//             style: TabStyle.fixedCircle,
//             backgroundColor: const Color(0xFF1A1E78),
//             color: Colors.white,
//             items: [
//               TabItem(
//                 icon: _.muted ? Icons.mic_off_outlined : Icons.mic_outlined,
//               ),
//               TabItem(
//                 icon: Icons.call_end_rounded,
//               ),
//               TabItem(
//                 icon: _.muteVideo
//                     ? Icons.videocam_off_outlined
//                     : Icons.videocam_outlined,
//               ),
//             ],
//             initialActiveIndex: 2, //optional, default as 0
//             onTap: (int i) {
//               switch (i) {
//                 case 0:
//                   _.onToggleMuteAudio();
//                   break;
//                 case 1:
//                   onCallEnd(context);
//                   break;
//                 case 2:
//                   _.onToggleMuteVideo();
//                   break;
//               }
//             },
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget buildNormalVideoUI() {
//     return Container(
//       height: Get.height,
//       child: Stack(
//         children: <Widget>[
//           buildJoinUserUI(),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               margin: const EdgeInsets.only(left: 10, top: 30),
//               child: FloatingActionButton(
//                 // minWidth: 40,
//                 // height: 50,
//                 onPressed: () {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => live_band()));
//                 },
//                 child: Icon(
//                   Icons.arrow_back_outlined,
//                   color: Colors.white,
//                   size: 24.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6)),
//                 //color: Colors.white38,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Container(
//               margin: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                   color: Colors.white30,
//                   borderRadius: BorderRadius.circular(6)),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SignalStrengthIndicator.bars(
//                     value: networkQuality,
//                     size: 18,
//                     barCount: 4,
//                     spacing: 0.3,
//                     maxValue: 4,
//                     activeColor: networkQualityBarColor,
//                     inactiveColor: Colors.white,
//                     radius: Radius.circular(8),
//                     minValue: 0,
//                   ),
//                   const SizedBox(
//                     width: 8,
//                   ),
//                   Obx(() {
//                     return Text(
//                       agoraController.meetingDurationTxt.value,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                         shadows: <Shadow>[
//                           Shadow(
//                             offset: Offset(1.0, 2.0),
//                             blurRadius: 2.0,
//                             color: Color.fromARGB(255, 0, 0, 0),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//           Align(
//               alignment: Alignment.bottomRight,
//               child: GetBuilder<AgoraController>(builder: (_) {
//                 return Container(
//                   margin: const EdgeInsets.only(right: 10, bottom: 4),
//                   child: RawMaterialButton(
//                     onPressed: _.onSwitchCamera,
//                     child: Icon(
//                       _.backCamera ? Icons.camera_rear : Icons.camera_front,
//                       color: Colors.white,
//                       size: 24.0,
//                     ),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6)),
//                     fillColor: Colors.white38,
//                   ),
//                 );
//               })),
//         ],
//       ),
//     );
//   }
//
//   void addLogToList(String info) {
//     print(info);
//     setState(() {
//       _infoStrings.insert(0, info);
//     });
//   }
//
//   int getNetworkQuality(int txQuality) {
//     switch (txQuality) {
//       case 0:
//         return 2;
//         break;
//       case 1:
//         return 4;
//         break;
//       case 2:
//         return 3;
//         break;
//       case 3:
//         return 2;
//         break;
//       case 4:
//         return 1;
//         break;
//       case 4:
//         return 0;
//         break;
//     }
//     return 0;
//   }
//
//   Color getNetworkQualityBarColor(int txQuality) {
//     switch (txQuality) {
//       case 0:
//         return Colors.green;
//         break;
//       case 1:
//         return Colors.green;
//         break;
//       case 2:
//         return Colors.yellow;
//         break;
//       case 3:
//         return Colors.redAccent;
//         break;
//       case 4:
//         return Colors.red;
//         break;
//       case 4:
//         return Colors.red;
//         break;
//     }
//     return Colors.yellow;
//   }
//}