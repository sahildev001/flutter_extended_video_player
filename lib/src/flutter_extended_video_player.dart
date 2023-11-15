import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as uni_html;

import '../flutter_extended_video_player.dart';
import 'controllers/flutter_extended_getx_video_controller.dart';
import 'utils/logger.dart';
import 'widgets/double_tap_icon.dart';
import 'widgets/material_icon_button.dart';
import 'dart:developer' as dev;
part 'widgets/animated_play_pause_icon.dart';

part 'widgets/core/overlays/mobile_bottomsheet.dart';

part 'widgets/core/overlays/mobile_overlay.dart';

part 'widgets/core/overlays/overlays.dart';

part 'widgets/core/overlays/web_dropdown_menu.dart';

part 'widgets/core/overlays/web_overlay.dart';

part 'widgets/core/flutter_extended_video_core_player.dart';

part 'widgets/core/video_gesture_detector.dart';

part 'widgets/full_screen_view.dart';

class FlutterExtendedVideoPlayer extends StatefulWidget {
  final FlutterExtendedVideoPlayerController controller;
  final double frameAspectRatio;
  final double videoAspectRatio;
  final bool alwaysShowProgressBar;
  final bool matchVideoAspectRatioToFrame;
  final bool matchFrameAspectRatioToVideo;
  final FlutterExtendedProgressBarConfig flutterExtendedProgressBarConfig;
  final FlutterExtendedVideoPlayerLables flutterExtendedVideoPlayerLables;
  final Widget Function(OverLayOptions options)? overlayBuilder;
  final Widget Function()? onVideoError;
  final Widget? videoTitle;
  final Color? backgroundColor;
  final DecorationImage? videoThumbnail;

  /// Optional callback, fired when full screen mode toggles.
  ///
  /// Important: If this method is set, the configuration of [DeviceOrientation]
  /// and [SystemUiMode] is up to you.
  final Future<void> Function(bool isFullScreen)? onToggleFullScreen;

  /// Sets a custom loading widget.
  /// If no widget is informed, a default [CircularProgressIndicator] will be shown.
  final WidgetBuilder? onLoading;

  FlutterExtendedVideoPlayer({
    required this.controller,
    super.key,
    this.frameAspectRatio = 16 / 9,
    this.videoAspectRatio = 16 / 9,
    this.alwaysShowProgressBar = true,
    this.flutterExtendedProgressBarConfig = const FlutterExtendedProgressBarConfig(),
    this.flutterExtendedVideoPlayerLables = const FlutterExtendedVideoPlayerLables(),
    this.overlayBuilder,
    this.videoTitle,
    this.matchVideoAspectRatioToFrame = false,
    this.matchFrameAspectRatioToVideo = false,
    this.onVideoError,
    this.backgroundColor,
    this.videoThumbnail,
    this.onToggleFullScreen,
    this.onLoading,

  }) {
    addToUiController();
  }

  static bool enableLogs = false;
  static bool enableGetxLogs = false;

  void addToUiController() {
    Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: controller.getTag)

      ///add to ui controller
      ..flutterExtendedVideoPlayerLables = flutterExtendedVideoPlayerLables
      ..alwaysShowProgressBar = alwaysShowProgressBar
      ..flutterExtendedProgressBarConfig = flutterExtendedProgressBarConfig
      ..overlayBuilder = overlayBuilder
      ..videoTitle = videoTitle
      ..onToggleFullScreen = onToggleFullScreen
      ..onLoading = onLoading
      ..videoThumbnail = videoThumbnail;
  }

  @override
  State<FlutterExtendedVideoPlayer> createState() => _FlutterExtendedVideoPlayerState();
}

class _FlutterExtendedVideoPlayerState extends State<FlutterExtendedVideoPlayer>
    with TickerProviderStateMixin {
  late FlutterExtendedVideoPlayerGetXVideoController _flutterExtendedCtr;

  // late String tag;
  @override
  void initState() {
    super.initState();
    // tag = widget.controller?.tag ?? UniqueKey().toString();
    _flutterExtendedCtr = Get.put(
      FlutterExtendedVideoPlayerGetXVideoController(),
      permanent: true,
      tag: widget.controller.getTag,
    )..isVideoUiBinded = true;
    if (_flutterExtendedCtr.wasVideoPlayingOnUiDispose ?? false) {
      _flutterExtendedCtr.flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.playing, updateUi: false);
    }
    if (kIsWeb) {
      if (widget.controller.flutterExtendedPlayerConfig.forcedVideoFocus) {
        _flutterExtendedCtr.keyboardFocusWeb = FocusNode();
        _flutterExtendedCtr.keyboardFocusWeb?.addListener(_flutterExtendedCtr.keyboadListner);
      }
      //to disable mouse right click
      uni_html.document.onContextMenu.listen((event) => event.preventDefault());
    }
  }

  @override
  void dispose() {
    super.dispose();

    ///Checking if the video was playing when this widget is disposed
    if (_flutterExtendedCtr.isvideoPlaying) {
      _flutterExtendedCtr.wasVideoPlayingOnUiDispose = true;
    } else {
      _flutterExtendedCtr.wasVideoPlayingOnUiDispose = false;
    }
    _flutterExtendedCtr
      ..isVideoUiBinded = false
      ..flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.paused, updateUi: false);
    if (kIsWeb) {
      _flutterExtendedCtr.keyboardFocusWeb?.removeListener(_flutterExtendedCtr.keyboadListner);
    }
    _flutterExtendedCtr.hoverOverlayTimer?.cancel();
    _flutterExtendedCtr.showOverlayTimer?.cancel();
    _flutterExtendedCtr.showOverlayTimer1?.cancel();
    _flutterExtendedCtr.leftDoubleTapTimer?.cancel();
    _flutterExtendedCtr.rightDoubleTapTimer?.cancel();
    FlutterExtendedVideoPlayerLog('local FlutterExtendedVideoPlayer disposed');
  }

  ///
  double _frameAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final circularProgressIndicator = _thumbnailAndLoadingWidget();
    _flutterExtendedCtr.mainContext = context;

    final videoErrorWidget = AspectRatio(
      aspectRatio: _frameAspectRatio,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.yellow,
              size: 32,
            ),
            const SizedBox(height: 20),
            Text(
              widget.flutterExtendedVideoPlayerLables.error,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
    return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
      tag: widget.controller.getTag,
      builder: (_) {
        _frameAspectRatio = widget.matchFrameAspectRatioToVideo
            ? _flutterExtendedCtr.videoCtr?.value.aspectRatio ?? widget.frameAspectRatio
            : widget.frameAspectRatio;
        return Center(
          child: ColoredBox(
            color: widget.backgroundColor ?? Colors.black,
            child: GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
              tag: widget.controller.getTag,
              id: 'errorState',
              builder: (flutterExtendedCtr) {
                /// Check if has any error
                if (flutterExtendedCtr.flutterExtendedVideoPlayerVideoState == FlutterExtendedVideoPlayerVideoState.error) {
                  return widget.onVideoError?.call() ?? videoErrorWidget;
                }

                return AspectRatio(
                  aspectRatio: _frameAspectRatio,
                  child: flutterExtendedCtr.videoCtr?.value.isInitialized ?? false
                      ? _buildPlayer()
                      : Center(child: circularProgressIndicator),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return widget.onLoading?.call(context) ??
        const CircularProgressIndicator(
          backgroundColor: Colors.black87,
          color: Colors.white,
          strokeWidth: 2,
        );
  }

  Widget _thumbnailAndLoadingWidget() {
    if (widget.videoThumbnail == null) {
      return _buildLoading();
    }

    return SizedBox.expand(
      child: TweenAnimationBuilder<double>(
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: child,
        ),
        tween: Tween<double>(begin: 0.2, end: 0.7),
        duration: const Duration(milliseconds: 400),
        child: DecoratedBox(
          decoration: BoxDecoration(image: widget.videoThumbnail),
          child: Center(
            child: _buildLoading(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final videoAspectRatio = widget.matchVideoAspectRatioToFrame
        ? _flutterExtendedCtr.videoCtr?.value.aspectRatio ?? widget.videoAspectRatio
        : widget.videoAspectRatio;
    if (kIsWeb) {
      return GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
        tag: widget.controller.getTag,
        id: 'full-screen',
        builder: (flutterExtendedCtr) {
          if (flutterExtendedCtr.isFullScreen) return _thumbnailAndLoadingWidget();
          return _FlutterExtendedCoreVideoPlayer(
            videoPlayerCtr: flutterExtendedCtr.videoCtr!,
            videoAspectRatio: videoAspectRatio,
            tag: widget.controller.getTag,

          );
        },
      );
    } else {

      return _FlutterExtendedCoreVideoPlayer(
        videoPlayerCtr: _flutterExtendedCtr.videoCtr!,
        videoAspectRatio: videoAspectRatio,
        tag: widget.controller.getTag,
      );
    }
  }
}
