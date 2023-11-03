import '../../hop_video_player.dart';

class OverLayOptions {
  final HopVideoPlayerVideoState hopVideoPlayerVideoState;
  final Duration videoDuration;
  final Duration videoPosition;
  final bool isFullScreen;
  final bool isLooping;
  final bool isOverlayVisible;
  final bool isMute;
  final bool autoPlay;
  final String currentVideoPlaybackSpeed;
  final List<String> videoPlayBackSpeeds;
  final HopVideoPlayerType videoPlayerType;
  final HopProgressBar hopProgresssBar;
  OverLayOptions({
    required this.hopVideoPlayerVideoState,
    required this.videoDuration,
    required this.videoPosition,
    required this.isFullScreen,
    required this.isLooping,
    required this.isOverlayVisible,
    required this.isMute,
    required this.autoPlay,
    required this.currentVideoPlaybackSpeed,
    required this.videoPlayBackSpeeds,
    required this.videoPlayerType,
    required this.hopProgresssBar,
  });
}
