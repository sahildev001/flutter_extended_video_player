import 'package:flutter/material.dart';
import 'package:flutter_extended_video_player/flutter_extended_video_player.dart';

void main(List<String> args) {
  FlutterExtendedVideoPlayer.enableLogs = true;
  runApp(const ListOfVideosApp());
}

class ListOfVideosApp extends StatelessWidget {
  const ListOfVideosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Play List of Videos")),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    child: const Text('List of Asset videos'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListOfVideosScreen(
                          videosList: [
                            PlayVideoFrom.asset(
                                'assets/SampleVideo_720x480_20mb.mp4'),
                            PlayVideoFrom.asset(
                                'assets/SampleVideo_720x480_20mb.mp4'),
                            PlayVideoFrom.asset(
                                'assets/SampleVideo_720x480_20mb.mp4'),
                            PlayVideoFrom.asset(
                                'assets/SampleVideo_720x480_20mb.mp4'),
                            PlayVideoFrom.asset(
                                'assets/SampleVideo_720x480_20mb.mp4'),
                          ],
                        ),
                      ));
                    }),
                ElevatedButton(
                    child: const Text('List of Network videos'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListOfVideosScreen(
                          videosList: [
                            PlayVideoFrom.network(
                                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
                            PlayVideoFrom.network(
                                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
                            PlayVideoFrom.network(
                                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                            PlayVideoFrom.network(
                                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
                            PlayVideoFrom.network(
                                'http://techslides.com/demos/sample-videos/small.mp4'),
                            PlayVideoFrom.network(
                                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
                            PlayVideoFrom.network(
                                'http://techslides.com/demos/sample-videos/small.mp4'),
                            PlayVideoFrom.network(
                                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
                            PlayVideoFrom.network(
                                'http://techslides.com/demos/sample-videos/small.mp4'),
                            PlayVideoFrom.network(
                                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
                            PlayVideoFrom.network(
                                'http://techslides.com/demos/sample-videos/small.mp4'),
                          ],
                        ),
                      ));
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ListOfVideosScreen extends StatelessWidget {
  final List<PlayVideoFrom> videosList;
  const ListOfVideosScreen({Key? key, required this.videosList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Play List of Videos")),
        body: ListOfVideosViewer(
          videosList: videosList,
        ),
      ),
    );
  }
}

class ListOfVideosViewer extends StatefulWidget {
  final List<PlayVideoFrom> videosList;
  const ListOfVideosViewer({Key? key, required this.videosList})
      : super(key: key);

  @override
  State<ListOfVideosViewer> createState() => _ListOfVideosViewerState();
}

class _ListOfVideosViewerState extends State<ListOfVideosViewer> {
  List<FlutterExtendedVideoPlayerController> controllers = [];

  @override
  void initState() {
    widget.videosList.forEach(initListOfVideos);
    super.initState();
  }

  void initListOfVideos(PlayVideoFrom playVideoFrom) {
    //* lazily Initialise
    controllers.add(
      FlutterExtendedVideoPlayerController(
        playVideoFrom: playVideoFrom,
        flutterExtendedPlayerConfig: const FlutterExtendedPlayerConfig(autoPlay: false),
      ),
    );


  }

  @override
  void dispose() {
    controllers.forEach(_disposeCtr);
    super.dispose();
  }

  void _disposeCtr(FlutterExtendedVideoPlayerController ctr) => ctr.dispose();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        //Initialize lazily
        controllers[index].initialise();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: FlutterExtendedVideoPlayer(controller: controllers[index]),
        );
      },
    );
  }
}
