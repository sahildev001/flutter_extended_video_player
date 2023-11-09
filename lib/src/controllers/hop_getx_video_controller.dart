import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as uni_html;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../hop_video_player.dart';
import '../utils/logger.dart';
import '../utils/video_apis.dart';

part 'hop_video_base_controller.dart';
part 'hop_video_gestures_controller.dart';
part 'hop_ui_controller.dart';
part 'hop_video_controller.dart';
part 'hop_video_video_quality_controller.dart';

class HopVideoPlayerGetXVideoController extends _HopGesturesController {
  ///main videoplayer controller
  VideoPlayerController? get videoCtr => _videoCtr;

  ///hopVideoPlayer state notifier
  HopVideoPlayerVideoState get hopVideoPlayerVideoState => _hopVideoPlayerVideoState;

  ///vimeo or general --video player type
  HopVideoPlayerType get videoPlayerType => _videoPlayerType;

  String get currentPaybackSpeed => _currentPaybackSpeed;

  ///
  Duration get videoDuration => _videoDuration;

  ///
  Duration get videoPosition => _videoPosition;

  bool controllerInitialized = false;
  late HopPlayerConfig hopPlayerConfig;
  late PlayVideoFrom playVideoFrom;
  void config({
    required PlayVideoFrom playVideoFrom,
    required HopPlayerConfig playerConfig,
  }) {
    this.playVideoFrom = playVideoFrom;
    _videoPlayerType = playVideoFrom.playerType;
    hopPlayerConfig = playerConfig;
    autoPlay = playerConfig.autoPlay;
    isLooping = playerConfig.isLooping;
  }

  ///*init
  Future<void> videoInit() async {
    ///
    // checkPlayerType();
    HopVideoPlayerLog(_videoPlayerType.toString());
    try {
      await _initializePlayer();
      await _videoCtr?.initialize();
      _videoDuration = _videoCtr?.value.duration ?? Duration.zero;
      await setLooping(isLooping);
      _videoCtr?.addListener(videoListner);
      addListenerId('hopVideoPlayerVideoState', hopVideoStateListner);

      checkAutoPlayVideo();
      controllerInitialized = true;
      update();

      update(['update-all']);
      // ignore: unawaited_futures
      Future<void>.delayed(const Duration(milliseconds: 600))
          .then((_) => _isWebAutoPlayDone = true);
    } catch (e) {
      hopVideoStateChanger(HopVideoPlayerVideoState.error);
      update(['errorState']);
      update(['update-all']);
      HopVideoPlayerLog('ERROR ON hop_video_player:  $e');
      rethrow;
    }
  }

  Future<void> _initializePlayer() async {
    switch (_videoPlayerType) {
      case HopVideoPlayerType.network:

        ///
        _videoCtr = VideoPlayerController.networkUrl(
          Uri.parse(playVideoFrom.dataSource!),
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          formatHint: playVideoFrom.formatHint,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
          httpHeaders: playVideoFrom.httpHeaders,
        );
        playingVideoUrl = playVideoFrom.dataSource;
        break;
      case HopVideoPlayerType.networkQualityUrls:
        final url = await getUrlFromVideoQualityUrls(
          qualityList: hopPlayerConfig.videoQualityPriority,
          videoUrls: playVideoFrom.videoQualityUrls!,
        );

        ///
        _videoCtr = VideoPlayerController.networkUrl(
          Uri.parse(url),
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          formatHint: playVideoFrom.formatHint,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
          httpHeaders: playVideoFrom.httpHeaders,
        );
        playingVideoUrl = url;

        break;
      case HopVideoPlayerType.youtube:
        final urls = await getVideoQualityUrlsFromYoutube(
          playVideoFrom.dataSource!,
          playVideoFrom.live,
        );
        final url = await getUrlFromVideoQualityUrls(
          qualityList: hopPlayerConfig.videoQualityPriority,
          videoUrls: urls,
        );

        ///
        _videoCtr = VideoPlayerController.networkUrl(
          Uri.parse(url),
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          formatHint: playVideoFrom.formatHint,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
          httpHeaders: playVideoFrom.httpHeaders,
        );
        playingVideoUrl = url;

        break;
      case HopVideoPlayerType.vimeo:
        await getQualityUrlsFromVimeoId(
          playVideoFrom.dataSource!,
          hash: playVideoFrom.hash,
        );
        final url = await getUrlFromVideoQualityUrls(
          qualityList: hopPlayerConfig.videoQualityPriority,
          videoUrls: vimeoOrVideoUrls,
        );

        _videoCtr = VideoPlayerController.networkUrl(
          Uri.parse(url),
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          formatHint: playVideoFrom.formatHint,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
          httpHeaders: playVideoFrom.httpHeaders,
        );
        playingVideoUrl = url;

        break;
      case HopVideoPlayerType.asset:

        ///
        _videoCtr = VideoPlayerController.asset(
          playVideoFrom.dataSource!,
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          package: playVideoFrom.package,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
        );
        playingVideoUrl = playVideoFrom.dataSource;

        break;
      case HopVideoPlayerType.file:
        if (kIsWeb) {
          throw Exception('file doesnt support web');
        }

        ///
        _videoCtr = VideoPlayerController.file(
          playVideoFrom.file!,
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
        );

        break;
      case HopVideoPlayerType.vimeoPrivateVideos:
        await getQualityUrlsFromVimeoPrivateId(
          playVideoFrom.dataSource!,
          playVideoFrom.httpHeaders,
        );
        final url = await getUrlFromVideoQualityUrls(
          qualityList: hopPlayerConfig.videoQualityPriority,
          videoUrls: vimeoOrVideoUrls,
        );

        _videoCtr = VideoPlayerController.networkUrl(
          Uri.parse(url),
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          formatHint: playVideoFrom.formatHint,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
          httpHeaders: playVideoFrom.httpHeaders,
        );
        playingVideoUrl = url;

        break;
    }
  }

  ///Listning on keyboard events
  void onKeyBoardEvents({
    required RawKeyEvent event,
    required BuildContext appContext,
    required String tag,
  }) {
    if (kIsWeb) {
      if (event.isKeyPressed(LogicalKeyboardKey.space)) {
        togglePlayPauseVideo();
        return;
      }
      if (event.isKeyPressed(LogicalKeyboardKey.keyM)) {
        toggleMute();
        return;
      }
      if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        onLeftDoubleTap();
        return;
      }
      if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        onRightDoubleTap();
        return;
      }
      if (event.isKeyPressed(LogicalKeyboardKey.keyF) &&
          event.logicalKey.keyLabel == 'F') {
        toggleFullScreenOnWeb(appContext, tag);
      }
      if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
        if (isFullScreen) {
          uni_html.document.exitFullscreen();
          if (!isWebPopupOverlayOpen) {
            disableFullScreen(appContext, tag);
          }
        }
      }

      return;
    }
  }

  void toggleFullScreenOnWeb(BuildContext context, String tag) {
    if (isFullScreen) {
      uni_html.document.exitFullscreen();
      if (!isWebPopupOverlayOpen) {
        disableFullScreen(context, tag);
      }
    } else {
      uni_html.document.documentElement?.requestFullscreen();
      enableFullScreen(tag);
    }
  }

  ///this func will listen to update id `_hopVideoState`
  void hopVideoStateListner() {
    HopVideoPlayerLog(_hopVideoPlayerVideoState.toString());
    switch (_hopVideoPlayerVideoState) {
      case HopVideoPlayerVideoState.playing:
        if (hopPlayerConfig.wakelockEnabled) WakelockPlus.enable();
        playVideo(true);
        break;
      case HopVideoPlayerVideoState.paused:
        if (hopPlayerConfig.wakelockEnabled) WakelockPlus.disable();
        playVideo(false);
        break;
      case HopVideoPlayerVideoState.loading:
        isShowOverlay(true);
        break;
      case HopVideoPlayerVideoState.error:
        if (hopPlayerConfig.wakelockEnabled) WakelockPlus.disable();
        playVideo(false);
        break;
      case HopVideoPlayerVideoState.finished:
        // TODO: Handle this case.
        break;
    }
  }

  ///checkes wether video should be `autoplayed` initially
  void checkAutoPlayVideo() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (autoPlay && (isVideoUiBinded ?? false)) {
        if (kIsWeb) await _videoCtr?.setVolume(0);
        hopVideoStateChanger(HopVideoPlayerVideoState.playing);
      } else {
        hopVideoStateChanger(HopVideoPlayerVideoState.paused);
      }
    });
  }

  Future<void> changeVideo({
    required PlayVideoFrom playVideoFrom,
    required HopPlayerConfig playerConfig,
  }) async {
    _videoCtr?.removeListener(videoListner);
    hopVideoStateChanger(HopVideoPlayerVideoState.paused);
    hopVideoStateChanger(HopVideoPlayerVideoState.loading);
    keyboardFocusWeb?.removeListener(keyboadListner);
    removeListenerId('hopVideoPlayerVideoState', hopVideoStateListner);
    _isWebAutoPlayDone = false;
    vimeoOrVideoUrls = [];
    config(playVideoFrom: playVideoFrom, playerConfig: playerConfig);
    keyboardFocusWeb?.requestFocus();
    keyboardFocusWeb?.addListener(keyboadListner);
    await videoInit();
  }
}
