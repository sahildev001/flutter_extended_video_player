import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as uni_html;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../flutter_extended_video_player.dart';
import '../utils/logger.dart';
import '../utils/video_apis.dart';

part 'flutter_extended_video_base_controller.dart';
part 'flutter_extended_video_gestures_controller.dart';
part 'flutter_extended_ui_controller.dart';
part 'flutter_extended_video_controller.dart';
part 'flutter_extended_video_video_quality_controller.dart';

class FlutterExtendedVideoPlayerGetXVideoController extends _FlutterExtendedGesturesController {
  ///main videoplayer controller
  VideoPlayerController? get videoCtr => _videoCtr;

  ///FlutterExtendedVideoPlayer state notifier
  FlutterExtendedVideoPlayerVideoState get flutterExtendedVideoPlayerVideoState => _flutterExtendedVideoPlayerVideoState;

  ///vimeo or general --video player type
  FlutterExtendedVideoPlayerType get videoPlayerType => _videoPlayerType;

  String get currentPaybackSpeed => _currentPaybackSpeed;

  ///
  Duration get videoDuration => _videoDuration;

  ///
  Duration get videoPosition => _videoPosition;

  bool controllerInitialized = false;
  late FlutterExtendedPlayerConfig flutterExtendedPlayerConfig;
  late PlayVideoFrom playVideoFrom;
  void config({
    required PlayVideoFrom playVideoFrom,
    required FlutterExtendedPlayerConfig playerConfig,
  }) {
    this.playVideoFrom = playVideoFrom;
    _videoPlayerType = playVideoFrom.playerType;
    flutterExtendedPlayerConfig = playerConfig;
    autoPlay = playerConfig.autoPlay;
    isLooping = playerConfig.isLooping;
  }

  ///*init
  Future<void> videoInit() async {
    ///
    // checkPlayerType();
    FlutterExtendedVideoPlayerLog(_videoPlayerType.toString());
    try {
      await _initializePlayer();
      await _videoCtr?.initialize();
      _videoDuration = _videoCtr?.value.duration ?? Duration.zero;
      await setLooping(isLooping);
      _videoCtr?.addListener(videoListner);
      addListenerId('flutterExtendedVideoPlayerVideoState', flutterExtendedVideoStateListner);

      checkAutoPlayVideo();
      controllerInitialized = true;
      update();

      update(['update-all']);
      // ignore: unawaited_futures
      Future<void>.delayed(const Duration(milliseconds: 600))
          .then((_) => _isWebAutoPlayDone = true);
    } catch (e) {
      flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.error);
      update(['errorState']);
      update(['update-all']);
      FlutterExtendedVideoPlayerLog('ERROR ON FlutterExtended_video_player:  $e');
      rethrow;
    }
  }

  Future<void> _initializePlayer() async {
    switch (_videoPlayerType) {
      case FlutterExtendedVideoPlayerType.network:

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
      case FlutterExtendedVideoPlayerType.networkQualityUrls:
        final url = await getUrlFromVideoQualityUrls(
          qualityList: flutterExtendedPlayerConfig.videoQualityPriority,
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
      case FlutterExtendedVideoPlayerType.youtube:
        final urls = await getVideoQualityUrlsFromYoutube(
          playVideoFrom.dataSource!,
          playVideoFrom.live,
        );
        final url = await getUrlFromVideoQualityUrls(
          qualityList: flutterExtendedPlayerConfig.videoQualityPriority,
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
      case FlutterExtendedVideoPlayerType.vimeo:
        await getQualityUrlsFromVimeoId(
          playVideoFrom.dataSource!,
          hash: playVideoFrom.hash,
        );
        final url = await getUrlFromVideoQualityUrls(
          qualityList: flutterExtendedPlayerConfig.videoQualityPriority,
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
      case FlutterExtendedVideoPlayerType.asset:

        ///
        _videoCtr = VideoPlayerController.asset(
          playVideoFrom.dataSource!,
          closedCaptionFile: playVideoFrom.closedCaptionFile,
          package: playVideoFrom.package,
          videoPlayerOptions: playVideoFrom.videoPlayerOptions,
        );
        playingVideoUrl = playVideoFrom.dataSource;

        break;
      case FlutterExtendedVideoPlayerType.file:
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
      case FlutterExtendedVideoPlayerType.vimeoPrivateVideos:
        await getQualityUrlsFromVimeoPrivateId(
          playVideoFrom.dataSource!,
          playVideoFrom.httpHeaders,
        );
        final url = await getUrlFromVideoQualityUrls(
          qualityList: flutterExtendedPlayerConfig.videoQualityPriority,
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

  ///this func will listen to update id `_flutterExtendedVideoState`
  void flutterExtendedVideoStateListner() {
    FlutterExtendedVideoPlayerLog(_flutterExtendedVideoPlayerVideoState.toString());
    switch (_flutterExtendedVideoPlayerVideoState) {
      case FlutterExtendedVideoPlayerVideoState.playing:
        if (flutterExtendedPlayerConfig.wakelockEnabled) WakelockPlus.enable();
        playVideo(true);
        break;
      case FlutterExtendedVideoPlayerVideoState.paused:
        if (flutterExtendedPlayerConfig.wakelockEnabled) WakelockPlus.disable();
        playVideo(false);
        break;
      case FlutterExtendedVideoPlayerVideoState.loading:
        isShowOverlay(true);
        break;
      case FlutterExtendedVideoPlayerVideoState.error:
        if (flutterExtendedPlayerConfig.wakelockEnabled) WakelockPlus.disable();
        playVideo(false);
        break;
      case FlutterExtendedVideoPlayerVideoState.finished:
        // TODO: Handle this case.
        break;
    }
  }

  ///checkes wether video should be `autoplayed` initially
  void checkAutoPlayVideo() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (autoPlay && (isVideoUiBinded ?? false)) {
        if (kIsWeb) await _videoCtr?.setVolume(0);
        flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.playing);
      } else {
        flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.paused);
      }
    });
  }

  Future<void> changeVideo({
    required PlayVideoFrom playVideoFrom,
    required FlutterExtendedPlayerConfig playerConfig,
  }) async {
    _videoCtr?.removeListener(videoListner);
    flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.paused);
    flutterExtendedVideoStateChanger(FlutterExtendedVideoPlayerVideoState.loading);
    keyboardFocusWeb?.removeListener(keyboadListner);
    removeListenerId('flutterExtendedVideoPlayerVideoState', flutterExtendedVideoStateListner);
    _isWebAutoPlayDone = false;
    vimeoOrVideoUrls = [];
    config(playVideoFrom: playVideoFrom, playerConfig: playerConfig);
    keyboardFocusWeb?.requestFocus();
    keyboardFocusWeb?.addListener(keyboadListner);
    await videoInit();
  }
}
