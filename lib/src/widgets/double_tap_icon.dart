import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/flutter_extended_getx_video_controller.dart';
import 'doubble_tap_effect.dart';

class DoubleTapIcon extends StatefulWidget {
  final void Function() onDoubleTap;
  final String tag;
  final bool iconOnly;
  final bool isForward;
  final double height;
  final double? width;

  const DoubleTapIcon({
    required this.onDoubleTap,
    required this.tag,
    required this.isForward,
    super.key,
    this.iconOnly = false,
    this.height = 50,
    this.width,
  });

  @override
  State<DoubleTapIcon> createState() => _DoubleTapIconState();
}

class _DoubleTapIconState extends State<DoubleTapIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> opacityCtr;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    opacityCtr = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: widget.tag);
    if (widget.iconOnly && !widget.isForward) {
      flutterExtendedCtr.addListenerId('double-tap-left', _onDoubleTap);
    }
    if (widget.iconOnly && widget.isForward) {
      flutterExtendedCtr.addListenerId('double-tap-right', _onDoubleTap);
    }
  }

  @override
  void dispose() {
    final flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: widget.tag);

    if (widget.iconOnly && !widget.isForward) {
      flutterExtendedCtr.removeListenerId('double-tap-left', _onDoubleTap);
    }
    if (widget.iconOnly && widget.isForward) {
      flutterExtendedCtr.removeListenerId('double-tap-right', _onDoubleTap);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    widget.onDoubleTap();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.iconOnly) return iconWithText();
    return DoubleTapRippleEffect(
      onDoubleTap: _onDoubleTap,
      rippleColor: Colors.white,
      wrapper: (parentWidget, curveRadius) {
        final forwardRadius =
            !widget.isForward ? Radius.zero : Radius.circular(curveRadius);
        final backwardRadius =
            widget.isForward ? Radius.zero : Radius.circular(curveRadius);
        return ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: forwardRadius,
            topLeft: forwardRadius,
            bottomRight: backwardRadius,
            topRight: backwardRadius,
          ),
          child: parentWidget,
        );
      },
      child: iconWithText(),
    );
  }

  SizedBox iconWithText() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          const icon = Icon(
            Icons.play_arrow_sharp,
            size: 32,
            color: Colors.white,
          );
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: widget.isForward ? 0 : 2,
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: opacityCtr.value,
                        child: icon,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: opacityCtr.value,
                          child: icon,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: opacityCtr.value,
                          child: icon,
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
                  tag: widget.tag,
                  id: 'double-tap',
                  builder: (flutterExtendedCtr) {
                    if (widget.isForward && flutterExtendedCtr.isRightDbTapIconVisible) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: opacityCtr.value,
                        child: Text(
                          '${flutterExtendedCtr.isLeftDbTapIconVisible ? flutterExtendedCtr.leftDoubleTapduration : flutterExtendedCtr.rightDubleTapduration} Sec',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (!widget.isForward && flutterExtendedCtr.isLeftDbTapIconVisible) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: opacityCtr.value,
                        child: Text(
                          '${flutterExtendedCtr.isLeftDbTapIconVisible ? flutterExtendedCtr.leftDoubleTapduration : flutterExtendedCtr.rightDubleTapduration} Sec',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
