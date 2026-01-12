<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

`custom_time_picker` adds `showCustomTimePicker`, a drop-in-ish variant of
Flutter’s Material `showTimePicker` that restricts selection to a
`minTime`–`maxTime` range (inclusive). If `minTime` is later than `maxTime`, the
range is treated as crossing midnight (e.g. 22:00–02:00).

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
import 'package:custom_time_picker/custom_time_picker.dart';
import 'package:flutter/material.dart';

Future<void> pick(BuildContext context) async {
  final TimeOfDay? result = await showCustomTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 12, minute: 0),
    minTime: const TimeOfDay(hour: 9, minute: 0),
    maxTime: const TimeOfDay(hour: 17, minute: 0),
  );

  if (result == null) return;
  // Use the picked time.
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
