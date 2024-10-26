import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../split_card.dart';

class EventTimeField extends StatelessWidget {
  const EventTimeField({
    super.key,
    required this.currentValue,
    required this.onValueChanged,
  });

  final TimeOfDay currentValue;
  final void Function(TimeOfDay) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return SplitCard(
      top: const Text(
        "Event time",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () {
          Get.dialog(
            TimePickerDialog(initialTime: currentValue),
          ).then(
            (value) {
              if (value == null) return;
              onValueChanged(value);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text(
            MaterialLocalizations.of(context).formatTimeOfDay(currentValue),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
