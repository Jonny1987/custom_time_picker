import 'package:flutter/material.dart';

/// A time-of-day range to visually highlight inside [showCustomTimePicker].
///
/// If [start] is later than [end], the range is treated as crossing midnight
/// (e.g. 22:00–02:00).
class HighlightedTimeRange {
  const HighlightedTimeRange({
    required this.start,
    required this.end,
  });

  final TimeOfDay start;
  final TimeOfDay end;
}

