part of 'package:hop_video_player/src/hop_video_player.dart';

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
  late HopVideoPlayerGetXVideoController _hopCtr;
  @override
  void initState() {
    _hopCtr = Get.find<HopVideoPlayerGetXVideoController>(tag: widget.tag);
    _hopCtr.fullScreenContext = context;
    _hopCtr.keyboardFocusWeb?.removeListener(_hopCtr.keyboadListner);

    super.initState();
  }

  @override
  void dispose() {
    _hopCtr.keyboardFocusWeb?.requestFocus();
    _hopCtr.keyboardFocusWeb?.addListener(_hopCtr.keyboadListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _hopCtr.onLoading?.call(context) ??
        const CircularProgressIndicator(
          backgroundColor: Colors.black87,
          color: Colors.white,
          strokeWidth: 2,
        );

    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          await _hopCtr.disableFullScreen(
            context,
            widget.tag,
            enablePop: false,
          );
        }
        if (!kIsWeb) await _hopCtr.disableFullScreen(context, widget.tag);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<HopVideoPlayerGetXVideoController>(
          tag: widget.tag,
          builder: (hopCtr) => Center(
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: hopCtr.videoCtr == null
                      ? loadingWidget
                      : hopCtr.videoCtr!.value.isInitialized
                          ? _HopCoreVideoPlayer(
                              tag: widget.tag,
                              videoPlayerCtr: hopCtr.videoCtr!,
                              videoAspectRatio:
                                  hopCtr.videoCtr?.value.aspectRatio ?? 16 / 9,

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
