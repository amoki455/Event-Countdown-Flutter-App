import 'package:flutter/material.dart';
import '../../split_card.dart';

class EventTitleField extends StatelessWidget {
  const EventTitleField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final hintTextColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.4);
    return SplitCard(
      top: const Text(
        "Event title",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: false,
          isDense: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: "Title of the event",
          hintStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: hintTextColor,
          ),
        ),
      ),
    );
  }
}
