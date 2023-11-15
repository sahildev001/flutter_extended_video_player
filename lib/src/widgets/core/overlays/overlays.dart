part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

class _VideoOverlays extends StatelessWidget {
  final String tag;

  const _VideoOverlays({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    if (flutterExtendedCtr.overlayBuilder != null) {
      return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
        id: 'update-all',
        tag: tag,
        builder: (flutterExtendedCtr) {
          ///Custom overlay
          final progressBar = FlutterExtendedProgressBar(
            tag: tag,
            flutterExtendedProgressBarConfig: flutterExtendedCtr.flutterExtendedProgressBarConfig,
            onDragStart: (Duration duration){
              print("sahil 3::------------------------${duration.inSeconds}-----");
            },
          );
          final overlayOptions = OverLayOptions(
            flutterExtendedVideoPlayerVideoState: flutterExtendedCtr.flutterExtendedVideoPlayerVideoState,
            videoDuration: flutterExtendedCtr.videoDuration,
            videoPosition: flutterExtendedCtr.videoPosition,
            isFullScreen: flutterExtendedCtr.isFullScreen,
            isLooping: flutterExtendedCtr.isLooping,
            isOverlayVisible: flutterExtendedCtr.isOverlayVisible,
            isMute: flutterExtendedCtr.isMute,
            autoPlay: flutterExtendedCtr.autoPlay,
            currentVideoPlaybackSpeed: flutterExtendedCtr.currentPaybackSpeed,
            videoPlayBackSpeeds: flutterExtendedCtr.videoPlaybackSpeeds,
            videoPlayerType: flutterExtendedCtr.videoPlayerType,
            flutterExtendedProgresssBar: progressBar,
          );

          /// Returns the custom overlay, otherwise returns the default
          /// overlay with gesture detector
          return flutterExtendedCtr.overlayBuilder!(overlayOptions);
        },
      );
    } else {
      ///Built in overlay
      return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
        tag: tag,
        id: 'overlay',
        builder: (flutterExtendedCtr) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: flutterExtendedCtr.isOverlayVisible ? 1 : 0,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                if (!kIsWeb) _MobileOverlay(tag: tag),
                if (kIsWeb) _WebOverlay(tag: tag),
              ],
            ),
          );
        },
      );
    }
  }
}
