part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

class _VideoGestureDetector extends StatelessWidget {
  final Widget? child;
  final void Function()? onDoubleTap;
  final void Function()? onTap;
  final String tag;

  const _VideoGestureDetector({
    required this.tag,
    this.child,
    this.onDoubleTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: tag);
    return MouseRegion(
      onHover: (event) => flutterExtendedCtr.onOverlayHover(),
      onExit: (event) => flutterExtendedCtr.onOverlayHoverExit(),
      child: GestureDetector(
        onTap: onTap ?? flutterExtendedCtr.toggleVideoOverlay,
        onDoubleTap: onDoubleTap,
        child: child,
      ),
    );
  }
}
