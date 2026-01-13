import 'package:flutter/material.dart';

/// A time-of-day range to disable inside [showCustomTimePicker].
///
/// If [start] is later than [end], the range is treated as crossing midnight
/// (e.g. 22:00–02:00).
class DisabledTimeRange {
  const DisabledTimeRange({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;
}


