import 'package:flutter/material.dart';

import 'highlighted_time_range.dart';

/// Highlight configuration for [showCustomTimePicker].
///
/// This defines a single highlight [color] and a user-facing [label] that can be
/// shown in a key/legend, plus the time-of-day [ranges] that should be
/// highlighted using that color.
class HighlightSpec {
  const HighlightSpec({
    required this.color,
    required this.label,
    this.ranges = const <HighlightedTimeRange>[],
  });

  final Color color;
  final String label;
  final List<HighlightedTimeRange> ranges;
}

