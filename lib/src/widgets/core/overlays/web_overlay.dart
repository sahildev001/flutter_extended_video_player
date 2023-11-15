part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

class _WebOverlay extends StatelessWidget {
  final String tag;
  const _WebOverlay({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    const overlayColor = Colors.black38;
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    return Stack(
      children: [
        Positioned.fill(
          child: _VideoGestureDetector(
            tag: tag,
            onTap: flutterExtendedCtr.togglePlayPauseVideo,
            onDoubleTap: () => flutterExtendedCtr.toggleFullScreenOnWeb(context, tag),
            child: const ColoredBox(
              color: overlayColor,
              child: SizedBox.expand(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _WebOverlayBottomControlles(
            tag: tag,
          ),
        ),
        Positioned.fill(
          child: GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
            tag: tag,
            id: 'double-tap',
            builder: (flutterExtendedCtr) {
              return Row(
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: DoubleTapIcon(
                        onDoubleTap: () {},
                        tag: tag,
                        isForward: false,
                        iconOnly: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IgnorePointer(
                      child: DoubleTapIcon(
                        onDoubleTap: () {},
                        tag: tag,
                        isForward: true,
                        iconOnly: true,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        IgnorePointer(child: flutterExtendedCtr.videoTitle ?? const SizedBox()),
      ],
    );
  }
}

class _WebOverlayBottomControlles extends StatelessWidget {
  final String tag;

  const _WebOverlayBottomControlles({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return MouseRegion(
      onHover: (event) => flutterExtendedCtr.onOverlayHover(),
      onExit: (event) => flutterExtendedCtr.onOverlayHoverExit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterExtendedProgressBar(
              tag: tag,
              flutterExtendedProgressBarConfig: flutterExtendedCtr.flutterExtendedProgressBarConfig,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        _AnimatedPlayPauseIcon(tag: tag),
                        GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                          tag: tag,
                          id: 'volume',
                          builder: (flutterExtendedCtr) => MaterialIconButton(
                            toolTipMesg: flutterExtendedCtr.isMute
                                ? flutterExtendedCtr.flutterExtendedVideoPlayerLables.unmute ??
                                    'Unmute${kIsWeb ? ' (m)' : ''}'
                                : flutterExtendedCtr.flutterExtendedVideoPlayerLables.mute ??
                                    'Mute${kIsWeb ? ' (m)' : ''}',
                            color: itemColor,
                            onPressed: flutterExtendedCtr.toggleMute,
                            child: Icon(
                              flutterExtendedCtr.isMute
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                            ),
                          ),
                        ),
                        GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                          tag: tag,
                          id: 'video-progress',
                          builder: (flutterExtendedCtr) {
                            return Row(
                              children: [
                                Text(
                                  flutterExtendedCtr.calculateVideoDuration(
                                    flutterExtendedCtr.videoPosition,
                                  ),
                                  style: durationTextStyle,
                                ),
                                const Text(
                                  ' / ',
                                  style: durationTextStyle,
                                ),
                                Text(
                                  flutterExtendedCtr.calculateVideoDuration(
                                    flutterExtendedCtr.videoDuration,
                                  ),
                                  style: durationTextStyle,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        _WebSettingsDropdown(tag: tag),
                        MaterialIconButton(
                          toolTipMesg: flutterExtendedCtr.isFullScreen
                              ? flutterExtendedCtr.flutterExtendedVideoPlayerLables.exitFullScreen ??
                                  'Exit full screen${kIsWeb ? ' (f)' : ''}'
                              : flutterExtendedCtr.flutterExtendedVideoPlayerLables.fullscreen ??
                                  'Fullscreen${kIsWeb ? ' (f)' : ''}',
                          color: itemColor,
                          onPressed: () => _onFullScreenToggle(flutterExtendedCtr, context),
                          child: Icon(
                            flutterExtendedCtr.isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onFullScreenToggle(
      FlutterExtendedVideoPlayerGetXVideoController flutterExtendedCtr,
    BuildContext context,
  ) {
    if (flutterExtendedCtr.isOverlayVisible) {
      if (flutterExtendedCtr.isFullScreen) {
        if (kIsWeb) {
          uni_html.document.exitFullscreen();
          flutterExtendedCtr.disableFullScreen(context, tag);
          return;
        } else {
          flutterExtendedCtr.disableFullScreen(context, tag);
        }
      } else {
        if (kIsWeb) {
          uni_html.document.documentElement?.requestFullscreen();
          flutterExtendedCtr.enableFullScreen(tag);
          return;
        } else {
          flutterExtendedCtr.enableFullScreen(tag);
        }
      }
    } else {
      flutterExtendedCtr.toggleVideoOverlay();
    }
  }
}
