import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'time_component.dart';

class CountDownView extends StatefulWidget {
  const CountDownView({
    super.key,
    required this.timestampUTC,
    this.onFinished,
  });

  final DateTime timestampUTC;
  final void Function()? onFinished;

  @override
  State<CountDownView> createState() => _CountDownViewState();
}

class _CountDownViewState extends State<CountDownView> {
  late final _remainingDuration = _DurationComponents.remainingUntil(
    widget.timestampUTC,
  );

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Tooltip(
        waitDuration: const Duration(milliseconds: 700),
        message: DateFormat("yyyy-MM-dd HH:mm").format(widget.timestampUTC.toLocal()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 0,
              child: TimeComponent(
                name: "Days",
                value: _remainingDuration.days,
              ),
            ),
            Flexible(
              flex: 0,
              child: TimeComponent(
                name: "Hours",
                value: _remainingDuration.hours,
              ),
            ),
            Flexible(
              flex: 0,
              child: TimeComponent(
                name: "Minutes",
                value: _remainingDuration.minutes,
              ),
            ),
            Flexible(
              flex: 0,
              child: TimeComponent(
                name: "Seconds",
                value: _remainingDuration.seconds,
              ),
            ),
          ],
        ),
      ),
      secondChild: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                "Started • ${DateFormat("yyyy-MM-dd HH:mm").format(widget.timestampUTC.toLocal())}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      crossFadeState: _remainingDuration.isEmpty() ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (!_remainingDuration.isEmpty()) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        _timerCallback,
      );
    }
  }

  @override
  void didUpdateWidget(CountDownView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer?.cancel();
    _remainingDuration.until = widget.timestampUTC;
    _remainingDuration.update();
    _startTimer();
  }

  void _timerCallback(Timer _) {
    if (_remainingDuration.isEmpty()) {
      _timer?.cancel();
      if (widget.onFinished != null) {
        widget.onFinished!();
      }
    } else {
      setState(() {
        _remainingDuration.update();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}

class _DurationComponents {
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  int days = 0;

  DateTime until;

  _DurationComponents.remainingUntil(this.until) {
    update();
  }

  void update() {
    final dur = until.difference(DateTime.now().toUtc());
    if (dur.isNegative) {
      seconds = 0;
      minutes = 0;
      hours = 0;
      days = 0;
    } else {
      seconds = dur.inSeconds % 60;
      minutes = (dur.inSeconds ~/ 60) % 60;
      hours = (dur.inSeconds ~/ (60 * 60)) % 24;
      days = (dur.inSeconds ~/ (60 * 60 * 24));
    }
  }

  bool isEmpty() {
    return seconds == 0 && minutes == 0 && hours == 0 && days == 0;
  }
}
