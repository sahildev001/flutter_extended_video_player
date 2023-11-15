import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:video_player/video_player.dart';

import '../controllers/flutter_extended_getx_video_controller.dart';
import '../models/flutter_extended_progress_bar_config.dart';
/// Renders progress bar for the video using custom paint.
class FlutterExtendedProgressBar extends StatefulWidget {
  const FlutterExtendedProgressBar({
    required this.tag,
    super.key,
    FlutterExtendedProgressBarConfig? flutterExtendedProgressBarConfig,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.alignment = Alignment.center,
  }) : flutterExtendedProgressBarConfig =
            flutterExtendedProgressBarConfig ?? const FlutterExtendedProgressBarConfig();

  final FlutterExtendedProgressBarConfig flutterExtendedProgressBarConfig;
  final void Function(Duration duration)? onDragStart;
  final void Function(Duration duration)? onDragEnd;
  final void Function(Duration duration)? onDragUpdate;
  final Alignment alignment;
  final String tag;

  @override
  State<FlutterExtendedProgressBar> createState() => _FlutterExtendedProgressBarState();
}

class _FlutterExtendedProgressBarState extends State<FlutterExtendedProgressBar> {
  late final _flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: widget.tag);
  late VideoPlayerValue? videoPlayerValue = _flutterExtendedCtr.videoCtr?.value;
  bool _controllerWasPlaying = false;

  void seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position =
          (videoPlayerValue?.duration ?? Duration.zero) * relative;
      _flutterExtendedCtr.seekTo(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerValue == null) return const SizedBox();

    return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
      tag: widget.tag,
      id: 'video-progress',
      builder: (flutterExtendedCtr) {
        videoPlayerValue = flutterExtendedCtr.videoCtr?.value;
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
                    flutterExtendedCtr.videoCtr?.value.isPlaying ?? false;

                if (_controllerWasPlaying) {

                  flutterExtendedCtr.videoCtr?.pause();
                }
               if (widget.onDragStart != null) {
                   widget.onDragStart?.call(flutterExtendedCtr.videoPosition);
                }
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                if (!videoPlayerValue!.isInitialized) {
                  return;
                }
                flutterExtendedCtr.isShowOverlay(true);
                seekToRelativePosition(details.globalPosition);

                if(widget.onDragUpdate != null) {
                  widget.onDragUpdate?.call(flutterExtendedCtr.videoPosition);
                }
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                if (_controllerWasPlaying) {
                  flutterExtendedCtr.videoCtr?.play();
                }
                flutterExtendedCtr.toggleVideoOverlay();

                if (widget.onDragEnd != null) {
                  widget.onDragEnd?.call(flutterExtendedCtr.videoPosition);
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
        padding: widget.flutterExtendedProgressBarConfig.padding,
        child: SizedBox(
          width: size.maxWidth,
          height: widget.flutterExtendedProgressBarConfig.circleHandlerRadius,
          child: Align(
            alignment: widget.alignment,
            child: GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
              tag: widget.tag,
              id: 'overlay',
              builder: (flutterExtendedCtr) => CustomPaint(
                painter: _ProgressBarPainter(
                  videoPlayerValue!,
                  flutterExtendedProgressBarConfig: widget.flutterExtendedProgressBarConfig.copyWith(
                    circleHandlerRadius: flutterExtendedCtr.isOverlayVisible ||
                            widget
                                .flutterExtendedProgressBarConfig.alwaysVisibleCircleHandler
                        ? widget.flutterExtendedProgressBarConfig.circleHandlerRadius
                        : 0,
                  ),
                ),
                size: Size(
                  double.maxFinite,
                  widget.flutterExtendedProgressBarConfig.height,
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
  _ProgressBarPainter(this.value, {this.flutterExtendedProgressBarConfig});

  VideoPlayerValue value;
  FlutterExtendedProgressBarConfig? flutterExtendedProgressBarConfig;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double height = flutterExtendedProgressBarConfig!.height;
    final double width = size.width;
    final double curveRadius = flutterExtendedProgressBarConfig!.curveRadius;
    final double circleHandlerRadius =
        flutterExtendedProgressBarConfig!.circleHandlerRadius;
    final Paint backgroundPaint =
        flutterExtendedProgressBarConfig!.getBackgroundPaint != null
            ? flutterExtendedProgressBarConfig!.getBackgroundPaint!(
                width: width,
                height: height,
                circleHandlerRadius: circleHandlerRadius,
              )
            : Paint()
        ..color = flutterExtendedProgressBarConfig!.backgroundColor;
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

      final Paint bufferedPaint = flutterExtendedProgressBarConfig!.getBufferedPaint != null
          ? flutterExtendedProgressBarConfig!.getBufferedPaint!(
              width: width,
              height: height,
              playedPart: playedPart,
              circleHandlerRadius: circleHandlerRadius,
              bufferedStart: start,
              bufferedEnd: end,
            )
          : Paint()
        ..color = flutterExtendedProgressBarConfig!.bufferedBarColor;

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

    final Paint playedPaint = flutterExtendedProgressBarConfig!.getPlayedPaint != null
        ? flutterExtendedProgressBarConfig!.getPlayedPaint!(
            width: width,
            height: height,
            playedPart: playedPart,
            circleHandlerRadius: circleHandlerRadius,
          )
        : Paint()
      ..color = flutterExtendedProgressBarConfig!.playingBarColor;
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
        flutterExtendedProgressBarConfig!.getCircleHandlerPaint != null
            ? flutterExtendedProgressBarConfig!.getCircleHandlerPaint!(
                width: width,
                height: height,
                playedPart: playedPart,
                circleHandlerRadius: circleHandlerRadius,
              )
            : Paint()
          ..color = flutterExtendedProgressBarConfig!.circleHandlerColor;

    canvas.drawCircle(
      Offset(playedPart, height / 2),
      circleHandlerRadius,
      handlePaint,
    );
  }
}
