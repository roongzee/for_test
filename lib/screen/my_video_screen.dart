//my_video_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyVideosScreen extends StatefulWidget {
  @override
  _MyVideosScreenState createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  List<String> _uploadedVideos = [];
  List<String> _processedVideos = [];

  @override
  void initState() {
    super.initState();
    _loadProcessedVideos();
  }

  Future<void> _loadProcessedVideos() async {
    // Django에서 다운로드된 비디오를 로드합니다.
    final Directory appDir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = appDir.listSync();
    _processedVideos = files
        .where((file) => file.path.endsWith('.mp4'))
        .map((file) => file.path)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildVideoSection('Uploaded Videos', _uploadedVideos),
          Divider(),
          _buildVideoSection('Processed Videos', _processedVideos), // 처리된 비디오 섹션
        ],
      ),
    );
  }

  Widget _buildVideoSection(String title, List<String> videos) {
    return ExpansionTile(
      title: Text(title),
      children: videos.map((videoPath) => _buildVideoTile(videoPath)).toList(),
    );
  }

  Widget _buildVideoTile(String videoPath) {
    return ListTile(
      leading: Icon(Icons.play_circle_fill),
      title: Text(videoPath.split('/').last),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoPath: videoPath),
          ),
        );
      },
    );
  }
}

// 비디오 플레이어 화면
class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
