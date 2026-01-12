library;

/// A constrained variant of Flutter's Material time picker.
///
/// This package provides [showCustomTimePicker], which behaves like Flutter's
/// built-in `showTimePicker` but restricts selection to a `[minTime, maxTime]`
/// range (inclusive). If `minTime` is later than `maxTime`, the range is
/// treated as crossing midnight (e.g. 22:00–02:00).
export 'src/custom_time_picker_material.dart' show CustomTimePickerDialog, showCustomTimePicker;
