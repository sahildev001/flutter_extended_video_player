part of 'package:hop_video_player/src/hop_video_player.dart';

class _WebOverlay extends StatelessWidget {
  final String tag;
  const _WebOverlay({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    const overlayColor = Colors.black38;
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    return Stack(
      children: [
        Positioned.fill(
          child: _VideoGestureDetector(
            tag: tag,
            onTap: hopCtr.togglePlayPauseVideo,
            onDoubleTap: () => hopCtr.toggleFullScreenOnWeb(context, tag),
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
          child: GetBuilder<HopVideoPlayerGetXVideoController>(
            tag: tag,
            id: 'double-tap',
            builder: (hopCtr) {
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
        IgnorePointer(child: hopCtr.videoTitle ?? const SizedBox()),
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
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return MouseRegion(
      onHover: (event) => hopCtr.onOverlayHover(),
      onExit: (event) => hopCtr.onOverlayHoverExit(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HopProgressBar(
              tag: tag,
              hopProgressBarConfig: hopCtr.hopProgressBarConfig,
              onDragStart: (Duration duration){
                print("sahil 4::------------------------${duration.inSeconds}-----");
              },
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
                        GetBuilder<HopVideoPlayerGetXVideoController>(
                          tag: tag,
                          id: 'volume',
                          builder: (hopCtr) => MaterialIconButton(
                            toolTipMesg: hopCtr.isMute
                                ? hopCtr.hopVideoPlayerLabels.unmute ??
                                    'Unmute${kIsWeb ? ' (m)' : ''}'
                                : hopCtr.hopVideoPlayerLabels.mute ??
                                    'Mute${kIsWeb ? ' (m)' : ''}',
                            color: itemColor,
                            onPressed: hopCtr.toggleMute,
                            child: Icon(
                              hopCtr.isMute
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                            ),
                          ),
                        ),
                        GetBuilder<HopVideoPlayerGetXVideoController>(
                          tag: tag,
                          id: 'video-progress',
                          builder: (hopCtr) {
                            return Row(
                              children: [
                                Text(
                                  hopCtr.calculateVideoDuration(
                                    hopCtr.videoPosition,
                                  ),
                                  style: durationTextStyle,
                                ),
                                const Text(
                                  ' / ',
                                  style: durationTextStyle,
                                ),
                                Text(
                                  hopCtr.calculateVideoDuration(
                                    hopCtr.videoDuration,
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
                          toolTipMesg: hopCtr.isFullScreen
                              ? hopCtr.hopVideoPlayerLabels.exitFullScreen ??
                                  'Exit full screen${kIsWeb ? ' (f)' : ''}'
                              : hopCtr.hopVideoPlayerLabels.fullscreen ??
                                  'Fullscreen${kIsWeb ? ' (f)' : ''}',
                          color: itemColor,
                          onPressed: () => _onFullScreenToggle(hopCtr, context),
                          child: Icon(
                            hopCtr.isFullScreen
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
    HopVideoPlayerGetXVideoController hopCtr,
    BuildContext context,
  ) {
    if (hopCtr.isOverlayVisible) {
      if (hopCtr.isFullScreen) {
        if (kIsWeb) {
          uni_html.document.exitFullscreen();
          hopCtr.disableFullScreen(context, tag);
          return;
        } else {
          hopCtr.disableFullScreen(context, tag);
        }
      } else {
        if (kIsWeb) {
          uni_html.document.documentElement?.requestFullscreen();
          hopCtr.enableFullScreen(tag);
          return;
        } else {
          hopCtr.enableFullScreen(tag);
        }
      }
    } else {
      hopCtr.toggleVideoOverlay();
    }
  }
}
