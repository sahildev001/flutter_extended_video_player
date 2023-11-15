
part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';
class _FlutterExtendedCoreVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;
  final String tag;

  const _FlutterExtendedCoreVideoPlayer({
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    return Builder(
      builder: (ctrx) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode:
              (flutterExtendedCtr.isFullScreen ? FocusNode() : flutterExtendedCtr.keyboardFocusWeb) ??
                  FocusNode(),
          onKey: (value) => flutterExtendedCtr.onKeyBoardEvents(
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
              GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                tag: tag,
                id: 'flutterExtendedVideoPlayerVideoState',
                builder: (_) => GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                  tag: tag,
                  id: 'video-progress',
                  builder: (flutterExtendedCtr) {
                    if (flutterExtendedCtr.videoThumbnail == null) {
                      return const SizedBox();
                    }

                    if (flutterExtendedCtr.flutterExtendedVideoPlayerVideoState == FlutterExtendedVideoPlayerVideoState.paused &&
                        flutterExtendedCtr.videoPosition == Duration.zero) {
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
                              image: flutterExtendedCtr.videoThumbnail,
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
                child: GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                  tag: tag,
                  id: 'flutterExtendedVideoPlayerVideoState',
                  builder: (flutterExtendedCtr) {
                    final loadingWidget = flutterExtendedCtr.onLoading?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );

                    if (kIsWeb) {
                      switch (flutterExtendedCtr.flutterExtendedVideoPlayerVideoState) {
                        case FlutterExtendedVideoPlayerVideoState.loading:
                          return loadingWidget;
                        case FlutterExtendedVideoPlayerVideoState.paused:
                          return const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                        case FlutterExtendedVideoPlayerVideoState.playing:
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
                        case FlutterExtendedVideoPlayerVideoState.error:
                          return const SizedBox();
                        case FlutterExtendedVideoPlayerVideoState.finished:
                         return const Center(
                            child: Icon(
                              Icons.replay,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                          break;
                      }
                    } else {
                      if (flutterExtendedCtr.flutterExtendedVideoPlayerVideoState == FlutterExtendedVideoPlayerVideoState.loading) {
                        return loadingWidget;
                      }
                      return const SizedBox();
                    }
                  },
                ),
              ),
              if (!kIsWeb)
                GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                  tag: tag,
                  id: 'full-screen',
                  builder: (flutterExtendedCtr) => flutterExtendedCtr.isFullScreen
                      ? const SizedBox()
                      : GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                          tag: tag,
                          id: 'overlay',
                          builder: (flutterExtendedCtr) {
                            var check = flutterExtendedCtr.isOverlayVisible ||
                                !flutterExtendedCtr.alwaysShowProgressBar;
                           // print("-----sahil --------- check ${check}");
                            return check
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FlutterExtendedProgressBar(
                                    tag: tag,
                                    alignment: Alignment.bottomCenter,
                                    flutterExtendedProgressBarConfig:
                                    flutterExtendedCtr.flutterExtendedProgressBarConfig,
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
