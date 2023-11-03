part of 'package:hop_video_player/src/hop_video_player.dart';

class _MobileOverlay extends StatelessWidget {
  final String tag;

  const _MobileOverlay({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    const overlayColor = Colors.black38;
    const itemColor = Colors.white;
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    return Stack(
      alignment: Alignment.center,
      children: [
        _VideoGestureDetector(
          tag: tag,
          child: ColoredBox(
            color: overlayColor,
            child: Row(
              children: [
                Expanded(
                  child: DoubleTapIcon(
                    tag: tag,
                    isForward: false,
                    height: double.maxFinite,
                    onDoubleTap: _isRtl()
                        ? hopCtr.onRightDoubleTap
                        : hopCtr.onLeftDoubleTap,
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: _AnimatedPlayPauseIcon(tag: tag, size: 42),
                  ),
                ),
                Expanded(
                  child: DoubleTapIcon(
                    isForward: true,
                    tag: tag,
                    height: double.maxFinite,
                    onDoubleTap: _isRtl()
                        ? hopCtr.onLeftDoubleTap
                        : hopCtr.onRightDoubleTap,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: IgnorePointer(
                  child: hopCtr.videoTitle ?? const SizedBox(),
                ),
              ),
              MaterialIconButton(
                toolTipMesg: hopCtr.hopVideoPlayerLabels.settings,
                color: itemColor,
                onPressed: () {
                  if (hopCtr.isOverlayVisible) {
                    _bottomSheet(context);
                  } else {
                    hopCtr.toggleVideoOverlay();
                  }
                },
                child: const Icon(
                  Icons.more_vert_rounded,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _MobileOverlayBottomControlles(tag: tag),
        ),
      ],
    );
  }

  bool _isRtl() {
    final Locale locale = WidgetsBinding.instance.platformDispatcher.locale;
    final langs = [
      'ar', // Arabic
      'fa', // Farsi
      'he', // Hebrew
      'ps', // Pashto
      'ur', // Urdu
    ];
    for (int i = 0; i < langs.length; i++) {
      final lang = langs[i];
      if (locale.toString().contains(lang)) {
        return true;
      }
    }
    return false;
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(child: _MobileBottomSheet(tag: tag)),
    );
  }
}
