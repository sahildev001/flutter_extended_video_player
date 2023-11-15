part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

class FullScreenView extends StatefulWidget {
  final String tag;
  const FullScreenView({
    required this.tag,
    super.key,
  });

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView>
    with TickerProviderStateMixin {
  late FlutterExtendedVideoPlayerGetXVideoController _flutterExtendedCtr;
  @override
  void initState() {
    _flutterExtendedCtr = Get.find<FlutterExtendedVideoPlayerGetXVideoController>(tag: widget.tag);
    _flutterExtendedCtr.fullScreenContext = context;
    _flutterExtendedCtr.keyboardFocusWeb?.removeListener(_flutterExtendedCtr.keyboadListner);

    super.initState();
  }

  @override
  void dispose() {
    _flutterExtendedCtr.keyboardFocusWeb?.requestFocus();
    _flutterExtendedCtr.keyboardFocusWeb?.addListener(_flutterExtendedCtr.keyboadListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _flutterExtendedCtr.onLoading?.call(context) ??
        const CircularProgressIndicator(
          backgroundColor: Colors.black87,
          color: Colors.white,
          strokeWidth: 2,
        );

    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          await _flutterExtendedCtr.disableFullScreen(
            context,
            widget.tag,
            enablePop: false,
          );
        }
        if (!kIsWeb) await _flutterExtendedCtr.disableFullScreen(context, widget.tag);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
          tag: widget.tag,
          builder: (flutterExtendedCtr) => Center(
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: flutterExtendedCtr.videoCtr == null
                      ? loadingWidget
                      : flutterExtendedCtr.videoCtr!.value.isInitialized
                          ? _FlutterExtendedCoreVideoPlayer(
                              tag: widget.tag,
                              videoPlayerCtr: flutterExtendedCtr.videoCtr!,
                              videoAspectRatio:
                                  flutterExtendedCtr.videoCtr?.value.aspectRatio ?? 16 / 9,

                            )
                          : loadingWidget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
