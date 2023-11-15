part of 'package:flutter_extended_video_player/src/flutter_extended_video_player.dart';

class _WebSettingsDropdown extends StatefulWidget {
  final String tag;

  const _WebSettingsDropdown({
    required this.tag,
  });

  @override
  State<_WebSettingsDropdown> createState() => _WebSettingsDropdownState();
}

class _WebSettingsDropdownState extends State<_WebSettingsDropdown> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: Colors.white,
      ),
      child: GetBuilder<FlutterExtendedVideoPlayerGetXVideoController>(
        tag: widget.tag,
        builder: (flutterExtendedCtr) {
          return MaterialIconButton(
            toolTipMesg: flutterExtendedCtr.flutterExtendedVideoPlayerLables.settings,
            color: Colors.white,
            child: const Icon(Icons.settings),
            onPressed: () => flutterExtendedCtr.isFullScreen
                ? flutterExtendedCtr.isWebPopupOverlayOpen = true
                : flutterExtendedCtr.isWebPopupOverlayOpen = false,
            onTapDown: (details) async {
              final settingsMenu = await showMenu<String>(
                context: context,
                items: [
                  if (flutterExtendedCtr.vimeoOrVideoUrls.isNotEmpty)
                    PopupMenuItem(
                      value: 'OUALITY',
                      child: _bottomSheetTiles(
                        title: flutterExtendedCtr.flutterExtendedVideoPlayerLables.quality,
                        icon: Icons.video_settings_rounded,
                        subText: '${flutterExtendedCtr.vimeoPlayingVideoQuality}p',
                      ),
                    ),
                  PopupMenuItem(
                    value: 'LOOP',
                    child: _bottomSheetTiles(
                      title: flutterExtendedCtr.flutterExtendedVideoPlayerLables.loopVideo,
                      icon: Icons.loop_rounded,
                      subText: flutterExtendedCtr.isLooping
                          ? flutterExtendedCtr.flutterExtendedVideoPlayerLables.optionEnabled
                          : flutterExtendedCtr.flutterExtendedVideoPlayerLables.optionDisabled,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'SPEED',
                    child: _bottomSheetTiles(
                      title: flutterExtendedCtr.flutterExtendedVideoPlayerLables.playbackSpeed,
                      icon: Icons.slow_motion_video_rounded,
                      subText: flutterExtendedCtr.currentPaybackSpeed,
                    ),
                  ),
                ],
                position: RelativeRect.fromSize(
                  details.globalPosition & Size.zero,
                  MediaQuery.of(context).size,
                ),
              );
              switch (settingsMenu) {
                case 'OUALITY':
                  await _onVimeoQualitySelect(details, flutterExtendedCtr);
                  break;
                case 'SPEED':
                  await _onPlaybackSpeedSelect(details, flutterExtendedCtr);
                  break;
                case 'LOOP':
                  flutterExtendedCtr.isWebPopupOverlayOpen = false;
                  await flutterExtendedCtr.toggleLooping();
                  break;
                default:
                  flutterExtendedCtr.isWebPopupOverlayOpen = false;
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _onPlaybackSpeedSelect(
    TapDownDetails details,
      FlutterExtendedVideoPlayerGetXVideoController flutterExtendedCtr,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    await showMenu(
      context: context,
      items: flutterExtendedCtr.videoPlaybackSpeeds
          .map(
            (e) => PopupMenuItem<dynamic>(
              child: ListTile(
                title: Text(e),
              ),
              onTap: () {
                flutterExtendedCtr.setVideoPlayBack(e);
              },
            ),
          )
          .toList(),
      position: RelativeRect.fromSize(
        details.globalPosition & Size.zero,
        // ignore: use_build_context_synchronously
        MediaQuery.of(context).size,
      ),
    );
    flutterExtendedCtr.isWebPopupOverlayOpen = false;
  }

  Future<void> _onVimeoQualitySelect(
    TapDownDetails details,
      FlutterExtendedVideoPlayerGetXVideoController flutterExtendedCtr,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    await showMenu(
      context: context,
      items: flutterExtendedCtr.vimeoOrVideoUrls
          .map(
            (e) => PopupMenuItem<dynamic>(
              child: ListTile(
                title: Text('${e.quality}p'),
              ),
              onTap: () {
                flutterExtendedCtr.changeVideoQuality(
                  e.quality,
                );
              },
            ),
          )
          .toList(),
      position: RelativeRect.fromSize(
        details.globalPosition & Size.zero,
        // ignore: use_build_context_synchronously
        MediaQuery.of(context).size,
      ),
    );
    flutterExtendedCtr.isWebPopupOverlayOpen = false;
  }

  Widget _bottomSheetTiles({
    required String title,
    required IconData icon,
    String? subText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(width: 20),
            Text(
              title,
            ),
            if (subText != null) const SizedBox(width: 10),
            if (subText != null)
              const SizedBox(
                height: 4,
                width: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              Text(
                subText,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
