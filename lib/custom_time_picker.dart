library;

/// A constrained variant of Flutter's Material time picker.
///
/// This package provides [showCustomTimePicker], which behaves like Flutter's
/// built-in `showTimePicker` but restricts selection to a `[minTime, maxTime]`
/// range (inclusive). If `minTime` is later than `maxTime`, the range is
/// treated as crossing midnight (e.g. 22:00–02:00).
export 'src/custom_time_picker_material.dart' show CustomTimePickerDialog, showCustomTimePicker;
export 'src/disabled_time_range.dart' show DisabledTimeRange;
export 'src/highlighted_time_range.dart' show HighlightedTimeRange;
export 'src/highlight_spec.dart' show HighlightSpec;
