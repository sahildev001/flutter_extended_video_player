import 'package:flutter/material.dart';
import 'package:hop_video_player/hop_video_player.dart';

void main(List<String> args) {
  runApp(const VimeoApp());
}

class VimeoApp extends StatelessWidget {
  const VimeoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Load vimeo video from quality urls')),
        body: const VimeoVideoViewer(),
      ),
    );
  }
}

class VimeoVideoViewer extends StatefulWidget {
  const VimeoVideoViewer({Key? key}) : super(key: key);

  @override
  State<VimeoVideoViewer> createState() => VimeoVideoViewerState();
}

class VimeoVideoViewerState extends State<VimeoVideoViewer> {
  late final HopVideoPlayerController controller;
  bool isLoading = true;
  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  void loadVideo() async {
    final urls = await HopVideoPlayerController.getVimeoUrls('518228118');
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
