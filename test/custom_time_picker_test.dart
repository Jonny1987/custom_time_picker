import 'package:custom_time_picker/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Harness extends StatefulWidget {
  const _Harness({
    required this.minTime,
    required this.maxTime,
    required this.initialTime,
    this.alwaysUse24HourFormat = true,
    this.entryMode = TimePickerEntryMode.inputOnly,
    this.disabledRanges = const <DisabledTimeRange>[],
  });

  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;
  final TimeOfDay initialTime;
  final bool alwaysUse24HourFormat;
  final TimePickerEntryMode entryMode;
  final List<DisabledTimeRange> disabledRanges;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  TimeOfDay? _selected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: widget.alwaysUse24HourFormat),
          child: child!,
        );
      },
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Text('selected: ${_selected?.format(context) ?? 'none'}'),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showCustomTimePicker(
                      context: context,
                      initialTime: widget.initialTime,
                      minTime: widget.minTime,
                      maxTime: widget.maxTime,
                      disabledRanges: widget.disabledRanges,
                      initialEntryMode: widget.entryMode,
                    );
                    setState(() => _selected = picked);
                  },
                  child: const Text('open'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  testWidgets('showCustomTimePicker clamps typed time above maxTime', (WidgetTester tester) async {
    await tester.pumpWidget(
      const _Harness(
        minTime: TimeOfDay(hour: 9, minute: 0),
        maxTime: TimeOfDay(hour: 17, minute: 0),
        initialTime: TimeOfDay(hour: 12, minute: 0),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final Finder fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '18');
    await tester.enterText(fields.at(1), '00');
    await tester.pump();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('selected: 17:00'), findsOneWidget);
  });

  testWidgets('showCustomTimePicker clamps typed time into a midnight-wrapping range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _Harness(
        minTime: TimeOfDay(hour: 22, minute: 0),
        maxTime: TimeOfDay(hour: 2, minute: 0),
        initialTime: TimeOfDay(hour: 23, minute: 0),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final Finder fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    // 10:00 is outside the allowed range [22:00–02:00], so it should clamp to
    // the closest boundary (02:00).
    await tester.enterText(fields.at(0), '10');
    await tester.enterText(fields.at(1), '00');
    await tester.pump();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('selected: 02:00'), findsOneWidget);
  });

  testWidgets('showCustomTimePicker does not restrict when minTime/maxTime omitted', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _Harness(
        minTime: null,
        maxTime: null,
        initialTime: TimeOfDay(hour: 12, minute: 0),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final Finder fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '23');
    await tester.enterText(fields.at(1), '00');
    await tester.pump();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('selected: 23:00'), findsOneWidget);
  });

  testWidgets('AM is disabled when range contains only PM times', (WidgetTester tester) async {
    await tester.pumpWidget(
      const _Harness(
        minTime: TimeOfDay(hour: 16, minute: 30),
        maxTime: TimeOfDay(hour: 17, minute: 0),
        initialTime: TimeOfDay(hour: 16, minute: 45),
        alwaysUse24HourFormat: false,
        entryMode: TimePickerEntryMode.dial,
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // This relies on the default English localizations.
    final Finder amText = find.text('AM');
    expect(amText, findsOneWidget);

    final Finder amInkWell = find.ancestor(of: amText, matching: find.byType(InkWell));
    expect(amInkWell, findsOneWidget);

    final InkWell inkWell = tester.widget<InkWell>(amInkWell);
    expect(inkWell.onTap, isNull);
  });

  testWidgets('disabledRanges blocks selection and snaps to nearest allowed time (input)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const _Harness(
        minTime: null,
        maxTime: null,
        initialTime: TimeOfDay(hour: 12, minute: 0),
        disabledRanges: <DisabledTimeRange>[
          DisabledTimeRange(start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 11, minute: 0)),
        ],
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final Finder fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), '10');
    await tester.enterText(fields.at(1), '00');
    await tester.pump();

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 10:00 is disabled; the picker searches forward first and should land on 11:01.
    expect(find.text('selected: 11:01'), findsOneWidget);
  });
}
