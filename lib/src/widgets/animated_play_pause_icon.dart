part of 'package:hop_video_player/src/hop_video_player.dart';

class _AnimatedPlayPauseIcon extends StatefulWidget {
  final double? size;
  final String tag;

  const _AnimatedPlayPauseIcon({
    required this.tag,
    this.size,
  });

  @override
  State<_AnimatedPlayPauseIcon> createState() => _AnimatedPlayPauseIconState();
}

class _AnimatedPlayPauseIconState extends State<_AnimatedPlayPauseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _payCtr;
  late HopVideoPlayerGetXVideoController _hopCtr;
  @override
  void initState() {
    _hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: widget.tag);
    _payCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _hopCtr.addListenerId('hopVideoPlayerVideoState', playPauseListner);
    if (_hopCtr.isvideoPlaying) {
      if (mounted) _payCtr.forward();
    }
    super.initState();
  }

  void playPauseListner() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_hopCtr.hopVideoPlayerVideoState == HopVideoPlayerVideoState.playing) {
        if (mounted) _payCtr.forward();
      }
      if (_hopCtr.hopVideoPlayerVideoState == HopVideoPlayerVideoState.paused) {

        if (mounted) _payCtr.reverse();
      }
    });
  }

  @override
  void dispose() {
    _payCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HopVideoPlayerGetXVideoController>(
      tag: widget.tag,
      id: 'overlay',
      builder: (hopCtr) {
        return GetBuilder<HopVideoPlayerGetXVideoController>(
          tag: widget.tag,
          id: 'hopVideoPlayerVideoState',
          builder: (f) => MaterialIconButton(
            toolTipMesg: f.isvideoPlaying
                ? hopCtr.hopVideoPlayerLabels.pause ??
                    'Pause${kIsWeb ? ' (space)' : ''}'
                : hopCtr.hopVideoPlayerLabels.play ??
                    'Play${kIsWeb ? ' (space)' : ''}',
            onPressed:
                hopCtr.isOverlayVisible ? hopCtr.togglePlayPauseVideo : null,
            child: onStateChange(hopCtr),
          ),
        );
      },
    );
  }

  Widget onStateChange(HopVideoPlayerGetXVideoController hopCtr) {
    if (kIsWeb) return _playPause(hopCtr);
    if (hopCtr.hopVideoPlayerVideoState == HopVideoPlayerVideoState.loading) {
      return const SizedBox();
    } else {
      return _playPause(hopCtr);
    }
  }

  Widget _playPause(HopVideoPlayerGetXVideoController hopCtr) {
    return AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      progress: _payCtr,
      color: Colors.white,
      size: widget.size,
    );
  }
}
