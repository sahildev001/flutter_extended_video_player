
part of 'package:hop_video_player/src/hop_video_player.dart';
class _HopCoreVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;
  final String tag;

  const _HopCoreVideoPlayer({
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    return Builder(
      builder: (ctrx) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode:
              (hopCtr.isFullScreen ? FocusNode() : hopCtr.keyboardFocusWeb) ??
                  FocusNode(),
          onKey: (value) => hopCtr.onKeyBoardEvents(
            event: value,
            appContext: ctrx,
            tag: tag,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: videoAspectRatio,
                  child: VideoPlayer(videoPlayerCtr),
                ),
              ),
              GetBuilder<HopVideoPlayerGetXVideoController>(
                tag: tag,
                id: 'hopVideoPlayerVideoState',
                builder: (_) => GetBuilder<HopVideoPlayerGetXVideoController>(
                  tag: tag,
                  id: 'video-progress',
                  builder: (hopCtr) {
                    if (hopCtr.videoThumbnail == null) {
                      return const SizedBox();
                    }

                    if (hopCtr.hopVideoPlayerVideoState == HopVideoPlayerVideoState.paused &&
                        hopCtr.videoPosition == Duration.zero) {
                      return SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          tween: Tween<double>(begin: 0.7, end: 1),
                          duration: const Duration(milliseconds: 400),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: hopCtr.videoThumbnail,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              _VideoOverlays(tag: tag),
              IgnorePointer(
                child: GetBuilder<HopVideoPlayerGetXVideoController>(
                  tag: tag,
                  id: 'hopVideoPlayerVideoState',
                  builder: (hopCtr) {
                    final loadingWidget = hopCtr.onLoading?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );

                    if (kIsWeb) {
                      switch (hopCtr.hopVideoPlayerVideoState) {
                        case HopVideoPlayerVideoState.loading:
                          return loadingWidget;
                        case HopVideoPlayerVideoState.paused:
                          return const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                        case HopVideoPlayerVideoState.playing:
                          return Center(
                            child: TweenAnimationBuilder<double>(
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              tween: Tween<double>(begin: 1, end: 0),
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.pause,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          );
                        case HopVideoPlayerVideoState.error:
                          return const SizedBox();
                      }
                    } else {
                      if (hopCtr.hopVideoPlayerVideoState == HopVideoPlayerVideoState.loading) {
                        return loadingWidget;
                      }
                      return const SizedBox();
                    }
                  },
                ),
              ),
              if (!kIsWeb)
                GetBuilder<HopVideoPlayerGetXVideoController>(
                  tag: tag,
                  id: 'full-screen',
                  builder: (hopCtr) => hopCtr.isFullScreen
                      ? const SizedBox()
                      : GetBuilder<HopVideoPlayerGetXVideoController>(
                          tag: tag,
                          id: 'overlay',
                          builder: (hopCtr) {
                            var check = hopCtr.isOverlayVisible ||
                                !hopCtr.alwaysShowProgressBar;
                            print("-----sahil --------- check ${check}");
                            return check
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: HopProgressBar(
                                    tag: tag,
                                    alignment: Alignment.bottomCenter,
                                    hopProgressBarConfig:
                                        hopCtr.hopProgressBarConfig,
                                    onDragStart: (Duration duration){
                                      print("sahil 5::------------------------${duration.inSeconds}-----");
                                    },
                                  ),
                                );
      }
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
