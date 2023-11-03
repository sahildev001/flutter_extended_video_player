part of 'package:hop_video_player/src/hop_video_player.dart';

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
      child: GetBuilder<HopVideoPlayerGetXVideoController>(
        tag: widget.tag,
        builder: (hopCtr) {
          return MaterialIconButton(
            toolTipMesg: hopCtr.hopVideoPlayerLabels.settings,
            color: Colors.white,
            child: const Icon(Icons.settings),
            onPressed: () => hopCtr.isFullScreen
                ? hopCtr.isWebPopupOverlayOpen = true
                : hopCtr.isWebPopupOverlayOpen = false,
            onTapDown: (details) async {
              final settingsMenu = await showMenu<String>(
                context: context,
                items: [
                  if (hopCtr.vimeoOrVideoUrls.isNotEmpty)
                    PopupMenuItem(
                      value: 'OUALITY',
                      child: _bottomSheetTiles(
                        title: hopCtr.hopVideoPlayerLabels.quality,
                        icon: Icons.video_settings_rounded,
                        subText: '${hopCtr.vimeoPlayingVideoQuality}p',
                      ),
                    ),
                  PopupMenuItem(
                    value: 'LOOP',
                    child: _bottomSheetTiles(
                      title: hopCtr.hopVideoPlayerLabels.loopVideo,
                      icon: Icons.loop_rounded,
                      subText: hopCtr.isLooping
                          ? hopCtr.hopVideoPlayerLabels.optionEnabled
                          : hopCtr.hopVideoPlayerLabels.optionDisabled,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'SPEED',
                    child: _bottomSheetTiles(
                      title: hopCtr.hopVideoPlayerLabels.playbackSpeed,
                      icon: Icons.slow_motion_video_rounded,
                      subText: hopCtr.currentPaybackSpeed,
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
                  await _onVimeoQualitySelect(details, hopCtr);
                  break;
                case 'SPEED':
                  await _onPlaybackSpeedSelect(details, hopCtr);
                  break;
                case 'LOOP':
                  hopCtr.isWebPopupOverlayOpen = false;
                  await hopCtr.toggleLooping();
                  break;
                default:
                  hopCtr.isWebPopupOverlayOpen = false;
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _onPlaybackSpeedSelect(
    TapDownDetails details,
    HopVideoPlayerGetXVideoController hopCtr,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    await showMenu(
      context: context,
      items: hopCtr.videoPlaybackSpeeds
          .map(
            (e) => PopupMenuItem<dynamic>(
              child: ListTile(
                title: Text(e),
              ),
              onTap: () {
                hopCtr.setVideoPlayBack(e);
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
    hopCtr.isWebPopupOverlayOpen = false;
  }

  Future<void> _onVimeoQualitySelect(
    TapDownDetails details,
    HopVideoPlayerGetXVideoController hopCtr,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 400),
    );
    await showMenu(
      context: context,
      items: hopCtr.vimeoOrVideoUrls
          .map(
            (e) => PopupMenuItem<dynamic>(
              child: ListTile(
                title: Text('${e.quality}p'),
              ),
              onTap: () {
                hopCtr.changeVideoQuality(
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
    hopCtr.isWebPopupOverlayOpen = false;
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
