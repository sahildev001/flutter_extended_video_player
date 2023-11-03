import 'package:flutter/material.dart';
import 'package:hop_video_player/hop_video_player.dart';

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
  late final HopVideoPlayerController controller;
  bool isLoading = true;
  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  void loadVideo() async {
    final urls = await HopVideoPlayerController.getYoutubeUrls(
      'https://youtu.be/A3ltMaM6noM',
    );
    setState(() => isLoading = false);
    controller = HopVideoPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
      hopPlayerConfig: const HopPlayerConfig(
        videoQualityPriority: [360],
      ),
    )..initialise();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(child: HopVideoPlayer(controller: controller));
  }
}
