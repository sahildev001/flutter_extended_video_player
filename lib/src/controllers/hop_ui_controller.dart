part of 'hop_getx_video_controller.dart';

class _HopUiController extends _HopVideoBaseController {
  bool alwaysShowProgressBar = true;
  HopProgressBarConfig hopProgressBarConfig = const HopProgressBarConfig();
  Widget Function(OverLayOptions options)? overlayBuilder;
  Widget? videoTitle;
  DecorationImage? videoThumbnail;




  /// Callback when fullscreen mode changes
  Future<void> Function(bool isFullScreen)? onToggleFullScreen;

  /// Builder for custom loading widget
  WidgetBuilder? onLoading;

  ///video player labels
  HopVideoPlayerLabels hopVideoPlayerLabels = const HopVideoPlayerLabels();
}
