import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:hop_video_player/hop_video_player.dart';

void main(List<String> args) {
  HopVideoPlayer.enableLogs = true;
  runApp(const ListOfVideosApp());
}

class ListOfVideosApp extends StatelessWidget {
  const ListOfVideosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListOfVideosScreen(
        controllers: [
          HopVideoPlayerController(
            playVideoFrom: PlayVideoFrom.youtube(
                'https://www.youtube.com/watch?v=bk6Xst6euQk'),
            hopPlayerConfig: const HopPlayerConfig(autoPlay: false),
          ),
          HopVideoPlayerController(
            playVideoFrom:
                PlayVideoFrom.youtube('https://youtu.be/A3ltMaM6noM'),
            hopPlayerConfig: const HopPlayerConfig(autoPlay: false),
          ),
          HopVideoPlayerController(
            playVideoFrom: PlayVideoFrom.youtube(
                'https://www.youtube.com/watch?v=TjBA6jy4ako'),
            hopPlayerConfig: const HopPlayerConfig(autoPlay: false),
          ),
          HopVideoPlayerController(
            playVideoFrom: PlayVideoFrom.youtube(
                'https://www.youtube.com/watch?v=HqFgRHTuDyc'),
            hopPlayerConfig: const HopPlayerConfig(autoPlay: false),
          ),
          HopVideoPlayerController(
            playVideoFrom: PlayVideoFrom.youtube(
                'https://www.youtube.com/watch?v=GpxD-T060RY'),
            hopPlayerConfig: const HopPlayerConfig(autoPlay: false),
          ),
        ],
      ),
    );
  }
}

class ListOfVideosScreen extends StatelessWidget {
  final List<HopVideoPlayerController> controllers;

  const ListOfVideosScreen({Key? key, required this.controllers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text("Play List of Videos")),
          body: ListView.builder(
            itemCount: controllers.length,
            itemBuilder: (context, index) {
              return VideoViewer(
                controller: controllers[index],
                controllers: controllers,
              );
            },
          )),
    );
  }
}

class VideoViewer extends StatefulWidget {
  final HopVideoPlayerController controller;
  final List<HopVideoPlayerController> controllers;

  const VideoViewer({
    Key? key,
    required this.controller,
    required this.controllers,
  }) : super(key: key);

  @override
  State<VideoViewer> createState() => VideoViewerState();
}

class VideoViewerState extends State<VideoViewer> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.initialise();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: VisibilityDetector(
        key: Key(widget.controller.getTag),
        onVisibilityChanged: (VisibilityInfo info) async {
          // print(widget.controllers.any((element) => element.isVideoPlaying));
          // print(info.visibleFraction);
          if (info.visibleFraction == 1) {
            widget.controller.play();
          } else {
            widget.controller.pause();
          }
        },
        child: HopVideoPlayer(
            controller: widget.controller,
            alwaysShowProgressBar: true,
            overlayBuilder: (options) {
              return Container(
                color: Colors.grey.withOpacity(0.2),
                child: Row(
                  children: [
                    ElevatedButton(
                      child: Text(
                        options.isMute ? 'UnMute' : 'Mute',
                      ),
                      onPressed: () {
                        widget.controller.toggleVolume();
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: Text(
                        options.hopVideoPlayerVideoState == HopVideoPlayerVideoState.paused
                            ? 'Play'
                            : 'Pause',
                      ),
                      onPressed: () {
                        widget.controller.togglePlayPause();
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('Full Screen'),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
