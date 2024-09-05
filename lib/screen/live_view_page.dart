/*
import 'package:flutter/material.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import '../constants/setting_screen.dart';  // SettingsScreen을 임포트
import '../types/params.dart';  // Params를 임포트

class LiveViewPage extends StatefulWidget {
  const LiveViewPage({Key? key}) : super(key: key);

  @override
  _LiveViewPageState createState() => _LiveViewPageState();
}

class _LiveViewPageState extends State<LiveViewPage> with WidgetsBindingObserver {
  Params config = Params();  // Params 초기화
  late final LiveStreamController _controller;
  late final Future<int> textureId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = LiveStreamController();
    textureId = _controller.create(
      initialAudioConfig: config.audio,
      initialVideoConfig: config.video,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _onMenuSelected(String choice, BuildContext context) {
    if (choice == 'Settings') {
      _openSettingsScreen(context);
    }
  }

  void _openSettingsScreen(BuildContext context) async {
    // SettingsScreen 열기
    final updatedParams = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(params: config), // Params 전달
      ),
    );

    if (updatedParams != null) {
      setState(() {
        config = updatedParams;
        _controller.setVideoConfig(config.video);
        _controller.setAudioConfig(config.audio);
      });
    }
  }

  void _startStreaming() {
    _controller.startStreaming(
      streamKey: config.streamKey,
      url: config.rtmpUrl,
    );
  }

  void _stopStreaming() {
    _controller.stopStreaming();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream Example'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (choice) => _onMenuSelected(choice, context),
            itemBuilder: (BuildContext context) {
              return ['Settings'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: FutureBuilder<int>(
                    future: textureId,
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return CameraPreview(controller: _controller);
                      }
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _startStreaming,
                  child: Text('Start Streaming'),
                ),
                ElevatedButton(
                  onPressed: _stopStreaming,
                  child: Text('Stop Streaming'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/