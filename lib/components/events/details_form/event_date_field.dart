import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../split_card.dart';

class EventDateField extends StatelessWidget {
  const EventDateField({
    super.key,
    required this.currentValue,
    required this.onValueChanged,
  });

  final DateTime currentValue;
  final void Function(DateTime) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return SplitCard(
      top: const Text(
        "Event date",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: () {
          Get.dialog(
            DatePickerDialog(
              firstDate: DateTime(1900),
              lastDate: DateTime(3000),
              initialDate: currentValue,
            ),
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
            MaterialLocalizations.of(context).formatCompactDate(currentValue),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
