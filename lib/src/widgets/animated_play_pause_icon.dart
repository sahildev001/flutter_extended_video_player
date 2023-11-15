part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

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
  late FlutterExtendedVideoPlayerGetXVideoController _flutterExtendedCtr;
  @override
  void initState() {
    _flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: widget.tag);
    _payCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _flutterExtendedCtr.addListenerId('flutterExtendedVideoPlayerVideoState', playPauseListner);
    if (_flutterExtendedCtr.isvideoPlaying) {
      if (mounted) _payCtr.forward();
    }
    super.initState();
  }

  void playPauseListner() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_flutterExtendedCtr.flutterExtendedVideoPlayerVideoState == FlutterExtendedVideoPlayerVideoState.playing) {
        if (mounted) _payCtr.forward();
      }
      if (_flutterExtendedCtr.flutterExtendedVideoPlayerVideoState == FlutterExtendedVideoPlayerVideoState.paused) {

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
    return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
      tag: widget.tag,
      id: 'overlay',
      builder: (flutterExtendedCtr) {
        return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
          tag: widget.tag,
          id: 'flutterExtendedVideoPlayerVideoState',
          builder: (f) => MaterialIconButton(
            toolTipMesg: f.isvideoPlaying
                ? flutterExtendedCtr.flutterExtendedVideoPlayerLables.pause ??
                    'Pause${kIsWeb ? ' (space)' : ''}'
                : flutterExtendedCtr.flutterExtendedVideoPlayerLables.play ??
                    'Play${kIsWeb ? ' (space)' : ''}',
            onPressed:
                flutterExtendedCtr.isOverlayVisible ? flutterExtendedCtr.togglePlayPauseVideo : null,
            child: onStateChange(flutterExtendedCtr),
          ),
        );
      },
    );
  }

  Widget onStateChange(FlutterExtendedVideoPlayerGetXVideoController flutterExtendedCtr) {
    if (kIsWeb) return _playPause(flutterExtendedCtr);
    if (flutterExtendedCtr.flutterExtendedVideoPlayerVideoState == FlutterExtendedVideoPlayerVideoState.loading) {
      return const SizedBox();
    } else {
      return _playPause(flutterExtendedCtr);
    }
  }

  Widget _playPause(FlutterExtendedVideoPlayerGetXVideoController flutterExtendedCtr) {
    return AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      progress: _payCtr,
      color: Colors.white,
      size: widget.size,
    );
  }
}
