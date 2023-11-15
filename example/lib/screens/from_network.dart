import 'package:flutter_extended_video_player/flutter_extended_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlayVideoFromNetwork extends StatefulWidget {
  const PlayVideoFromNetwork({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<PlayVideoFromNetwork> {
  late final FlutterExtendedVideoPlayerController controller;
  final videoTextFieldCtr = TextEditingController();

  @override
  void initState() {
    controller = FlutterExtendedVideoPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
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
      appBar: AppBar(title: const Text('Play video from Netwok')),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              FlutterExtendedVideoPlayer(
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
              const SizedBox(height: 40),
              _loadVideoFromUrl()
            ],
          ),
        ),
      ),
    );
  }

  Row _loadVideoFromUrl() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: videoTextFieldCtr,
            decoration: const InputDecoration(
              labelText: 'Enter video url',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText:
                  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FocusScope(
          canRequestFocus: false,
          child: ElevatedButton(
            onPressed: () async {
              if (videoTextFieldCtr.text.isEmpty) {
                snackBar('Please enter the url');
                return;
              }
              try {
                snackBar('Loading....');
                FocusScope.of(context).unfocus();
                await controller.changeVideo(
                  playVideoFrom: PlayVideoFrom.network(videoTextFieldCtr.text),
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } catch (e) {
                snackBar('Unable to load,\n $e');
              }
            },
            child: const Text('Load Video'),
          ),
        ),
      ],
    );
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
  }
}
