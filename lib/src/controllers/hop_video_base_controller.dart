part of 'hop_getx_video_controller.dart';
// ignore_for_file: prefer_final_fields

class _HopVideoBaseController extends GetxController {
  ///main video controller
  VideoPlayerController? _videoCtr;

  ///
  late HopVideoPlayerType _videoPlayerType;

  bool isMute = false;
  FocusNode? keyboardFocusWeb;

  bool autoPlay = true;
  bool _isWebAutoPlayDone = false;

  ///
  HopVideoPlayerVideoState _hopVideoPlayerVideoState = HopVideoPlayerVideoState.loading;

  ///
  bool isWebPopupOverlayOpen = false;

  ///
  Duration _videoDuration = Duration.zero;

  Duration _videoPosition = Duration.zero;

  String _currentPaybackSpeed = '1x';

  bool? isVideoUiBinded;

  bool? wasVideoPlayingOnUiDispose;

  int doubleTapForwardSeconds = 10;
  String? playingVideoUrl;

  late BuildContext mainContext;
  late BuildContext fullScreenContext;

  ///**listners

  Future<void> videoListner() async {
    if (!_videoCtr!.value.isInitialized) {
      await _videoCtr!.initialize();
    }

    if (_videoCtr!.value.isInitialized) {
      // _listneToVideoState();
      _listneToVideoPosition();
      _listneToVolume();
      if (kIsWeb && autoPlay && isMute && !_isWebAutoPlayDone) _webAutoPlay();
    }

    if(_videoCtr!.value.isCompleted){
      hopVideoStateChanger(HopVideoPlayerVideoState.finished);
      hopVideoStateChanger(HopVideoPlayerVideoState.paused);
    }
  }

  void _webAutoPlay() => _videoCtr!.setVolume(1);

  void _listneToVolume() {
    if (_videoCtr!.value.volume == 0) {
      if (!isMute) {
        isMute = true;
        update(['volume']);
        update(['update-all']);
      }
    } else {
      if (isMute) {
        isMute = false;
        update(['volume']);
        update(['update-all']);
      }
    }
  }



  ///updates state with id `_hopVideoPlayerVideoState`
  void hopVideoStateChanger(HopVideoPlayerVideoState? val, {bool updateUi = true}) {
    if (_hopVideoPlayerVideoState != (val ?? _hopVideoPlayerVideoState)) {
      _hopVideoPlayerVideoState = val ?? _hopVideoPlayerVideoState;
      if (updateUi) {
        update(['hopVideoPlayerVideoState']);
        update(['update-all']);
      }
    }
  }

  void _listneToVideoPosition() {
    if ((_videoCtr?.value.duration.inSeconds ?? Duration.zero.inSeconds) < 60) {
      _videoPosition = _videoCtr?.value.position ?? Duration.zero;
      update(['video-progress']);
      update(['update-all']);
    } else {
      if (_videoPosition.inSeconds !=
          (_videoCtr?.value.position ?? Duration.zero).inSeconds) {
        _videoPosition = _videoCtr?.value.position ?? Duration.zero;
        update(['video-progress']);
        update(['update-all']);
      }
    }
  }

  void keyboadListner() {
    if (keyboardFocusWeb != null && !keyboardFocusWeb!.hasFocus) {
      if (keyboardFocusWeb!.canRequestFocus) {
        keyboardFocusWeb!.requestFocus();
      }
    }
  }


}
