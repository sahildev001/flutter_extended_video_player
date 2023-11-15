part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

class _MobileBottomSheet extends StatelessWidget {
  final String tag;

  const _MobileBottomSheet({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
      tag: tag,
      builder: (flutterExtendedCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (flutterExtendedCtr.vimeoOrVideoUrls.isNotEmpty)
            _bottomSheetTiles(
              title: flutterExtendedCtr.flutterExtendedVideoPlayerLables.quality,
              icon: Icons.video_settings_rounded,
              subText: '${flutterExtendedCtr.vimeoPlayingVideoQuality}p',
              onTap: () {
                Navigator.of(context).pop();
                Timer(const Duration(milliseconds: 100), () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => SafeArea(
                      child: _VideoQualitySelectorMob(
                        tag: tag,
                        onTap: null,
                      ),
                    ),
                  );
                });
                // await Future.delayed(
                //   const Duration(milliseconds: 100),
                // );
              },
            ),
          _bottomSheetTiles(
            title: flutterExtendedCtr.flutterExtendedVideoPlayerLables.loopVideo,
            icon: Icons.loop_rounded,
            subText: flutterExtendedCtr.isLooping
                ? flutterExtendedCtr.flutterExtendedVideoPlayerLables.optionEnabled
                : flutterExtendedCtr.flutterExtendedVideoPlayerLables.optionDisabled,
            onTap: () {
              Navigator.of(context).pop();
              flutterExtendedCtr.toggleLooping();
            },
          ),
          _bottomSheetTiles(
            title: flutterExtendedCtr.flutterExtendedVideoPlayerLables.playbackSpeed,
            icon: Icons.slow_motion_video_rounded,
            subText: flutterExtendedCtr.currentPaybackSpeed,
            onTap: () {
              Navigator.of(context).pop();
              Timer(const Duration(milliseconds: 100), () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SafeArea(
                    child: _VideoPlaybackSelectorMob(
                      tag: tag,
                      onTap: null,
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  ListTile _bottomSheetTiles({
    required String title,
    required IconData icon,
    String? subText,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      onTap: onTap,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              title,
            ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              const SizedBox(
                height: 4,
                width: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              Text(
                subText,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class _VideoQualitySelectorMob extends StatelessWidget {
  final void Function()? onTap;
  final String tag;

  const _VideoQualitySelectorMob({
    required this.onTap,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: flutterExtendedCtr.vimeoOrVideoUrls
            .map(
              (e) => ListTile(
                title: Text('${e.quality}p'),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();

                  flutterExtendedCtr.changeVideoQuality(e.quality);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _VideoPlaybackSelectorMob extends StatelessWidget {
  final void Function()? onTap;
  final String tag;

  const _VideoPlaybackSelectorMob({
    required this.onTap,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: flutterExtendedCtr.videoPlaybackSpeeds
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();
                  flutterExtendedCtr.setVideoPlayBack(e);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MobileOverlayBottomControlles extends StatelessWidget {
  final String tag;

  const _MobileOverlayBottomControlles({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
      tag: tag,
      id: 'full-screen',
      builder: (flutterExtendedCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                tag: tag,
                id: 'video-progress',
                builder: (flutterExtendedCtr) {
                  return Row(
                    children: [
                      Text(
                        flutterExtendedCtr.calculateVideoDuration(flutterExtendedCtr.videoPosition),
                        style: const TextStyle(color: itemColor),
                      ),
                      const Text(
                        ' / ',
                        style: durationTextStyle,
                      ),
                      Text(
                        flutterExtendedCtr.calculateVideoDuration(flutterExtendedCtr.videoDuration),
                        style: durationTextStyle,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              MaterialIconButton(
                toolTipMesg: flutterExtendedCtr.isFullScreen
                    ? flutterExtendedCtr.flutterExtendedVideoPlayerLables.exitFullScreen ??
                        'Exit full screen${kIsWeb ? ' (f)' : ''}'
                    : flutterExtendedCtr.flutterExtendedVideoPlayerLables.fullscreen ??
                        'Fullscreen${kIsWeb ? ' (f)' : ''}',
                color: itemColor,
                onPressed: () {
                  if (flutterExtendedCtr.isOverlayVisible) {
                    if (flutterExtendedCtr.isFullScreen) {
                      flutterExtendedCtr.disableFullScreen(context, tag);
                    } else {
                      flutterExtendedCtr.enableFullScreen(tag);
                    }
                  } else {
                    flutterExtendedCtr.toggleVideoOverlay();
                  }
                },
                child: Icon(
                  flutterExtendedCtr.isFullScreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                ),
              ),
            ],
          ),
          GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
            tag: tag,
            id: 'overlay',
            builder: (flutterExtendedCtr) {
              if (flutterExtendedCtr.isFullScreen) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: Visibility(
                    visible: flutterExtendedCtr.isOverlayVisible,
                    child: FlutterExtendedProgressBar(
                      tag: tag,
                      alignment: Alignment.topCenter,
                      flutterExtendedProgressBarConfig: flutterExtendedCtr.flutterExtendedProgressBarConfig,
                      onDragStart: flutterExtendedCtr.onDragStart,
                      onDragEnd: flutterExtendedCtr.onDragEnd,
                      onDragUpdate: flutterExtendedCtr.onDragUpdate,
                    ),
                  ),
                );
              }
              return FlutterExtendedProgressBar(
                tag: tag,
                alignment: Alignment.bottomCenter,
                flutterExtendedProgressBarConfig: flutterExtendedCtr.flutterExtendedProgressBarConfig,
                onDragStart: flutterExtendedCtr.onDragStart,
                onDragEnd: flutterExtendedCtr.onDragEnd,
                onDragUpdate: flutterExtendedCtr.onDragUpdate,
              );
            },
          ),
        ],
      ),
    );
  }
}
