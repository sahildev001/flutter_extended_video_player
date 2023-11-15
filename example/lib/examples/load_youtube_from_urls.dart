import 'package:flutter/material.dart';
import 'package:flutter_extended_video_player/flutter_extended_video_player.dart';

void main(List<String> args) {
  runApp(const YoutubeApp());
}

class YoutubeApp extends StatelessWidget {
  const YoutubeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:
            AppBar(title: const Text('Load youtube video from quality urls')),
        body: const YoutubeVideoViewer(),
      ),
    );
  }
}

class YoutubeVideoViewer extends StatefulWidget {
  const YoutubeVideoViewer({Key? key}) : super(key: key);

  @override
  State<YoutubeVideoViewer> createState() => _YoutubeVideoViewerState();
}

class _YoutubeVideoViewerState extends State<YoutubeVideoViewer> {
  late final FlutterExtendedVideoPlayerController controller;
  bool isLoading = true;
  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  void loadVideo() async {
    final urls = await FlutterExtendedVideoPlayerController.getYoutubeUrls(
      'https://youtu.be/A3ltMaM6noM',
    );
    setState(() => isLoading = false);
    controller = FlutterExtendedVideoPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
      flutterExtendedPlayerConfig: const FlutterExtendedPlayerConfig(
        videoQualityPriority: [360],
      ),
    )..initialise();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(child: FlutterExtendedVideoPlayer(controller: controller));
  }
}
