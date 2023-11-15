import 'dart:developer';

import '../../flutter_extended_video_player.dart';

void FlutterExtendedVideoPlayerLog(String message) =>
    FlutterExtendedVideoPlayer.enableLogs ? log(message, name: 'FlutterExtendedVideoPlayer') : null;
