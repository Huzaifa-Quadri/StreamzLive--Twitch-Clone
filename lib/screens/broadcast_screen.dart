import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:streamzlive/provider/userprovider.dart';
import 'package:streamzlive/resources/firestore_methods.dart';
import 'package:streamzlive/screens/chat.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/secrets/agora_ids.dart';
import 'package:http/http.dart' as http;

class BroadcastScreen extends StatefulWidget {
  static String routename = './broadcast';
  const BroadcastScreen(
      {super.key, required this.channelId, required this.isBroadcaster});

  final String channelId;
  final bool isBroadcaster;

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  String baseUrl = "https://agoratokenserver-production-1528.up.railway.app";
  String? token;
  final FirestoreMethods _firestorefunc = FirestoreMethods();

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: app_id,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.enableVideo();
    if (widget.isBroadcaster) {
      await _engine.startPreview();
    }
    _addListeners();

    if (widget.isBroadcaster) {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }

    _joinChannel();
  }

  Future<void> getToken() async {
    final currentUid =
        Provider.of<UserProvider>(context, listen: false).user.userId;
    // String role = widget.isBroadcaster ? 'broadcaster' : 'audience';
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/rtc/${widget.channelId}/publisher/userAccount/$currentUid/'),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        token = data["rtcToken"];
      } else {
        debugPrint("Failed to fetch Agora token: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching token: $e");
    }
  }

  void _addListeners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('\nJoined channel Success: ${connection.channelId}\n');
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint('\nUser joined: $remoteUid\n');
          setState(() {
            remoteUid.add(uid);
          });
        },
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          debugPrint(
              '\nUser offline: $remoteUid, because of Reason : $reason\n');
          setState(() {
            remoteUid.remove(uid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint('Left channel - $stats');
          setState(() {
            remoteUid.clear();
          });
        },
        onTokenPrivilegeWillExpire:
            (RtcConnection connection, String token) async {
          await getToken();
          await _engine.renewToken(token);
        },
      ),
    );
  }

  Future<void> _joinChannel() async {
    final currentUid =
        Provider.of<UserProvider>(context, listen: false).user.userId;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await getToken();

    await _engine.joinChannelWithUserAccount(
      // token: agora_temp_token,             //prevously Used temp token for stream
      // channelId: agora_temp_channelName,   // prevously Used temp token's ChannelID
      token: token!,
      channelId: widget.channelId,
      userAccount: currentUid,
    );
  }

  void _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  void onToggleMute() async {
    await _engine.muteLocalAudioStream(!isMuted);
    setState(() {
      isMuted = !isMuted;
    });
  }

  Future<void> _leaveChannel() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    await _engine.leaveChannel();
    bool res = '${user.userId}_${user.username}' == widget.channelId;
    // print('Trying to turn off Stream : $res');
    if (res) {
      // print('About to leave !!!!');

      await _firestorefunc.endLiveStream(widget.channelId);
    } else {
      await _firestorefunc.updateViewCount(widget.channelId, false);
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, HomeScreen.routename);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return PopScope(
      canPop: false, // Prevent default back button behavior
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          await _leaveChannel(); // Call the function here
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _renderVideo(widget.channelId, remoteUid),
              if ('${user.userId}_${user.username}' == widget.channelId)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _switchCamera,
                      child: const Text('Switch Camera'),
                    ),
                    InkWell(
                      onTap: onToggleMute,
                      child: Text(isMuted ? 'Unmute' : 'Mute'),
                    ),
                  ],
                ),
              Expanded(
                child: ChatScreen(
                  channelId: widget.channelId,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderVideo(String channelId, List<int> remoteUid) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    // return AspectRatio(
    //   aspectRatio: 16 / 9,
    //   child: '${user.userId}_${user.username}' == widget.channelId &&
    //           remoteUid.isNotEmpty
    //       ? AgoraVideoView(
    //           controller: VideoViewController.remote(
    //             rtcEngine: _engine,
    //             canvas: VideoCanvas(uid: remoteUid.first),
    //             connection: RtcConnection(channelId: widget.channelId),
    //           ),
    //         )
    //       : AgoraVideoView(
    //           controller: VideoViewController(
    //             rtcEngine: _engine,
    //             canvas: const VideoCanvas(uid: 0),
    //           ),
    //         ),
    // );
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: widget.isBroadcaster
          ? // Only show local preview if broadcaster
          AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas:
                    const VideoCanvas(uid: 0), // Local preview for broadcaster
              ),
            )
          : // Show remote video for audience
          remoteUid.isNotEmpty
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: remoteUid.first),
                    connection: RtcConnection(channelId: widget.channelId),
                  ),
                )
              : const SizedBox(), // Empty widget if no remote video
    );
  }
}
