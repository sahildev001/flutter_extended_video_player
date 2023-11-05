# HOP VIDEO Player

HOP VIDEO Player is a user-friendly and versatile video player that offers an interface similar to YouTube's player with customizable controls. It's capable of playing videos from various sources, including YouTube and Vimeo, by providing the URL or video ID. Additionally, HOP VIDEO Player provides a callback to track video drag and seek events, allowing you to monitor how much of the video has been skipped.

## Installation

To use HOP VIDEO Player in your project, follow these steps:

1. Add the HOP VIDEO Player package to your `pubspec.yaml` file as a dependency:

```yaml
dependencies:
  hop_video_player:
    git:
      url: https://github.com/sahildev001/hop_video_player.git
```

2. Run `flutter pub get` to fetch and install the package.

3. Import the package in your Dart code:

```dart
import 'package:hop_video_player/hop_video_player.dart';
```

## Usage

Here's a basic example of how to use HOP VIDEO Player in your Flutter application:

```dart
import 'package:flutter/material.dart';
import 'package:hop_video_player/hop_video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HOP VIDEO Player Example'),
        ),
        body: Center(
          child:  HopVideoPlayer(
            alwaysShowProgressBar: alwaysShowProgressBar,
            controller: controller,
            matchFrameAspectRatioToVideo: true,
            matchVideoAspectRatioToFrame: true,
            videoTitle: videoTitle,
          ),
        ),
      ),
    );
  }
}
```

In the code above, we import the `hop_video_player` package and use the `HopVideoPlayer` widget to display a video. You can provide the video's URL or ID as the `videoUrl` parameter. Additionally, you can customize the player's controls and appearance by passing additional parameters to the `HopVideoPlayer` widget.

Feel free to explore the package's documentation and examples for more advanced usage and customization options.

## Customization

HOP VIDEO Player offers customization options for video controls, appearance, and more. Please refer to the package's documentation for detailed information on how to tailor the player to your specific needs.

## License

HOP VIDEO Player is open source software and is distributed under the MIT License. Check the license file in the package repository for more details.

---

For any questions or issues related to HOP VIDEO Player, please visit the [GitHub repository](https://github.com/sahildev001/hop_video_player.git) or create an issue there.

Enjoy using HOP VIDEO Player in your Flutter applications!