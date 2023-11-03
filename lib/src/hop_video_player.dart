import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as uni_html;

import '../hop_video_player.dart';
import 'controllers/hop_getx_video_controller.dart';
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

part 'widgets/core/hop_video_core_player.dart';

part 'widgets/core/video_gesture_detector.dart';

part 'widgets/full_screen_view.dart';

class HopVideoPlayer extends StatefulWidget {
  final HopVideoPlayerController controller;
  final double frameAspectRatio;
  final double videoAspectRatio;
  final bool alwaysShowProgressBar;
  final bool matchVideoAspectRatioToFrame;
  final bool matchFrameAspectRatioToVideo;
  final HopProgressBarConfig hopProgressBarConfig;
  final HopVideoPlayerLabels hopPlayerLabels;
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

  HopVideoPlayer({
    required this.controller,
    super.key,
    this.frameAspectRatio = 16 / 9,
    this.videoAspectRatio = 16 / 9,
    this.alwaysShowProgressBar = true,
    this.hopProgressBarConfig = const HopProgressBarConfig(),
    this.hopPlayerLabels = const HopVideoPlayerLabels(),
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
    Get.find<HopVideoPlayerGetXVideoController>(tag: controller.getTag)

      ///add to ui controller
      ..hopVideoPlayerLabels = hopPlayerLabels
      ..alwaysShowProgressBar = alwaysShowProgressBar
      ..hopProgressBarConfig = hopProgressBarConfig
      ..overlayBuilder = overlayBuilder
      ..videoTitle = videoTitle
      ..onToggleFullScreen = onToggleFullScreen
      ..onLoading = onLoading
      ..videoThumbnail = videoThumbnail;
  }

  @override
  State<HopVideoPlayer> createState() => _HopVideoPlayerState();
}

class _HopVideoPlayerState extends State<HopVideoPlayer>
    with TickerProviderStateMixin {
  late HopVideoPlayerGetXVideoController _hopCtr;

  // late String tag;
  @override
  void initState() {
    super.initState();
    // tag = widget.controller?.tag ?? UniqueKey().toString();
    _hopCtr = Get.put(
      HopVideoPlayerGetXVideoController(),
      permanent: true,
      tag: widget.controller.getTag,
    )..isVideoUiBinded = true;
    if (_hopCtr.wasVideoPlayingOnUiDispose ?? false) {
      _hopCtr.hopVideoStateChanger(HopVideoPlayerVideoState.playing, updateUi: false);
    }
    if (kIsWeb) {
      if (widget.controller.hopPlayerConfig.forcedVideoFocus) {
        _hopCtr.keyboardFocusWeb = FocusNode();
        _hopCtr.keyboardFocusWeb?.addListener(_hopCtr.keyboadListner);
      }
      //to disable mouse right click
      uni_html.document.onContextMenu.listen((event) => event.preventDefault());
    }
  }

  @override
  void dispose() {
    super.dispose();

    ///Checking if the video was playing when this widget is disposed
    if (_hopCtr.isvideoPlaying) {
      _hopCtr.wasVideoPlayingOnUiDispose = true;
    } else {
      _hopCtr.wasVideoPlayingOnUiDispose = false;
    }
    _hopCtr
      ..isVideoUiBinded = false
      ..hopVideoStateChanger(HopVideoPlayerVideoState.paused, updateUi: false);
    if (kIsWeb) {
      _hopCtr.keyboardFocusWeb?.removeListener(_hopCtr.keyboadListner);
    }
    // _hopCtr.keyboardFocus?.unfocus();
    // _hopCtr.keyboardFocusOnFullScreen?.unfocus();
    _hopCtr.hoverOverlayTimer?.cancel();
    _hopCtr.showOverlayTimer?.cancel();
    _hopCtr.showOverlayTimer1?.cancel();
    _hopCtr.leftDoubleTapTimer?.cancel();
    _hopCtr.rightDoubleTapTimer?.cancel();
    HopVideoPlayerLog('local HopVideoPlayer disposed');
  }

  ///
  double _frameAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final circularProgressIndicator = _thumbnailAndLoadingWidget();
    _hopCtr.mainContext = context;

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
              widget.hopPlayerLabels.error,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
    return GetBuilder<HopVideoPlayerGetXVideoController>(
      tag: widget.controller.getTag,
      builder: (_) {
        _frameAspectRatio = widget.matchFrameAspectRatioToVideo
            ? _hopCtr.videoCtr?.value.aspectRatio ?? widget.frameAspectRatio
            : widget.frameAspectRatio;
        return Center(
          child: ColoredBox(
            color: widget.backgroundColor ?? Colors.black,
            child: GetBuilder<HopVideoPlayerGetXVideoController>(
              tag: widget.controller.getTag,
              id: 'errorState',
              builder: (hopCtr) {
                /// Check if has any error
                if (hopCtr.hopVideoPlayerVideoState == HopVideoPlayerVideoState.error) {
                  return widget.onVideoError?.call() ?? videoErrorWidget;
                }

                return AspectRatio(
                  aspectRatio: _frameAspectRatio,
                  child: hopCtr.videoCtr?.value.isInitialized ?? false
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
        ? _hopCtr.videoCtr?.value.aspectRatio ?? widget.videoAspectRatio
        : widget.videoAspectRatio;
    if (kIsWeb) {
      return GetBuilder<HopVideoPlayerGetXVideoController>(
        tag: widget.controller.getTag,
        id: 'full-screen',
        builder: (hopCtr) {
          if (hopCtr.isFullScreen) return _thumbnailAndLoadingWidget();
          return _HopCoreVideoPlayer(
            videoPlayerCtr: hopCtr.videoCtr!,
            videoAspectRatio: videoAspectRatio,
            tag: widget.controller.getTag,

          );
        },
      );
    } else {

      return _HopCoreVideoPlayer(
        videoPlayerCtr: _hopCtr.videoCtr!,
        videoAspectRatio: videoAspectRatio,
        tag: widget.controller.getTag,
      );
    }
  }
}
