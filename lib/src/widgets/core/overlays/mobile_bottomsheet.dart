part of 'package:hop_video_player/src/hop_video_player.dart';

class _MobileBottomSheet extends StatelessWidget {
  final String tag;

  const _MobileBottomSheet({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HopVideoPlayerGetXVideoController>(
      tag: tag,
      builder: (hopCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hopCtr.vimeoOrVideoUrls.isNotEmpty)
            _bottomSheetTiles(
              title: hopCtr.hopVideoPlayerLabels.quality,
              icon: Icons.video_settings_rounded,
              subText: '${hopCtr.vimeoPlayingVideoQuality}p',
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
            title: hopCtr.hopVideoPlayerLabels.loopVideo,
            icon: Icons.loop_rounded,
            subText: hopCtr.isLooping
                ? hopCtr.hopVideoPlayerLabels.optionEnabled
                : hopCtr.hopVideoPlayerLabels.optionDisabled,
            onTap: () {
              Navigator.of(context).pop();
              hopCtr.toggleLooping();
            },
          ),
          _bottomSheetTiles(
            title: hopCtr.hopVideoPlayerLabels.playbackSpeed,
            icon: Icons.slow_motion_video_rounded,
            subText: hopCtr.currentPaybackSpeed,
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
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: hopCtr.vimeoOrVideoUrls
            .map(
              (e) => ListTile(
                title: Text('${e.quality}p'),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();

                  hopCtr.changeVideoQuality(e.quality);
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
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: hopCtr.videoPlaybackSpeeds
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();
                  hopCtr.setVideoPlayBack(e);
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

    return GetBuilder<HopVideoPlayerGetXVideoController>(
      tag: tag,
      id: 'full-screen',
      builder: (hopCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              GetBuilder<HopVideoPlayerGetXVideoController>(
                tag: tag,
                id: 'video-progress',
                builder: (hopCtr) {
                  return Row(
                    children: [
                      Text(
                        hopCtr.calculateVideoDuration(hopCtr.videoPosition),
                        style: const TextStyle(color: itemColor),
                      ),
                      const Text(
                        ' / ',
                        style: durationTextStyle,
                      ),
                      Text(
                        hopCtr.calculateVideoDuration(hopCtr.videoDuration),
                        style: durationTextStyle,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              MaterialIconButton(
                toolTipMesg: hopCtr.isFullScreen
                    ? hopCtr.hopVideoPlayerLabels.exitFullScreen ??
                        'Exit full screen${kIsWeb ? ' (f)' : ''}'
                    : hopCtr.hopVideoPlayerLabels.fullscreen ??
                        'Fullscreen${kIsWeb ? ' (f)' : ''}',
                color: itemColor,
                onPressed: () {
                  if (hopCtr.isOverlayVisible) {
                    if (hopCtr.isFullScreen) {
                      hopCtr.disableFullScreen(context, tag);
                    } else {
                      hopCtr.enableFullScreen(tag);
                    }
                  } else {
                    hopCtr.toggleVideoOverlay();
                  }
                },
                child: Icon(
                  hopCtr.isFullScreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                ),
              ),
            ],
          ),
          GetBuilder<HopVideoPlayerGetXVideoController>(
            tag: tag,
            id: 'overlay',
            builder: (hopCtr) {
              if (hopCtr.isFullScreen) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: Visibility(
                    visible: hopCtr.isOverlayVisible,
                    child: HopProgressBar(
                      tag: tag,
                      alignment: Alignment.topCenter,
                      hopProgressBarConfig: hopCtr.hopProgressBarConfig,
                      onDragStart: hopCtr.onDragStart,
                      onDragEnd: hopCtr.onDragEnd,
                      onDragUpdate: hopCtr.onDragUpdate,
                    ),
                  ),
                );
              }
              return HopProgressBar(
                tag: tag,
                alignment: Alignment.bottomCenter,
                hopProgressBarConfig: hopCtr.hopProgressBarConfig,
                onDragStart: hopCtr.onDragStart,
                onDragEnd: hopCtr.onDragEnd,
                onDragUpdate: hopCtr.onDragUpdate,
              );
            },
          ),
        ],
      ),
    );
  }
}
