part of 'flutter_extended_getx_video_controller.dart';

class _FlutterExtendedUiController extends _FlutterExtendedVideoBaseController {
  bool alwaysShowProgressBar = true;
  FlutterExtendedProgressBarConfig flutterExtendedProgressBarConfig = const FlutterExtendedProgressBarConfig();
  Widget Function(OverLayOptions options)? overlayBuilder;
  Widget? videoTitle;
  DecorationImage? videoThumbnail;




  /// Callback when fullscreen mode changes
  Future<void> Function(bool isFullScreen)? onToggleFullScreen;

  /// Builder for custom loading widget
  WidgetBuilder? onLoading;

  ///video player labels
  FlutterExtendedVideoPlayerLables flutterExtendedVideoPlayerLables = const FlutterExtendedVideoPlayerLables();
}
