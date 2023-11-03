part of 'package:hop_video_player/src/hop_video_player.dart';

class _VideoOverlays extends StatelessWidget {
  final String tag;

  const _VideoOverlays({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    if (hopCtr.overlayBuilder != null) {
      return GetBuilder<HopVideoPlayerGetXVideoController>(
        id: 'update-all',
        tag: tag,
        builder: (hopCtr) {
          ///Custom overlay
          final progressBar = HopProgressBar(
            tag: tag,
            hopProgressBarConfig: hopCtr.hopProgressBarConfig,
            onDragStart: (Duration duration){
              print("sahil 3::------------------------${duration.inSeconds}-----");
            },
          );
          final overlayOptions = OverLayOptions(
            hopVideoPlayerVideoState: hopCtr.hopVideoPlayerVideoState,
            videoDuration: hopCtr.videoDuration,
            videoPosition: hopCtr.videoPosition,
            isFullScreen: hopCtr.isFullScreen,
            isLooping: hopCtr.isLooping,
            isOverlayVisible: hopCtr.isOverlayVisible,
            isMute: hopCtr.isMute,
            autoPlay: hopCtr.autoPlay,
            currentVideoPlaybackSpeed: hopCtr.currentPaybackSpeed,
            videoPlayBackSpeeds: hopCtr.videoPlaybackSpeeds,
            videoPlayerType: hopCtr.videoPlayerType,
            hopProgresssBar: progressBar,
          );

          /// Returns the custom overlay, otherwise returns the default
          /// overlay with gesture detector
          return hopCtr.overlayBuilder!(overlayOptions);
        },
      );
    } else {
      ///Built in overlay
      return GetBuilder<HopVideoPlayerGetXVideoController>(
        tag: tag,
        id: 'overlay',
        builder: (hopCtr) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: hopCtr.isOverlayVisible ? 1 : 0,
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
