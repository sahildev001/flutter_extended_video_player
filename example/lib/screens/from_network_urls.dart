import 'package:flutter_extended_video_player/flutter_extended_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlayVideoFromNetworkQualityUrls extends StatefulWidget {
  const PlayVideoFromNetworkQualityUrls({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromNetworkQualityUrls> createState() =>
      _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<PlayVideoFromNetworkQualityUrls> {
  late final FlutterExtendedVideoPlayerController controller;
  @override
  void initState() {
    controller = FlutterExtendedVideoPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(
        videoUrls: [
          VideoQalityUrls(
            quality: 360,
            url:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
          ),
          VideoQalityUrls(
            quality: 720,
            url:
                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          ),
        ],
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play video from Quality urls')),
      body: SafeArea(
        child: Center(
          child: FlutterExtendedVideoPlayer(
            controller: controller,
            flutterExtendedProgressBarConfig: const FlutterExtendedProgressBarConfig(
              padding: kIsWeb
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
              playingBarColor: Colors.blue,
              circleHandlerColor: Colors.blue,
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
