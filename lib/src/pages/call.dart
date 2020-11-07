import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName, this.role}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];

  final databaseReference = Firestore.instance;
  String t1 = 'Team A';
  String t2 = 'Team B';
  int p1 = 0;
  int p2 = 0;
  int s1 = 0;
  int s2 = 0;
  final ValueNotifier<int> _counter1 = ValueNotifier<int>(0);
  final ValueNotifier<int> _counter2 = ValueNotifier<int>(0);
  final ValueNotifier<int> _counter3 = ValueNotifier<int>(0);
  final ValueNotifier<int> _counter4 = ValueNotifier<int>(0);

  bool muted = false;
  RtcEngine _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateData();
    getPoint();
    // initialize agora sdk
    initialize();

  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    switch (widget.channelName) {
      case 'Football231':
        await _engine.joinChannel(TokenFootball231, widget.channelName, null, 0);
        break;
      case 'Volleyball231':
        await _engine.joinChannel(TokenVolleyball231, widget.channelName, null, 0);
        break;
      case 'Tennis231':
        await _engine.joinChannel(TokenTennis231, widget.channelName, null, 0);
        break;
      case 'Basketball231':
        await _engine.joinChannel(TokenBasketball231, widget.channelName, null, 0);
        break;
      case 'Cricket231':
        await _engine.joinChannel(TokenCricket231, widget.channelName, null, 0);
        break;
      case 'Rugby231':
        await _engine.joinChannel(TokenRugby231, widget.channelName, null, 0);
        break;
      case 'Badminton231':
        await _engine.joinChannel(TokenBadminton231, widget.channelName, null, 0);
        break;
    }
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    await _engine.switchCamera();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  // Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Text(
              'End Live',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
                fontWeight: FontWeight.bold
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  Widget _mike() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 150),
      child: RawMaterialButton(
        onPressed: _onToggleMute,
        child: Icon(
          muted ? Icons.mic_off : Icons.mic,
          color: muted ? Colors.white : Colors.blueAccent,
          size: 40.0,
        ),
        shape: CircleBorder(),
        elevation: 2.0,
        fillColor: muted ? Colors.blueAccent : Colors.white,
        padding: const EdgeInsets.all(12.0),
      ),
    );
  }

  Widget _pointT(pp1,pp2,ss1,ss2) {
    if (widget.role == ClientRole.Audience) {
      return StreamBuilder(
        stream: Firestore.instance.collection("match").snapshots(),
        builder: (context, snapshot) {
          return Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 4,left: 0,right: 0),
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 0),
                height: 82,
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t1,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.purple.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Points : ',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.pink,
                              ),
                            ),
                            Text(
                              snapshot.data.documents[0]['p1'].toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'sets : ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.purple,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter2,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['s1'].toString(),
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width-250),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t2,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.purple.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Points : ',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.pink,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter3,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['p2'].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'sets : ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.purple,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter4,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['s2'].toString(),
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
    );
        }
      );
    }
    return StreamBuilder(
        stream: Firestore.instance.collection("match").snapshots(),
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 0,left: 0,right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 0),
                height: 180,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t1,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Points : ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter1,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['p1'].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color:Colors.pink,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'sets : ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter2,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['s1'].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () async{
                                await updateP1();
                                _counter1.value=p1;
                              },
                              onLongPress: (){},
                              child: Text(
                                'P+',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.purple,
                              padding: const EdgeInsets.all(12.0),
                            ),
                            RawMaterialButton(
                              onPressed: () async {
                                await updateS1();
                                _counter2.value=s1;
                              },
                              onLongPress: (){},
                              child: Text(
                                'S+',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.purple,
                              padding: const EdgeInsets.all(12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t2,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.purple.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Points : ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter3,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['p2'].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'sets : ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple,
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _counter4,
                              builder: (BuildContext context, int value, Widget child){
                                return Text(
                                  snapshot.data.documents[0]['s2'].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () async {
                                await updateP2();
                                _counter3.value=p2;
                              },
                              onLongPress: (){},
                              child: Text(
                                'P+',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.purple,
                              padding: const EdgeInsets.all(12.0),
                            ),
                            RawMaterialButton(
                              onPressed: () async {
                                await updateS2();
                                _counter4.value=s2;
                              },
                              onLongPress: (){},
                              child: Text(
                                'S+',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.purple,
                              padding: const EdgeInsets.all(12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.only(bottom: 220),
      alignment: Alignment.bottomLeft,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
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
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamesy Live'),
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: Firestore.instance.collection("match").snapshots(),
        builder: (context, snapshot) {

          return Center(
            child: Stack(
              children: <Widget>[
                _viewRows(),
                _panel(),
                _toolbar(),
                _pointT(
                    snapshot.data.documents[0]['p1'],
                    snapshot.data.documents[0]['p2'],
                    snapshot.data.documents[0]['s1'],
                    snapshot.data.documents[0]['s2'],
                ),
                _mike()
              ],
            ),
          );
        }
      ),
    );
  }

  void getPoint() async{
    await databaseReference
        .collection('match')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      t1 = snapshot.documents[0]['t1'];
      t2 = snapshot.documents[0]['t2'];
      p1 = snapshot.documents[0]['p1'];
      p2 = snapshot.documents[0]['p2'];
      s1 = snapshot.documents[0]['s1'];
      s1 = snapshot.documents[0]['s2'];
    });
  }

  @override
  void updateP1() {
    try {
      databaseReference
          .collection('match')
          .document('1')
          .updateData({'p1': p1+=1});

      setState(() async {
        await databaseReference
            .collection('match')
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          p1 = snapshot.documents[0]['p1'];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void updateP2() {
    try {
      databaseReference
          .collection('match')
          .document('1')
          .updateData({'p2': p2+=1});

      setState(() async {
        await databaseReference
            .collection('match')
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          p2 = snapshot.documents[0]['p2'];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void updateS1() {
    try {
      databaseReference
          .collection('match')
          .document('1')
          .updateData({'s1': s1+=1});

      setState(() async {
        await databaseReference
            .collection('match')
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          s1 = snapshot.documents[0]['s1'];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  void updateS2() {
    try {
      databaseReference
          .collection('match')
          .document('1')
          .updateData({'s2': s2+=1});

      setState(() async {
        await databaseReference
            .collection('match')
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          s2 = snapshot.documents[0]['s2'];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void updateData() {
    try {
      databaseReference
          .collection('match')
          .document('1')
          .updateData({'p1':0,'p2':0,'s1':0,'s2':0});
    } catch (e) {
      print(e.toString());
    }
  }

}
