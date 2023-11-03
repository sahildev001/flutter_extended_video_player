part of 'package:hop_video_player/src/hop_video_player.dart';

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
    final hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: tag);
    return MouseRegion(
      onHover: (event) => hopCtr.onOverlayHover(),
      onExit: (event) => hopCtr.onOverlayHoverExit(),
      child: GestureDetector(
        onTap: onTap ?? hopCtr.toggleVideoOverlay,
        onDoubleTap: onDoubleTap,
        child: child,
      ),
    );
  }
}
