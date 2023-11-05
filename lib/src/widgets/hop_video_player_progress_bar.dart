import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:video_player/video_player.dart';

import '../controllers/hop_getx_video_controller.dart';
import '../models/hop_progress_bar_config.dart';
/// Renders progress bar for the video using custom paint.
class HopProgressBar extends StatefulWidget {
  const HopProgressBar({
    required this.tag,
    super.key,
    HopProgressBarConfig? hopProgressBarConfig,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.alignment = Alignment.center,
  }) : hopProgressBarConfig =
            hopProgressBarConfig ?? const HopProgressBarConfig();

  final HopProgressBarConfig hopProgressBarConfig;
  final void Function(Duration duration)? onDragStart;
  final void Function(Duration duration)? onDragEnd;
  final void Function(Duration duration)? onDragUpdate;
  final Alignment alignment;
  final String tag;

  @override
  State<HopProgressBar> createState() => _HopProgressBarState();
}

class _HopProgressBarState extends State<HopProgressBar> {
  late final _hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: widget.tag);
  late VideoPlayerValue? videoPlayerValue = _hopCtr.videoCtr?.value;
  bool _controllerWasPlaying = false;

  void seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position =
          (videoPlayerValue?.duration ?? Duration.zero) * relative;
      _hopCtr.seekTo(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerValue == null) return const SizedBox();

    return GetBuilder<HopVideoPlayerGetXVideoController>(
      tag: widget.tag,
      id: 'video-progress',
      builder: (hopCtr) {
        videoPlayerValue = hopCtr.videoCtr?.value;
        return LayoutBuilder(
          builder: (context, size) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: _progressBar(size),
              onHorizontalDragStart: (DragStartDetails details) {
                if (!videoPlayerValue!.isInitialized) {
                  return;
                }
                _controllerWasPlaying =
                    hopCtr.videoCtr?.value.isPlaying ?? false;

                if (_controllerWasPlaying) {
                  hopCtr.videoCtr?.pause();
                }
               if (widget.onDragStart != null) {
                   widget.onDragStart?.call(hopCtr.videoPosition);
                }
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                if (!videoPlayerValue!.isInitialized) {
                  return;
                }
                hopCtr.isShowOverlay(true);
                seekToRelativePosition(details.globalPosition);

                if(widget.onDragUpdate != null) {
                  widget.onDragUpdate?.call(hopCtr.videoPosition);
                }
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                if (_controllerWasPlaying) {
                  hopCtr.videoCtr?.play();
                }
                hopCtr.toggleVideoOverlay();

                if (widget.onDragEnd != null) {
                  widget.onDragEnd?.call(hopCtr.videoPosition);
                }
              },
              onTapDown: (TapDownDetails details) {
                if (!videoPlayerValue!.isInitialized) {
                  return;
                }
                seekToRelativePosition(details.globalPosition);
              },
            );
          },
        );
      },
    );
  }

  MouseRegion _progressBar(BoxConstraints size) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: widget.hopProgressBarConfig.padding,
        child: SizedBox(
          width: size.maxWidth,
          height: widget.hopProgressBarConfig.circleHandlerRadius,
          child: Align(
            alignment: widget.alignment,
            child: GetBuilder<HopVideoPlayerGetXVideoController>(
              tag: widget.tag,
              id: 'overlay',
              builder: (hopCtr) => CustomPaint(
                painter: _ProgressBarPainter(
                  videoPlayerValue!,
                  hopProgressBarConfig: widget.hopProgressBarConfig.copyWith(
                    circleHandlerRadius: hopCtr.isOverlayVisible ||
                            widget
                                .hopProgressBarConfig.alwaysVisibleCircleHandler
                        ? widget.hopProgressBarConfig.circleHandlerRadius
                        : 0,
                  ),
                ),
                size: Size(
                  double.maxFinite,
                  widget.hopProgressBarConfig.height,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value, {this.hopProgressBarConfig});

  VideoPlayerValue value;
  HopProgressBarConfig? hopProgressBarConfig;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double height = hopProgressBarConfig!.height;
    final double width = size.width;
    final double curveRadius = hopProgressBarConfig!.curveRadius;
    final double circleHandlerRadius =
        hopProgressBarConfig!.circleHandlerRadius;
    final Paint backgroundPaint =
        hopProgressBarConfig!.getBackgroundPaint != null
            ? hopProgressBarConfig!.getBackgroundPaint!(
                width: width,
                height: height,
                circleHandlerRadius: circleHandlerRadius,
              )
            : Paint()
        ..color = hopProgressBarConfig!.backgroundColor;
          //..color = Colors.teal;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset.zero,
          Offset(width, height),
        ),
        Radius.circular(curveRadius),
      ),
      backgroundPaint,
    );
    if (value.isInitialized == false) {
      return;
    }

    final double playedPartPercent =
        value.position.inMilliseconds / value.duration.inMilliseconds;
    final double playedPart =
        playedPartPercent > 1 ? width : playedPartPercent * width;

    for (final DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * width;
      final double end = range.endFraction(value.duration) * width;

      final Paint bufferedPaint = hopProgressBarConfig!.getBufferedPaint != null
          ? hopProgressBarConfig!.getBufferedPaint!(
              width: width,
              height: height,
              playedPart: playedPart,
              circleHandlerRadius: circleHandlerRadius,
              bufferedStart: start,
              bufferedEnd: end,
            )
          : Paint()
        ..color = hopProgressBarConfig!.bufferedBarColor;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, 0),
            Offset(end, height),
          ),
          Radius.circular(curveRadius),
        ),
        bufferedPaint,
      );
    }

    final Paint playedPaint = hopProgressBarConfig!.getPlayedPaint != null
        ? hopProgressBarConfig!.getPlayedPaint!(
            width: width,
            height: height,
            playedPart: playedPart,
            circleHandlerRadius: circleHandlerRadius,
          )
        : Paint()
      ..color = hopProgressBarConfig!.playingBarColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset.zero,
          Offset(playedPart, height),
        ),
        Radius.circular(curveRadius),
      ),
      playedPaint,
    );

    final Paint handlePaint =
        hopProgressBarConfig!.getCircleHandlerPaint != null
            ? hopProgressBarConfig!.getCircleHandlerPaint!(
                width: width,
                height: height,
                playedPart: playedPart,
                circleHandlerRadius: circleHandlerRadius,
              )
            : Paint()
          ..color = hopProgressBarConfig!.circleHandlerColor;

    canvas.drawCircle(
      Offset(playedPart, height / 2),
      circleHandlerRadius,
      handlePaint,
    );
  }
}
