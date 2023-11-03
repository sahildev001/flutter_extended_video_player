import 'dart:developer';

import '../../hop_video_player.dart';

void HopVideoPlayerLog(String message) =>
    HopVideoPlayer.enableLogs ? log(message, name: 'HopVideoPlayer') : null;
