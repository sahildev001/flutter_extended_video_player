import 'dart:io';

import '../../flutter_extended_video_player.dart';

class PlayVideoFrom {
  final String? dataSource;
  final String? hash;
  final FlutterExtendedVideoPlayerType playerType;
  final VideoFormat? formatHint;
  final String? package;
  final File? file;
  final List<VideoQalityUrls>? videoQualityUrls;
  final Future<ClosedCaptionFile>? closedCaptionFile;
  final VideoPlayerOptions? videoPlayerOptions;
  final Map<String, String> httpHeaders;
  final bool live;

  const PlayVideoFrom._({
    required this.playerType,
    this.live = false,
    this.dataSource,
    this.hash,
    this.formatHint,
    this.package,
    this.file,
    this.videoQualityUrls,
    this.closedCaptionFile,
    this.videoPlayerOptions,
    this.httpHeaders = const {},
  });

  factory PlayVideoFrom.network(
    String dataSource, {
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const {},
  }) {
    return PlayVideoFrom._(
      playerType: FlutterExtendedVideoPlayerType.network,
      dataSource: dataSource,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    );
  }

  factory PlayVideoFrom.asset(
    String dataSource, {
    String? package,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
  }) {
    return PlayVideoFrom._(
      playerType: FlutterExtendedVideoPlayerType.asset,
      dataSource: dataSource,
      package: package,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  ///File Doesnot support web apps
  ///[file] is `File` Datatype import it from `dart:io`
  factory PlayVideoFrom.file(
    File file, {
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
  }) {
    return PlayVideoFrom._(
      file: file,
      playerType: FlutterExtendedVideoPlayerType.file,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
    );
  }

  factory PlayVideoFrom.vimeo(
    String dataSource, {
    String? hash,
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const {},
  }) {
    return PlayVideoFrom._(
      playerType: FlutterExtendedVideoPlayerType.vimeo,
      dataSource: dataSource,
      hash: hash,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    );
  }

  factory PlayVideoFrom.vimeoPrivateVideos(
    String dataSource, {
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const {},
  }) {
    return PlayVideoFrom._(
      playerType: FlutterExtendedVideoPlayerType.vimeoPrivateVideos,
      dataSource: dataSource,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    );
  }
  factory PlayVideoFrom.youtube(
    String dataSource, {
    bool live = false,
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const {},
  }) {
    return PlayVideoFrom._(
      live: live,
      playerType: FlutterExtendedVideoPlayerType.youtube,
      dataSource: dataSource,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    );
  }
  factory PlayVideoFrom.networkQualityUrls({
    required List<VideoQalityUrls> videoUrls,
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const {},
  }) {
    return PlayVideoFrom._(
      playerType: FlutterExtendedVideoPlayerType.networkQualityUrls,
      videoQualityUrls: videoUrls,
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    );
  }
}
