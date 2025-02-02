import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:streamzlive/provider/userprovider.dart';
import 'package:streamzlive/resources/firestore_methods.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/secrets/agora_ids.dart';

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
  String baseUrl = "https://twitch-tutorial-server.herokuapp.com";
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
    await _engine.startPreview();
    _addListeners();

    if (widget.isBroadcaster) {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }

    _joinChannel();
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
      ),
    );
  }

  Future<void> _joinChannel() async {
    final currentUid =
        Provider.of<UserProvider>(context, listen: false).user.userId;

    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();

      //! Using temp token for now
      await _engine.joinChannelWithUserAccount(
        token: agora_temp_token,
        channelId: agora_temp_channelName, //! Using temp token's ChannelID
        userAccount: currentUid,
      );
    }
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
    //todo : replace onPopInvoked with updated function
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
            children: [_renderVideo(widget.channelId, remoteUid)],
          ),
        ),
      ),
    );
  }

  Widget _renderVideo(String channelId, List<int> remoteUid) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: '${user.userId}_${user.username}' == widget.channelId &&
              remoteUid.isNotEmpty
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: remoteUid.first),
                connection: RtcConnection(channelId: widget.channelId),
              ),
            )
          : AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            ),
    );
  }
}
