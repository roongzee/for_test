//action_select_screen.dart
import 'package:flutter/material.dart';
import 'upload_video_screen.dart';  // 업로드 비디오 화면 임포트
import 'live_stream_screen.dart';  // 라이브 스트리밍 화면 임포트

class ActionSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Action'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // LiveStreamScreen을 LiveViewPage로 변경
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LiveViewPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Start Live Stream', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadVideoScreen(
                      onVideoUploaded: (video) {
                        // 업로드된 비디오를 처리하는 로직
                        Navigator.pop(context, video);
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Upload Video', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
