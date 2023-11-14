# Flutter extended VIDEO Player

Flutter Extended VIDEO Player is a user-friendly and versatile video player that offers an interface similar to YouTube's player with customizable controls. It's capable of playing videos from various sources, including YouTube and Vimeo, by providing the URL or video ID. Additionally, Flutter Extended VIDEO Player provides a callback to track video drag and seek events, allowing you to monitor how much of the video has been skipped.

## Installation

To use Flutter Extended VIDEO Player in your project, follow these steps:

1. Add the Flutter Extended VIDEO Player package to your `pubspec.yaml` file as a dependency:

```yaml
dependencies:
  Flutter Extended_video_player:
    git:
      url: https://github.com/sahildev001/Flutter Extended_video_player.git
```

2. Run `flutter pub get` to fetch and install the package.

3. Import the package in your Dart code:

```dart
import 'package:Flutter Extended_video_player/Flutter Extended_video_player.dart';
```

## Usage

Here's a basic example of how to use Flutter Extended VIDEO Player in your Flutter application:

```dart
import 'package:flutter/material.dart';
import 'package:Flutter Extended_video_player/Flutter Extended_video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Extended VIDEO Player Example'),
        ),
        body: Center(
          child:  Flutter ExtendedVideoPlayer(
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

In the code above, we import the `Flutter Extended_video_player` package and use the `Flutter ExtendedVideoPlayer` widget to display a video. You can provide the video's URL or ID as the `videoUrl` parameter. Additionally, you can customize the player's controls and appearance by passing additional parameters to the `Flutter ExtendedVideoPlayer` widget.

Feel free to explore the package's documentation and examples for more advanced usage and customization options.

## Customization

Flutter Extended VIDEO Player offers customization options for video controls, appearance, and more. Please refer to the package's documentation for detailed information on how to tailor the player to your specific needs.

## License

Flutter Extended VIDEO Player is open source software and is distributed under the MIT License. Check the license file in the package repository for more details.

---

For any questions or issues related to Flutter Extended VIDEO Player, please visit the [GitHub repository](https://github.com/sahildev001/Flutter Extended_video_player.git) or create an issue there.

Enjoy using Flutter Extended VIDEO Player in your Flutter applications!
